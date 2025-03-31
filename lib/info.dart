import 'package:flutter/material.dart';
import 'package:webconnect/theme_color.dart';

class Info extends StatefulWidget {
  final String code;
  final String title;
  const Info({super.key, required this.code, required this.title});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  ThemeColor _themeColor = ThemeColor();
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
            color: Colors.grey.withAlpha(50),
            child: Text(
              '[${widget.code}]',
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: _themeColor.themeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
