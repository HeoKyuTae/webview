import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webconnect/attach_image_files_widget.dart';
import 'package:webconnect/theme_color.dart';

class CheckView extends StatefulWidget {
  final String code;
  final String title;
  final String name;
  final String number;
  final List imageList;
  final List fileList;
  final bool check;
  const CheckView({
    super.key,
    required this.code,
    required this.title,
    required this.name,
    required this.number,
    required this.imageList,
    required this.fileList,
    required this.check,
  });

  @override
  State<CheckView> createState() => _CheckViewState();
}

class _CheckViewState extends State<CheckView> {
  ThemeColor _themeColor = ThemeColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            padding: EdgeInsets.all(12),
                            color: _themeColor.themeColor,
                            child: Image.asset('assets/images/close.png'),
                          ),
                        ),
                        Text('요청확인 데이터',style: TextStyle(color: _themeColor.themeColor,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Text('code: ${widget.code}'),
                  Text('title: ${widget.title}'),
                  SizedBox(height: 16,),
                  Text('name: ${widget.name}'),
                  Text('number: ${widget.number}'),
                  SizedBox(height: 16,),
                  Container(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.imageList.length,
                      itemBuilder: (context, index) {
                        var file = widget.imageList[index];
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              child: Image.file(
                                File(file.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.fileList.length,
                      itemBuilder: (context, index) {
                        FileData file = widget.fileList[index];
                        return Container(child: Text(file.fileName));
                      },
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
