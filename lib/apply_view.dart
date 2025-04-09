import 'package:flutter/material.dart';
import 'package:webconnect/alert.dart';
import 'package:webconnect/attach_image_files_widget.dart';
import 'package:webconnect/check_view.dart';
import 'package:webconnect/info.dart';
import 'package:webconnect/infomation_contact.dart';
import 'package:webconnect/theme_color.dart';

class ApplyInfo {
  final String code;
  final String title;
  final int imgCount;
  final int fileCount;
  final int maxMegaBytes;

  ApplyInfo({
    required this.code,
    required this.title,
    required this.imgCount,
    required this.fileCount,
    required this.maxMegaBytes,
  });
}

class ApplyView extends StatefulWidget {
  final ApplyInfo applyInfo;
  const ApplyView({super.key, required this.applyInfo});

  @override
  State<ApplyView> createState() => _ApplyViewState();
}

class _ApplyViewState extends State<ApplyView> {
  ThemeColor _themeColor = ThemeColor();
  String code = '';
  String title = '';
  int imgCount = 0;
  int fileCount = 0;
  int maxMegaBytes = 0;

  /* 주소록 - 성명, 전화번호 */
  String name = '';
  String number = '';
  bool isNumberCheck = false;

  /* 첨부파일 - 이미지, 파일, 심사 고객동의 */
  List imageList = [];
  List fileList = [];
  bool check = false;

  @override
  void initState() {
    code = widget.applyInfo.code;
    title = widget.applyInfo.title;
    imgCount = widget.applyInfo.imgCount;
    fileCount = widget.applyInfo.fileCount;
    maxMegaBytes = widget.applyInfo.maxMegaBytes;

    super.initState();
  }

  void updateContactInfo(String newName, String newNumber) {
    setState(() {
      name = newName;
      number = newNumber;
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

  dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
  bool isValidPhoneNumberFormat(String number) {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(number);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dismissKeyboard();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  Container(
                    height: 44,
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
                              width: 44,
                              height: 44,
                              padding: EdgeInsets.all(12),
                              color: Colors.white,
                              child: Image.asset('assets/images/close.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            // 상태(웹에서 온 일련번호 및 타이틀)
                            Info(code: code, title: title),
                            Divider(color: Colors.grey, thickness: 0.1),
                            // 주소록
                            InfomationContact(
                              parentContext: context,
                              onValueChanged: updateContactInfo,
                            ),
                            Divider(color: Colors.grey, thickness: 0.1),
                            // 첨부파일
                            AttachImageFilesWidget(
                              parentContext: context,
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
                    height: 60,
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
                        dismissKeyboard();
                        // Navigator.pop(context);
                        print('name: $name');
                        print('number: $number');
                        print('imageList length: ${imageList.length}');
                        print('fileList length: ${fileList.length}');
                        print('check(심사동의): $check');

                        isNumberCheck = isValidPhoneNumberFormat(number);

                        if (number == '' || isNumberCheck == false) {
                          Alert().showAlertDialog(context, '전화번호를 확인해 주십시오.');
                          return;
                        }

                        if (imageList.length + fileList.length <= 0) {
                          Alert().showAlertDialog(context, '첨부파일 1개이상 등록해 주십시오.');
                          return;
                        }

                        if (check == false) {
                          Alert().showAlertDialog(
                            context,
                            '심사조회를 위해 고객동의 확인해 주십시오.',
                          );
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
          ),
        ),
      ),
    );
  }
}
