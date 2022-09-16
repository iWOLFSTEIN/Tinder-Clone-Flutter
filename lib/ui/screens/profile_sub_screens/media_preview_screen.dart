import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPreviewScreen extends StatelessWidget {
  const MediaPreviewScreen({Key? key, required this.imageFileList})
      : super(key: key);
  final List<XFile>? imageFileList;
  static String id = 'mediaPreview';

  Widget previewImages() {
    if (imageFileList != null) {
      return ListView.builder(
        key: UniqueKey(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Semantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.file(
                  File(imageFileList![index].path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: imageFileList!.length,
      );
    } else {
      return Center(
        child: Text(
          'You have not yet picked an image.',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview Images'),
        actions: [
          IconButton(
              onPressed: onPressedIcon,
              icon: Icon(
                Icons.done_outline_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: previewImages(),
    );
  }

  onPressedIcon() {}
}
