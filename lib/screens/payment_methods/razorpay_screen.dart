import 'dart:convert';

import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/components/common_app_bar.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/wallet/my_wallet.dart';
import 'package:active_matrimonial_flutter_app/screens/package/package_history.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:one_context/one_context.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/main_helpers.dart';
import '../../main.dart';
import '../../redux/libs/helpers/show_message_state.dart';
import '../account/account_middleware.dart';

class RazorpayScreen extends StatefulWidget {
  var amount;
  String? payment_type;
  String? payment_method_key;
  String? package_id;

  RazorpayScreen({
    super.key,
    this.amount,
    this.payment_type,
    this.payment_method_key,
    this.package_id,
  });

  @override
  State<RazorpayScreen> createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> {
  late String initialUrl;
  late WebViewController _webViewController;

  String? accessToken = getToken;
  var userId;

  @override
  void initState() {
    super.initState();

    if (accessToken == null) {
      print("Access Token is null");
      return;
    }
    var authState = store.state.authState;
    if (authState?.userData?.id == null) {
      print("User ID is null");
      return;
    }
    userId = authState!.userData!.id!;

    _webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onWebResourceError: (error) {
                print("Web resource error: ${error.description}");
              },
              onPageFinished: (page) {
                if (page.contains("/razorpay/success")) {
                  getData();
                } else if (page.contains("/razorpaye/cancel")) {
                  Navigator.of(context).pop();
                }
              },
            ),
          );

    initialUrl =
        "${AppConfig.BASE_URL}/razorpay/pay-with-razorpay?amount=${widget.amount}&payment_method=${widget.payment_method_key}&payment_type=${widget.payment_type}&package_id=${widget.package_id}&user_id=$userId";

    initializeAccessToken().then((_) => razorpay());
  }

  Future<void> initializeAccessToken() async {
    accessToken = await getToken;

    if (accessToken == null) {
      print("Access Token is still null after fetch");
      return;
    }
  }

  razorpay() {

    if (initialUrl == null) {
      print("Initial URL is null");
      return;
    }

    print("Loading URL: $initialUrl");

    _webViewController.loadRequest(
      Uri.parse(initialUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  void getData() async {
    String rawData =
        await _webViewController.runJavaScriptReturningResult(
              "document.body.innerText",
            )
            as String;
    rawData = rawData
        .replaceAll("\\\"", "\"")
        .replaceAll("\"{", "{")
        .replaceAll("}\"", "}");

    try {
      Map<String, dynamic> responseJSON = jsonDecode(rawData);

      if (responseJSON["result"] == false) {
        store.dispatch(ShowMessageAction(msg: responseJSON["message"]));
        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        store.dispatch(ShowMessageAction(msg: responseJSON["message"]));
        handleNavigation();
      }
    } catch (e) {
      print("Error parsing JSON: $e");
    }
  }

  void handleNavigation() {
    if (widget.payment_type == "wallet_payment") {
      NavigatorPush.push_remove_untill(page: MyWallet(from_wallet: true));
      OneContext().navigator.push(
        MaterialPageRoute(builder: (context) => MyWallet(from_wallet: true)),
      );
    } else if (widget.payment_type == "package_payment") {
      store.dispatch(accountMiddleware());

      OneContext().navigator.push(
        MaterialPageRoute(
          builder: (context) => PackageHistory(from_package: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        text: AppLocalizations.of(context)!.razorpay_screen_title,
      ).build(context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }
}
