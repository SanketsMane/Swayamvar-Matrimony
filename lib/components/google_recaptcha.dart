import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../app_config.dart';
import '../helpers/device_info.dart';

class Captcha extends StatefulWidget {
  final Function callback;
  final Function? handleCaptcha;
  final bool isIOS;

  const Captcha(this.callback, {super.key, this.handleCaptcha, this.isIOS = false});

  @override
  State<StatefulWidget> createState() {
    return CaptchaState();
  }
}

class CaptchaState extends State<Captcha> {
  final WebViewController _webViewController = WebViewController();
  double zoomValue = 2;

  Future<void> _onLoadFlutterAssetExample(
    WebViewController controller,
    BuildContext context,
  ) async {}

  @override
  initState() {
    if (widget.isIOS) {
      zoomValue = 0.5;
    }

    google_recaptcha();
    super.initState();
  }

  void google_recaptcha() {
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..loadHtmlString(html(AppConfig.BASE_URL)).then((value) {
        _webViewController
          ..addJavaScriptChannel(
            'Captcha',
            onMessageReceived: (JavaScriptMessage message) {
              widget.callback(message.message);
            },
          )
          ..addJavaScriptChannel(
            'CaptchaShowValidation',
            onMessageReceived: (JavaScriptMessage message) {
              bool value = message.message == "true";
              widget.handleCaptcha!(value);
            },
          );
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _webViewController.removeJavaScriptChannel("CaptchaShowValidation");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DeviceInfo(context).width,
      height: 150,
      child: WebViewWidget(controller: _webViewController),
    );
  }

  String html(url) {
    print(url);
    return '''
<!DOCTYPE html>
<html>
  <head>
    <title>Title of the document</title>
    <style>
      #wrap {
        width: 1000px;
        height: 1500px;
        padding: 0;
        overflow: hidden;
      }
      #scaled-frame {
        width: 1000px;
        height: 2000px;
        border: 0px;
      }
      #scaled-frame {
        zoom: 2;
        -moz-transform: scale(2);
        -moz-transform-origin: 0 0;
        -o-transform: scale(2);
        -o-transform-origin: 0 0;
        -webkit-transform: scale($zoomValue);
        -webkit-transform-origin: 0 0;
      }
      @media screen and (-webkit-min-device-pixel-ratio:0) {
        #scaled-frame {
          zoom: 1;
        }
      }
    </style>
  </head>
  <body>
    <div id="wrap">
	
	<iframe id="scaled-frame" src="$url/google-recaptcha" allowfullscreen></iframe>
    </div>
  </body>
</html>
    ''';
  }
}
