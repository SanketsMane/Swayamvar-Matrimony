import 'dart:convert';
import 'dart:developer';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/components/group_item.dart';
import 'package:active_matrimonial_flutter_app/screens/contact_us/contact_us_middleware.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../components/common_app_bar.dart';
import '../../components/my_gradient_container.dart';
import '../../const/my_theme.dart';
import '../../const/style.dart';
import '../../helpers/main_helpers.dart';
import '../core.dart';
import 'contact_us_action.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool _isRecaptchaActive = false;
  late final WebViewController _controller;
  final String _recaptchaUrl = "${AppConfig.BASE_URL}/google-recaptcha";

  @override
  void initState() {
    super.initState();
    _isRecaptchaActive = settingIsActive(
      'recaptcha_contact_form',
      '1',
    );
    if (_isRecaptchaActive) {
      _setupWebViewController();
    }
  }

  void _setupWebViewController() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..addJavaScriptChannel(
            'Captcha',
            onMessageReceived: (JavaScriptMessage message) {
              log("reCAPTCHA v3 Token Received: ${message.message}");
              if (message.message.isNotEmpty && message.message != "error") {
                store.dispatch(
                  SetContactUsKeyValueAction(keyValuePayload: message.message),
                );
              }
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                if (request.url == _recaptchaUrl) {
                  return NavigationDecision.navigate;
                } else {
                  _launchUrl(request.url);
                  return NavigationDecision.prevent;
                }
              },
            ),
          )
          ..loadRequest(Uri.parse(_recaptchaUrl));
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      log('Could not launch $url');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the page.')),
        );
      }
    }
  }

  bool requiredFieldVerification() {
    var value =
        store.state.contactUsState!.emailController!.text.trim().toString();

    if (store.state.contactUsState!.nameController!.text
        .trim()
        .toString()
        .isEmpty) {
      store.dispatch(ShowMessageAction(msg: "Name Can't be empty"));
      return false;
    } else if (store.state.contactUsState!.emailController!.text
        .trim()
        .toString()
        .isEmpty) {
      store.dispatch(ShowMessageAction(msg: "Email Can't be empty"));

      return false;
    } else if (store.state.contactUsState!.subjectController!.text
        .trim()
        .toString()
        .isEmpty) {
      store.dispatch(ShowMessageAction(msg: "Subject Can't be empty"));

      return false;
    } else if (store.state.contactUsState!.descriptionController!.text
        .trim()
        .toString()
        .isEmpty) {
      store.dispatch(ShowMessageAction(msg: "Description Can't be empty"));

      return false;
    }
    // Check for reCAPTCHA key only if it's active for this form
    else if (_isRecaptchaActive &&
        store.state.contactUsState!.googleRecaptchaKey == "") {
      store.dispatch(ShowMessageAction(msg: "Google reCAPTCHA is required"));
      return false;
    } else if (!RegExp(
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
    ).hasMatch(value)) {
      store.dispatch(ShowMessageAction(msg: "Enter a Valid Email Address"));
      return false;
    }
    return true;
  }

  String? name, email, subject, description, gCaptcha;
  void setValues() {
    name = store.state.contactUsState!.nameController!.text.trim();
    email = store.state.contactUsState!.emailController!.text.trim();
    subject = store.state.contactUsState!.subjectController!.text.trim();
    description =
        store.state.contactUsState!.descriptionController!.text.trim();
    gCaptcha = store.state.contactUsState!.googleRecaptchaKey;
  }

  Future<void> send() async {
    if (!requiredFieldVerification()) {
      return;
    }
    setValues();
    Map postValue = {};
    postValue.addAll({
      "name": name,
      "email": email,
      "subject": subject,
      "description": description,
    });
    if (_isRecaptchaActive) {
      postValue["g-recaptcha-response"] = gCaptcha;
    }
    var postBody = jsonEncode(postValue);
    store.dispatch(contactUsMiddleware(postBody: postBody, context: context));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder:
          (_, state) => Scaffold(
            appBar: CommonAppBar(
              text: AppLocalizations.of(context)!.contact_us,
            ).build(context),
            body: buildBody(state),
          ),
    );
  }

  Widget buildBody(AppState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Const.kPaddingHorizontal,
          vertical: 10.0,
        ),
        child: Column(
          children: [
            Text('Can we help you?', style: Styles.bold_storm_grey_20),
            itemSpacer(height: 20.0),
            Column(
              children: [
                GroupItem(
                  name: "Name",
                  hintText: "Enter your full name",
                  controller: state.contactUsState!.nameController,
                ),
                itemSpacer(),
                GroupItem(
                  name: "Email",
                  hintText: "Enter your E-mail",
                  helperText:
                      "Please, enter the email address where you wish to receive our answer.",
                  controller: state.contactUsState!.emailController,
                ),
                itemSpacer(height: 14.0),
                GroupItem(
                  name: 'Subject',
                  hintText: "Write the subject here",
                  controller: state.contactUsState!.subjectController,
                ),
                itemSpacer(height: 14.0),
                GroupItem(
                  name: "Description",
                  hintText: "Write your description here",
                  minLines: 6,
                  keyboardType: TextInputType.multiline,
                  controller: state.contactUsState!.descriptionController,
                ),
                itemSpacer(height: 14.0),
                // Conditionally display the reCAPTCHA widget
                if (_isRecaptchaActive)
                  SizedBox(
                    height: 90,
                    width: double.infinity,
                    child: WebViewWidget(controller: _controller),
                  ),
                itemSpacer(height: 20.0),
                buildSendBtn(state),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSendBtn(AppState state) {
    return GestureDetector(
      onTap: send,
      child: MyGradientContainer(
        text:
            !state.contactUsState!.isSubmit
                ? Text("Send", style: Styles.bold_white_14)
                : CircularProgressIndicator(color: MyTheme.storm_grey),
      ),
    );
  }

  SizedBox itemSpacer({height = 10.0}) {
    return SizedBox(height: height);
  }
}
