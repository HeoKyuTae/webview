import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webconnect/attach_image_files_widget.dart';

class FilePreview extends StatefulWidget {
  final List files;
  const FilePreview({super.key, required this.files});

  @override
  State<FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(height: 44),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.files.length,
                  itemBuilder: (context, index) {
                    FileData item = widget.files[index];
                    return InkWell(
                      onTap: () {},
                      child: Container(child: Image.file(File(item.file.path))),
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
