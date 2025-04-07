import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webconnect/theme_color.dart';

class Alert {
  final ThemeColor _themeColor = ThemeColor();

  void showAlertDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(title),
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeColor.themeColor, // 배경색
                foregroundColor: Colors.white, // 글자색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // 테두리 둥글게 (12px)
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showLeaveAlertDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: SizedBox(
            width: 250,
            height: 44,
            child: Text('선택된 파일이 초기화 됩니다.',style: TextStyle(fontSize: 18, color: _themeColor.themeColor),),
          ),
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeColor.themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('나가기'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showRemoveImageAlertDialog(BuildContext context, String file) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Container(
            width: 250,
            height: 180,
            child: Column(
              children: [
                Container(width: 250, height: 150, child: Image.file(File(file))),
                Text('이미지를 삭제 하시겠습니까?',style: TextStyle(fontSize: 15),),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeColor.themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showRemoveFileAlertDialog(
    BuildContext context,
    String fileName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Container(
            width: 250,
            height: 80,
            child: Column(
              children: [
                Text(fileName,style: TextStyle(color: _themeColor.themeColor,fontSize: 18, overflow: TextOverflow.ellipsis),maxLines: 2,),
                Text('파일을 삭제 하시겠습니까?',style: TextStyle(fontSize: 15),),
              ],
            ),
          ),

          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeColor.themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }
}
