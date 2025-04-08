import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webconnect/alert.dart';
import 'package:webconnect/apply_view.dart';
import 'package:webconnect/check_view.dart';
import 'package:webconnect/theme_color.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'infomation_contact.dart';
import 'attach_image_files_widget.dart';
import 'info.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WebViewController controller = WebViewController();
  String code = '';
  String title = '';
  int imgCount = 0;
  int fileCount = 0;
  int maxMegaBytes = 0;

  void applyView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ApplyView(
              applyInfo: ApplyInfo(
                code: code,
                title: title,
                imgCount: imgCount,
                fileCount: fileCount,
                maxMegaBytes: maxMegaBytes,
              ),
            ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

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
                imgCount = int.parse(data['imgCount']);
                fileCount = int.parse(data['fileCount']);
                maxMegaBytes = int.parse(data['byte']);

                applyView();
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
              const codeText = document.getElementById("code").innerText;
              const titleText = document.getElementById("title").innerText;
              const imgCount = document.getElementById("imgCount").innerText;
              const fileCount = document.getElementById("fileCount").innerText;
              const byte = document.getElementById("byte").innerText;

              if (window.FlutterChannel) {
                 const data = {
                    code: codeText,
                    title: titleText,
                    imgCount: imgCount,
                    fileCount: fileCount,
                    byte: byte
                  };
                window.FlutterChannel.postMessage(JSON.stringify(data));
              } else {
                console.log("FlutterChannel is not available.");
              }
            }
          </script>
          <p id="code">20250331_0001</p>
          <p id="title">견적을 부탁 드립니다.</p>
          <div style="display: flex; align-items: center;">
          이미지 개수 :&nbsp; <p id="imgCount">5</p>
          </div>
           <div style="display: flex; align-items: center;">
          파일 개수 :&nbsp; <p id="fileCount">5</p>
          </div>
           <div style="display: flex; align-items: center;">
          용량 제한 :&nbsp; <p id="byte">5</p>
          </div>
        </body>
        </html>
        """,
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox(child: WebViewWidget(controller: controller)),
        ),
      ),
    );
  }
}
