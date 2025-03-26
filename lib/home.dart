import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WebViewController controller = WebViewController();

  bool isOpen = false;
  List contactList = [];

  Future<void> pickMultiplePhotos() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetEntity> images = await PhotoManager.getAssetListRange(
        start: 0,
        end: 100, // 최대 100개 이미지 가져오기
        type: RequestType.image,
      );

      for (var img in images) {
        print("선택된 이미지: ${img.id}");
      }
    } else {
      print("갤러리 접근 권한이 필요합니다.");
    }
  }

  Future<void> getContacts() async {
    // 1️⃣ 연락처 접근 권한 요청
    if (await FlutterContacts.requestPermission()) {
      // 2️⃣ 연락처 목록 가져오기
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );

      // 3️⃣ 연락처 출력
      for (var contact in contacts) {
        contactList.add({
          'name': contact.displayName,
          'number':
              contact.phones.isNotEmpty ? contact.phones.first.number : '없음',
        });

        print(contactList);

        setState(() {});
      }
    } else {
      print("연락처 접근 권한이 거부됨");
    }
  }

  void inputPopupMenu() {
    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Container(
            color: Colors.green,
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      bottomSheetMenu();
                    },
                    child: Text('첨부파일요'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(contactList);
                    },
                    child: Text('연락처 선택'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isOpen = !isOpen;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('닫아~~'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void bottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          height: 180,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '첨부하기',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print('사진첩');
                        pickMultiplePhotos();
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(74, 145, 205, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '사진첩',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print('파일');
                        getContacts();
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(74, 145, 205, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '파일',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void scriptCheck() {
    setState(() {
      isOpen = !isOpen;

      if (isOpen) {
        inputPopupMenu();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                print("Received from Web: ${message.message}");
                scriptCheck();
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
                window.FlutterChannel.postMessage("Hello from HTML!");
              } else {
                console.log("FlutterChannel is not available.");
              }
            }
          </script>
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(child: WebViewWidget(controller: controller)),
      ),
    );
  }
}
