import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AttachImageFilesWidget extends StatefulWidget {
  const AttachImageFilesWidget({super.key});

  @override
  State<AttachImageFilesWidget> createState() => _AttachImageFilesWidgetState();
}

class _AttachImageFilesWidgetState extends State<AttachImageFilesWidget> {
  bool isCheck = false;

  var imageList = [];
  var files = [];

  Future<List<XFile>> pickImagesUsingImagePicker(int pickCount) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> selectedImages = await picker.pickMultiImage(
      limit: pickCount,
    );
    return selectedImages;
  }

  Future<void> getImage() async {
    var result = imageList.length + files.length;

    List<XFile> images = await pickImagesUsingImagePicker(5 - result);
    if (images.isNotEmpty) {
      for (var image in images) {
        imageList.add(image);
      }
    }

    setState(() {});
  }

  void bottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), // 상단 왼쪽 코너 라운드
          topRight: Radius.circular(16), // 상단 오른쪽 코너 라운드
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SizedBox(
          height: 130,
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
                  SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              getImage();
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
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
                        SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(240, 240, 240, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 35,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  children: [
                    Text(
                      '첨부하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      width: 150,
                      height: 35,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.blue,
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            35,
                          ),
                        ),
                        onPressed: bottomSheetMenu,
                        child: Text(
                          '첨부파일 가져오기',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              imageList.isEmpty
                  ? SizedBox()
                  : Container(
                    height: 68,
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: imageList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(4),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black.withAlpha(150),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(imageList[index].path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (imageList.isEmpty) {
                                            return;
                                          }

                                          setState(() {
                                            imageList.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withAlpha(200),
                                            borderRadius: BorderRadius.circular(
                                              32,
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/images/close.png',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              Container(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (files.isEmpty) {
                                  return;
                                }

                                setState(() {
                                  files.removeAt(index);
                                });
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                padding: EdgeInsets.all(13),
                                child: Image.asset(
                                  'assets/images/close.png',
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                files[index],
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  '* 심사에 필요한 추가 견적서 등 사진, 문서를 첨부 하실수 있습니다.',
                  style: TextStyle(color: Colors.black.withAlpha(150)),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isCheck = !isCheck;
                  });
                },
                child: Container(
                  height: 44,
                  child: Row(
                    children: [
                      Container(
                        width: 21,
                        height: 21,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black.withAlpha(130),
                          ),
                        ),
                        child:
                            isCheck
                                ? Image.asset('assets/images/check.png')
                                : SizedBox(),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '심사조회를 위해 고객 동의를 확인하였습니다.',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '* 심사요청 접수확인 즉시 담당매니저가 안내 드리겠습니다.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.black.withAlpha(180),
                ),
              ),
              Text(
                '* 개인정보는 금융사 심사요청 즉시 삭제됩니다.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.black.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
