import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  final String code;
  final String title;
  const Info({super.key, required this.code, required this.title});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
