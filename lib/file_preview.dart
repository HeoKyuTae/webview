import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webconnect/alert.dart';
import 'package:webconnect/attach_image_files_widget.dart';
import 'package:webconnect/snack.dart';
import 'package:webconnect/theme_color.dart';

class FilePreview extends StatefulWidget {
  final List files;
  final int fileCount;
  const FilePreview({super.key, required this.files, required this.fileCount});

  @override
  State<FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {
  ThemeColor _themeColor = ThemeColor();
  List<FileData> imageFiles = [];
  List<FileData> documentFiles = [];

  @override
  void initState() {
    print(widget.files.length);
    imageFiles.clear();
    documentFiles.clear();

    _splitFiles();
    super.initState();
  }

  void _splitFiles() {
    for (var item in widget.files) {
      final ext = item.fileName.split('.').last.toLowerCase();

      // 이미지 확장자 판별
      if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic'].contains(ext)) {
        imageFiles.add(item);
      } else {
        documentFiles.add(item);
      }
    }
  }

  calc(int img, int doc, int c) {
    print('$img,$doc,$c');
    int result = (c - (img + doc)) * -1;

    if (result > 0) {
      return '$result개의 첨부파일이 초과 되었습니다.';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 44,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          calc(
                            imageFiles.length,
                            documentFiles.length,
                            widget.fileCount,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool? result = await Alert().showLeaveAlertDialog(
                          context,
                        );

                        if (result == true) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(4),
                        child: Image.asset('assets/images/close.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                           imageFiles.isEmpty ? SizedBox() : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 2, 16, 2),
                                decoration: BoxDecoration(
                                  color: _themeColor.themeColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '이미지 파일',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: imageFiles.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1,
                                    ),
                                itemBuilder: (BuildContext context, int index) {
                                  FileData item = imageFiles[index];

                                  return Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 0.1,
                                          ),
                                        ),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: SizedBox(
                                            child: Image.file(
                                              File(item.file.path),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              imageFiles.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: _themeColor.themeColor,
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            child: Image.asset(
                                              'assets/images/close.png',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: 32),
                            ],
                          ),
                          documentFiles.isEmpty ? SizedBox() :
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 2, 16, 2),
                                decoration: BoxDecoration(
                                  color: _themeColor.themeColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '기타 파일',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: documentFiles.length,
                                itemBuilder: (context, index) {
                                  FileData item = documentFiles[index];

                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      0,
                                      8,
                                      0,
                                      0,
                                    ),
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                documentFiles.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              width: 44,
                                              height: 44,
                                              padding: EdgeInsets.all(15),
                                              child: Image.asset(
                                                'assets/images/close.png',
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              item.fileName,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                child: Column(
                  children: [
                    Container(height: 0.1, color: Colors.black),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 150,
                          alignment: Alignment.center,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor:
                                  widget.fileCount <
                                          imageFiles.length +
                                              documentFiles.length
                                      ? Colors.grey
                                      : _themeColor.themeColor,
                              minimumSize: Size(
                                MediaQuery.of(context).size.width,
                                35,
                              ),
                            ),
                            onPressed: () {
                              if (widget.fileCount <
                                  imageFiles.length + documentFiles.length) {
                                Snack().showTopSnackBar(
                                  context,
                                  calc(
                                    imageFiles.length,
                                    documentFiles.length,
                                    widget.fileCount,
                                  ),
                                );
                                return;
                              }

                              Navigator.pop(context, [
                                ...imageFiles,
                                ...documentFiles,
                              ]);
                            },
                            child: Text(
                              '선택 완료',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
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
  }
}
