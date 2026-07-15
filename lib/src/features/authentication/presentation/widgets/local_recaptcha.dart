import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaV2Controller extends ChangeNotifier {
  bool isDisposed = false;
  VoidCallback? onReload;

  void reload() {
    if (!isDisposed) onReload?.call();
  }

  @override
  void dispose() {
    isDisposed = true;
    onReload = null;
    super.dispose();
  }
}

class RecaptchaV2 extends StatefulWidget {
  final String apiKey;
  final String apiSecret;
  final String pluginURL = "https://recaptcha-flutter-plugin.firebaseapp.com/";
  final RecaptchaV2Controller controller;
  final String themeMode;
  final Color backgroundColor;

  final ValueChanged<bool>? onVerifiedSuccessfully;
  final ValueChanged<String>? onVerifiedError;

  final EdgeInsetsGeometry? padding;

  const RecaptchaV2({
    Key? key,
    required this.apiKey,
    required this.apiSecret,
    required this.controller,
    this.themeMode = 'light',
    this.backgroundColor = Colors.transparent,
    this.onVerifiedSuccessfully,
    this.onVerifiedError,
    this.padding,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecaptchaV2State();
}

class _RecaptchaV2State extends State<RecaptchaV2>
    with TickerProviderStateMixin {
  late RecaptchaV2Controller controller;
  late WebViewController webViewController;

  bool isShowing = false;
  bool isVerified = false;
  Offset? _pointerDownLocation;

  void verifyToken(String token) async {
    String url = "https://www.google.com/recaptcha/api/siteverify";
    http.Response response = await http.post(Uri.parse(url), body: {
      "secret": widget.apiSecret,
      "response": token,
    });

    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      if (json['success']) {
        widget.onVerifiedSuccessfully?.call(true);
        if (mounted) {
          setState(() {
            isVerified = true;
          });
        }
      } else {
        widget.onVerifiedSuccessfully?.call(false);
        widget.onVerifiedError?.call(json['error-codes'].toString());
        if (mounted) {
          setState(() {
            isVerified = false;
          });
        }
      }
    }
    // hide captcha
    _hide();
  }

  void _show() {
    if (mounted) {
      setState(() {
        isShowing = true;
      });
    }
  }

  void _hide() {
    if (mounted) {
      setState(() {
        isShowing = false;
      });
    }
  }

  void _reload() {
    if (!isVerified) {
      webViewController.clearCache();
      webViewController.reload();
      _hide();
    }
  }

  @override
  void initState() {
    controller = widget.controller;
    controller.onReload = _reload;
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'RecaptchaFlutterChannel',
        onMessageReceived: (JavaScriptMessage receiver) {
          String _token = receiver.message;
          if (_token.contains("verify")) {
            _token = _token.substring(7);
          }
          verifyToken(_token);
        },
      )
      ..loadHtmlString('''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
  <style>
    body {
      margin: 0;
      padding: 0;
      display: flex;
      justify-content: center;
      align-items: flex-start;
      padding-top: 5px;
      min-height: 100vh;
      background-color: #${widget.backgroundColor.value.toRadixString(16).substring(2, 8).toUpperCase()};
    }
  </style>
</head>
<body>
  <div class="g-recaptcha" 
       data-sitekey="${widget.apiKey}" 
       data-theme="${widget.themeMode}"
       data-callback="captchaCallback" 
       data-expired-callback="captchaExpired">
  </div>
  <script>
    function captchaCallback(response) {
      RecaptchaFlutterChannel.postMessage("verify_" + response);
    }
    function captchaExpired() {
      RecaptchaFlutterChannel.postMessage("expired");
    }
  </script>
</body>
</html>
      ''', baseUrl: widget.pluginURL);
  }

  @override
  void didUpdateWidget(RecaptchaV2 oldWidget) {
    if (widget.controller != oldWidget.controller) {
      controller = widget.controller;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.onReload = null;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: widget.padding,
        height: isShowing ? 500 : 90,
        child: Stack(
          children: [
            WebViewWidget(controller: webViewController),
            // Use Listener instead of GestureDetector to prevent consuming pointer events on Android
            Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (event) {
                _pointerDownLocation = event.position;
              },
              onPointerUp: (event) {
                if (!isVerified && _pointerDownLocation != null) {
                  final distance = (event.position - _pointerDownLocation!).distance;
                  // If the finger moved less than 15 pixels, consider it a tap (not a scroll)
                  if (distance < 15) {
                    _show();
                  }
                }
                _pointerDownLocation = null;
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
