import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyView extends StatefulWidget {
  const PrivacyView({super.key});

  @override
  State<PrivacyView> createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'FlutterChannel', // 웹에서 호출할 채널 이름
            onMessageReceived: (JavaScriptMessage message) {
              // JavaScript에서 보낸 메시지 처리
              if (message.message != '') {
                // JSON 데이터를 파싱하여 사용
                final Map<String, dynamic> data = jsonDecode(message.message);
                code = data['code'];
                title = data['title'];

                debugPrint('Flutter에서 받은 데이터: code=$code, title=$title');

                _showMyDialog();
              }
            },
          )
          ..loadRequest(
            Uri.dataFromString(
              """
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Flutter WebView</title>
        </head>
        <body>
          <h1>Hello, WebView!</h1>
          <button onclick="sendMessageToFlutter()">Send to Flutter</button>
          <script>
            function sendMessageToFlutter() {
              if (window.FlutterChannel) {
                 const data = {
                    code: "20250331_0001",
                    title: "견적을 부탁 드립니다."
                };
                window.FlutterChannel.postMessage(JSON.stringify(data));
              } else {
                console.log("FlutterChannel is not available.");
              }
            }
          </script>
          <p>code: 20250331_0001</p>
          <p>title: 견적을 부탁 드립니다.</p>
        </body>
        </html>
        """,
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ),
          );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
