import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart'
    show AssetEntityImageProvider;
import 'package:webconnect/attach_image_files_widget.dart' show AttachConfig;
import 'package:webconnect/snack.dart';
import 'package:webconnect/theme_color.dart';

class ImagePreview extends StatefulWidget {
  final List<AssetEntity> images;
  final int count;
  final AttachConfig attachConfig;

  const ImagePreview({
    super.key,
    required this.images,
    required this.count,
    required this.attachConfig,
  });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  final ThemeColor _themeColor = ThemeColor();
  int selectedCount = 0;
  List<File> setImages = [];
  List<AssetEntity> getImages = [];
  List<bool> selectedImages = [];

  @override
  void initState() {
    // loadImages();
    getImages = widget.images;
    selectedImages.addAll(getImages.map((e) => false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 44,
                padding: EdgeInsets.fromLTRB(21, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        padding: EdgeInsets.all(12),
                        child: Image.asset('assets/images/close.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: getImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        final file = await getImages[index].file;
                        if (file == null) {
                          return;
                        }

                        if (selectedImages[index]) {
                          setState(() {
                            setImages.removeWhere(
                              (item) => item.path == file.path,
                            );

                            selectedImages[index] = !selectedImages[index];
                            selectedCount -= 1;
                          });
                        } else {
                          if (widget.count == selectedCount &&
                              !selectedImages[index]) {
                            Snack().showTopSnackBar(
                              context,
                              '최대 선택 개수를 초과했습니다!',
                            );
                            return;
                          }

                          /// overflow check
                          if (widget.attachConfig.checkOverflowSize(
                            file.lengthSync(),
                          )) {
                            Snack().showTopSnackBar(
                              context,
                              '최대용량 ${widget.attachConfig.maxSize}MB를 초과 하였습니다.',
                            );
                            return;
                          }

                          setState(() {
                            setImages.add(file);
                            selectedImages[index] = !selectedImages[index];
                            selectedCount += 1;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.1),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: size.width / 3,
                              height: size.width / 3,
                              child: Image(
                                image: AssetEntityImageProvider(
                                  getImages[index],
                                  isOriginal: false,
                                  thumbnailSize: const ThumbnailSize.square(
                                    200,
                                  ),
                                  thumbnailFormat: ThumbnailFormat.jpeg,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            selectedImages[index] == true
                                ? Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: _themeColor.themeColor,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 7.0,
                                          spreadRadius: 1.0,
                                          offset: const Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(3),
                                    child: Image.asset(
                                      'assets/images/check.png',
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
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
                                  setImages.isEmpty
                                      ? Colors.grey
                                      : _themeColor.themeColor,
                              minimumSize: Size(
                                MediaQuery.of(context).size.width,
                                35,
                              ),
                            ),
                            onPressed: () {
                              if (setImages.isEmpty) {
                                Snack().showTopSnackBar(
                                  context,
                                  '이미지를 선택해 주십시오',
                                );
                                return;
                              }

                              print(setImages.length);
                              Navigator.pop(context, setImages);
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
