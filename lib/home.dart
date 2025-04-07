import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webconnect/alert.dart';
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
  int imgCount = 0;
  int fileCount = 0;
  int maxMegaBytes = 0;

  /* 주소록 - 성명, 전화번호 */
  String name = '';
  String number = '';
  bool contactCheck = false;

  /* 첨부파일 - 이미지, 파일, 심사 고객동의 */
  List imageList = [];
  List fileList = [];
  bool check = false;

  void updateContactInfo(String newName, String newNumber, bool isCheck) {
    setState(() {
      name = newName;
      number = newNumber;
      contactCheck = isCheck;
    });
  }

  void updateFileInfo(List newImageList, List newFileList, bool newCheck) {
    setState(() {
      imageList = newImageList;
      fileList = newFileList;
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
                          // 상태(웹에서 온 일련번호 및 타이틀)
                          Info(code: code, title: title),
                          Divider(color: Colors.grey, thickness: 0.1),
                          // 주소록
                          InfomationContact(onValueChanged: updateContactInfo),
                          Divider(color: Colors.grey, thickness: 0.1),
                          // 첨부파일
                          AttachImageFilesWidget(
                            onValueChanged: updateFileInfo,
                            attachConfig: AttachConfig(
                              imageMaxCount: imgCount,
                              fileMaxCount: fileCount,
                              maxSize: maxMegaBytes,
                            ),
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
                      print('정규식 : $contactCheck');
                      print('check(심사동의): $check');

                      if (name == '' || number == '' || contactCheck == false) {
                        Alert().showAlertDialog(context, '성명 및 전화번호를 확인해 주십시오.');
                        return;
                      }

                      if (check == false) {
                        Alert().showAlertDialog(context, '심사조회를 위해 고객동의 확인해 주십시오.');
                        return;
                      }

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
                imgCount = int.parse(data['imgCount']);
                fileCount = int.parse(data['fileCount']);
                maxMegaBytes = int.parse(data['byte']);

                // 초기화
                name = '';
                number = '';
                contactCheck = false;
                imageList.clear();
                fileList.clear();
                check = false;

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
