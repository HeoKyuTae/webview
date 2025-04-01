import 'dart:convert';
import 'package:flutter/material.dart';
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
  ThemeColor _themeColor = ThemeColor();
  String code = '';
  String title = '';

  /* 주소록 - 성명, 전화번호 */
  String name = '';
  String number = '';

  /* 첨부파일 - 이미지, 파일, 심사 고객동의 */
  List imageList = [];
  List fileList = [];
  bool check = false;

  void updateContactInfo(String newName, String newNumber) {
    setState(() {
      name = newName;
      number = newNumber;
    });
  }

  void updateFileInfo(List newImageList, List newFileTitle, bool newCheck) {
    setState(() {
      imageList = newImageList;
      fileList = newFileTitle;
      check = newCheck;
    });
  }

  void checkView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CheckView(
              code: code,
              title: title,
              name: name,
              number: number,
              imageList: imageList,
              fileList: fileList,
              check: check,
            ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;

        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            title: Container(
              height: 30,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '심사조회요청',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(4),
                        color: Colors.white,
                        child: Image.asset('assets/images/close.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width,
                      child: Column(
                        children: [
                          Info(code: code, title: title),
                          Divider(color: Colors.grey, thickness: 0.1),
                          InfomationContact(onValueChanged: updateContactInfo),
                          Divider(color: Colors.grey, thickness: 0.1),
                          AttachImageFilesWidget(
                            onValueChanged: updateFileInfo,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: _themeColor.themeColor,
                      minimumSize: Size(200, 35),
                    ),
                    onPressed: () {
                      // Navigator.pop(context);
                      print('name: $name');
                      print('number: $number');
                      print('imageList length: ${imageList.length}');
                      print('fileList length: ${fileList.length}');
                      print('check(심사동의): $check');

                      checkView();
                    },
                    child: Text(
                      '요청하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
