import 'dart:convert';
import 'dart:developer';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/components/common_app_bar.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/wallet/my_wallet.dart';
import 'package:active_matrimonial_flutter_app/screens/package/package_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import '../account/account.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';

class PhonePeScreen extends StatefulWidget {
  final dynamic amount;
  final String payment_type;
  final String? payment_method_key;
  final String package_id;

  const PhonePeScreen({
    super.key,
    this.amount = 0.00,
    this.payment_type = "",
    this.payment_method_key = "",
    this.package_id = "0",
  });

  @override
  State<PhonePeScreen> createState() => _PhonePeScreenState();
}

class _PhonePeScreenState extends State<PhonePeScreen> {
  String _mode = "";
  final String _appSchema = "yourappschema";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCredentialsAndInitiatePayment();
    });
  }

  //Get Createdtials from Backend
  Future<void> _fetchCredentialsAndInitiatePayment() async {
    var accessToken = SharedPref().accessToken;
    try {
      final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/phonepe-credentials"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('client_id') && data['client_id'] != null) {
          log("Detected PhonePe V2 Credentials. Starting V2 flow.");
          _initiateV2Payment(data);
        } else {
          showError("Invalid or incomplete PhonePe credentials from server.");
        }
      } else {
        log("Failed to fetch credentials");
        showError("Failed to fetch credentials from server.");
      }
    } catch (e) {
      log("Error fetching credentials: $e");
      showError("A network error occurred while fetching credentials.");
    }
  }

  //Get token from backend
  Future<void> _initiateV2Payment(Map<String, dynamic> credentials) async {
    String merchantId = credentials["client_id"];
    _mode = credentials["mode"] ?? "SANDBOX";
    final store = StoreProvider.of<AppState>(context, listen: false);
    var accessToken = SharedPref().accessToken;

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/pay-with-phonepe"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "user_id": store.state.authState?.userData?.id?.toString() ?? "0",
          "payment_type": widget.payment_type,
          "amount": widget.amount,
          "package_id": widget.package_id,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String token = data['token'];
        final String orderId = data['orderId'];
        final String accessToken = data['accessToken'];
        final String merchantTransactionId = data['merchantTransactionId'];

        bool isInitialized = await PhonePePaymentSdk.init(
          _mode,
          merchantId,
          _appSchema,
          true,
        );
        if (isInitialized) {
          log('PhonePe SDK Initialized for V2');
          _startV2Transaction(
            token,
            orderId,
            merchantId,
            _appSchema,
            accessToken,
            merchantTransactionId,
          );
        } else {
          showError("Failed to initialize PhonePe SDK for V2 payment.");
        }
      } else {
        log("Failed to get token from server");
        showError("Could not start payment. Please try again.");
      }
    } catch (e) {
      log("Error during V2 payment initiation: $e");
      showError("An error occurred. Please try again.");
    }
  }

  //Start Transection
  void _startV2Transaction(
    String token,
    String orderId,
    String merchantId,
    String appSchema,
    String accessToken,
    String merchantTransactionId,
  ) async {
    try {
      Map<String, dynamic> payload = {
        "orderId": orderId,
        "merchantId": merchantId,
        "token": token,
        "paymentMode": {"type": "PAY_PAGE"},
      };
      String requestPayload = jsonEncode(payload);

      Map<dynamic, dynamic>? response =
          await PhonePePaymentSdk.startTransaction(requestPayload, appSchema);

      if (response != null) {
        String status = response['status'].toString();

        if (status == 'SUCCESS') {
          log("V2 Payment Success: $response");

          Map<String, dynamic> dataPayload = {
            "merchantOrderId": orderId,
            "accessToken": accessToken,
            "merchantTransactionId": merchantTransactionId,
          };

          Map<String, dynamic> callbackPayload = {"data": dataPayload};
          String jsonPayload = jsonEncode(callbackPayload);
          String base64Payload = base64Encode(utf8.encode(jsonPayload));
          await notifyServerOfSuccess(base64Payload);
          navigateToSuccessScreen();
        } else {
          log("V2 Payment Failed: $response");
          handlePaymentFailure();
        }
      } else {
        log("V2 Payment Failed or Cancelled: No response from SDK.");
        handlePaymentFailure();
      }
    } catch (e) {
      log("V2 Transaction Error: $e");
      handlePaymentFailure();
    }
  }

  //notify the payment status
  Future<void> notifyServerOfSuccess(String encodedPayload) async {
    var accessToken = SharedPref().accessToken;
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/phonepe/callbackUrl"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"response": encodedPayload}),
      );

      if (response.statusCode == 200) {
        log("Server callback successful: ${response.body}");
      } else {
        log("Server callback failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      log("Error notifying server via callback: $e");
    }
  }

  void navigateToSuccessScreen() {
    if (!mounted) return;

    if (widget.payment_type == "wallet_payment") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Account()),
        (route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyWallet(from_wallet: true)),
      );
    } else if (widget.payment_type == "package_payment") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Account()),
        (route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PackageHistory(from_package: true),
        ),
      );
    } else {
      Navigator.pop(context, true);
    }
  }

  void handlePaymentFailure() {
    if (!mounted) return;
    Navigator.pop(context);
  }

  void showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text("Payment Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return Scaffold(
          appBar: CommonAppBar(
            text: AppLocalizations.of(context)!.phonepe_screen_title,
          ).build(context),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Initiating Payment..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
