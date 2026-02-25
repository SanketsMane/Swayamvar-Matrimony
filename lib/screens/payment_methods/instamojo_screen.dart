
import 'dart:convert';

import 'package:active_matrimonial_flutter_app/components/common_app_bar.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/main.dart';
import 'package:active_matrimonial_flutter_app/repository/payment_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/account/account_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/wallet/my_wallet.dart';
import 'package:active_matrimonial_flutter_app/screens/package/package_history.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:one_context/one_context.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/main_helpers.dart';
import '../../helpers/shared_pref.dart';
import '../../redux/libs/helpers/show_message_state.dart';

class InstamojoScreen extends StatefulWidget {
  final String? amount;
  final String? payment_type;
  final String? payment_method_key;
  final String? package_id;

  const InstamojoScreen({
    super.key,
    this.amount,
    this.payment_type,
    this.payment_method_key,
    this.package_id,
  });

  @override
  State<InstamojoScreen> createState() => _InstamojoScreenState();
}

class _InstamojoScreenState extends State<InstamojoScreen> {
  String? _initial_url;
  var accessToken = getToken;
  var userId = store.state.authState!.userData!.id!;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController();
    getSetInitialUrl();
  }

  void setupWebView() {
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('intent://')) {
              _launchExternalURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
          },
          onPageFinished: (page) {
            if (page.contains("/instamojo/payment/done")) {
              getData();
            } else if (page.contains("/instamojo/payment/cancel")) {
              Navigator.of(context).pop();
            }
          },
        ),
      );
  }

  getSetInitialUrl() async {
    try {
      Map instamojoUrlResponse =
      await (PaymentRepository().getInstamojoUrlResponse(
        amount: widget.amount.toString(),
        payment_method: widget.payment_method_key,
        payment_type: widget.payment_type,
        package_id: widget.package_id,
        userId: userId,
      ));

      if (instamojoUrlResponse.keys.first == false) {
        store.dispatch(
          ShowMessageAction(msg: instamojoUrlResponse.values.elementAt(2)),
        );
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      String? url = instamojoUrlResponse.values.elementAt(1);
      if (url != null && url.isNotEmpty) {
        _initial_url = url;
        setupWebView();
        _webViewController.loadRequest(
          Uri.parse(_initial_url!),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        );
        if (mounted) {
          setState(() {});
        }
      } else {
        store.dispatch(ShowMessageAction(msg: "Could not retrieve payment URL."));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      store.dispatch(ShowMessageAction(msg: "An error occurred: $e"));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        text: AppLocalizations.of(context)!.instamojo_screen_title,
      ).build(context),
      body: buildBody(),
    );
  }

  void getData() {
    _webViewController
        .runJavaScriptReturningResult("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data as String);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      if (responseJSON["result"] == false) {
        store.dispatch(ShowMessageAction(msg: responseJSON["message"]));
        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        store.dispatch(ShowMessageAction(msg: responseJSON["message"]));
        if (widget.payment_type == "wallet_payment") {
          OneContext().navigator.pushReplacement(
            MaterialPageRoute(
              builder: (context) => MyWallet(from_wallet: true),
            ),
          );
        } else if (widget.payment_type == "package_payment") {
          store.dispatch(accountMiddleware());
          NavigatorPush.push_replace(
            page: PackageHistory(from_package: true),
          );
        }
      }
    });
  }

  Future<void> _launchExternalURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Could not open the payment app. Please ensure it is installed.')),
        );
      }
    }
  }

  Widget buildBody() {
    return _initial_url != null && _initial_url!.isNotEmpty
        ? WebViewWidget(controller: _webViewController)
        : const Center(
      child: CircularProgressIndicator(),
    );
  }
}