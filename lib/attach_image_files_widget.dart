import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:webconnect/alert.dart';
import 'package:webconnect/file_preview.dart';
import 'package:webconnect/image_preview.dart';
import 'package:webconnect/privacy_view.dart';
import 'package:webconnect/theme_color.dart';

class FileData {
  final String fileName;
  final File file;

  FileData({required this.fileName, required this.file});

  @override
  String toString() =>
      'FileData(fileName: $fileName, size: ${file.length} bytes)';
}

class AttachImageFilesWidget extends StatefulWidget {
  final Function(List, List, bool) onValueChanged;
  final int imgCount;
  final int fileCount;
  const AttachImageFilesWidget({
    super.key,
    required this.onValueChanged,
    required this.imgCount,
    required this.fileCount,
  });

  @override
  State<AttachImageFilesWidget> createState() => _AttachImageFilesWidgetState();
}

class _AttachImageFilesWidgetState extends State<AttachImageFilesWidget> {
  ThemeColor _themeColor = ThemeColor();
  bool isCheck = false;
  var imageList = [];
  var getFiles = [];
  var setFiles = [];

  /*
  /// 2. 선택한 사진 용량 체크
    List<XFile> overflowFiles = [];
    for (var image in selectedImages) {
      int length = await image.length();
      if (checkOverflowSize(length)) {
        overflowFiles.add(image);
      }
    }

    List<XFile> validImages = selectedImages;
    if (overflowFiles.isNotEmpty && mounted) {
      Snack().showTopSnackBar(context, '1MB 넘는 첨부 이미지는 자동 제외 되었습니다.');
      validImages =
          selectedImages.where((element) {
            return !overflowFiles.contains(element);
          }).toList();
    }
*/

  bool checkOverflowSize(int fileSize) {
    return fileSize > 1 * 1024 * 1024;
  }

  void bottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
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
                            onTap: () {
                              var result = imageList.length;

                              if (result >= widget.imgCount) {
                                Alert().showAlertDialog(
                                  context,
                                  '이미지 파일 첨부는 ${widget.imgCount}개 까지 가능합니다.',
                                );
                                return;
                              }

                              loadImages();
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
                              var result = setFiles.length;

                              if (result >= widget.fileCount) {
                                Alert().showAlertDialog(
                                  context,
                                  '파일 첨부는 ${widget.fileCount}개 까지 가능합니다.',
                                );
                                return;
                              }

                              getFile();
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

  Future<void> getFile() async {
    FilePickerResult? resultFiles = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (resultFiles != null) {
      for (PlatformFile platformFile in resultFiles.files) {
        if (platformFile.path == null) continue;

        File file = File(platformFile.path!);
        String fileName = path.basename(file.path);

        /*
        int fileSize = await file.length();

        if (checkOverflowSize(fileSize)) {
          if (mounted) {
            Alert().showAlertDialog(context, '첨부파일의 최대 용량은 1MB 입니다.');
          }
        } else {
          files.add(FileData(fileName: fileName, file: file));
        }
        */

        getFiles.add(FileData(fileName: fileName, file: file));
      }

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilePreview(files: getFiles),
          fullscreenDialog: true,
        ),
      );

      setState(() {
        getFiles.clear();
      });

      if (result != null) {
        setState(() {
          setFiles.addAll(result);
        });

        updateInfo();
      }
    }
  }

  void updateInfo() {
    widget.onValueChanged(imageList, setFiles, isCheck);
  }

  // =-=-=-=-=-=-=-=-=

  List<AssetEntity> images = [];

  Future<void> loadImages() async {
    var resultCount = imageList.length;

    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();

    if (permission.isAuth || permission.hasAccess) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isNotEmpty) {
        List<AssetEntity> media = await albums[0].getAssetListPaged(
          page: 0,
          size: 10000,
        );
        setState(() {
          images = media;
        });

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ImagePreview(
                  images: images,
                  count: widget.imgCount - resultCount,
                ),
            fullscreenDialog: true,
          ),
        );

        if (result != null) {
          setState(() {
            imageList.addAll(result);
          });

          updateInfo();
        }
      }
    } else {
      PhotoManager.openSetting();
    }
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
                          backgroundColor: _themeColor.themeColor,
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            35,
                          ),
                        ),
                        onPressed: () {
                          bottomSheetMenu();
                        },
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
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: imageList.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 60,
                                height: 60,
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
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (imageList.isEmpty) {
                                            return;
                                          }

                                          bool? result = await Alert()
                                              .showRemoveImageAlertDialog(
                                                context,
                                                imageList[index].path,
                                              );

                                          if (result == true) {
                                            setState(() {
                                              imageList.removeAt(index);
                                            });
                                          }

                                          updateInfo();
                                        },
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: _themeColor.themeColor,
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
                  itemCount: setFiles.length,
                  itemBuilder: (context, index) {
                    FileData data = setFiles[index];

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 16, 0),
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
                              onTap: () async {
                                if (setFiles.isEmpty) {
                                  return;
                                }

                                bool? result = await Alert()
                                    .showRemoveFileAlertDialog(
                                      context,
                                      data.fileName,
                                    );

                                if (result == true) {
                                  setState(() {
                                    setFiles.removeAt(index);
                                  });
                                }
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
                                data.fileName,
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
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                        updateInfo();
                      },
                      child: Container(
                        width: 21,
                        height: 21,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black.withAlpha(130),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            isCheck
                                ? Image.asset('assets/images/check.png')
                                : SizedBox(),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '심사조회를 위해 고객 동의를 확인하였습니다.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivacyView(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: SizedBox(
                        child: Text(
                          '[보기]',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
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
