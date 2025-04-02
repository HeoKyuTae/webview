import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:webconnect/theme_color.dart';

class ImagePreview extends StatefulWidget {
  final List<AssetEntity> images;
  final int count;
  const ImagePreview({super.key, required this.images, required this.count});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  ThemeColor _themeColor = ThemeColor();
  int selectedCount = 0;
  List<File> images = [];
  List<File> getImages = [];
  List<bool> selectedImages = [];

  @override
  void initState() {
    loadImages();
    super.initState();
  }

  Future<void> loadImages() async {
    if (widget.images.isNotEmpty) {
      for (var i = 0; i < widget.images.length; i++) {
        AssetEntity item = widget.images[i];
        File? file = await item.file;
        if (file != null) {
          setState(() {
            getImages.add(file);
            selectedImages.add(false);
          });
        }
      }
    }
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
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('close'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, images);
                      },
                      child: Text('완료'),
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
                      onTap: () {
                        if (widget.count == selectedCount &&
                            !selectedImages[index]) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("최대 선택 개수를 초과했습니다!")),
                          );
                          return;
                        }

                        selectedImages[index] = !selectedImages[index];

                        if (selectedImages[index]) {
                          images.add(getImages[index]);
                          selectedCount += 1;
                        } else {
                          images.remove(getImages[index]);
                          selectedCount -= 1;
                        }

                        setState(() {});
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
                              child: Image.file(
                                getImages[index],
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
            ],
          ),
        ),
      ),
    );
  }
}
