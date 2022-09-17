import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinder_app_flutter/data/db/remote/response.dart';
import 'package:tinder_app_flutter/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_app_flutter/util/constants.dart';
import '../../../data/db/remote/firebase_storage_source.dart';
import '../../../util/utils.dart';

class MediaPreviewScreen extends StatefulWidget {
  MediaPreviewScreen({Key? key, required this.imageFileList}) : super(key: key);
  final List<XFile>? imageFileList;
  static String id = 'mediaPreview';

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isloading = false;

  final FirebaseStorageSource _storageSource = FirebaseStorageSource();

  var userId = FirebaseAuth.instance.currentUser!.uid;

  List responses = [];

  Widget previewImages() {
    if (widget.imageFileList != null) {
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
                  File(widget.imageFileList![index].path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: widget.imageFileList!.length,
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
              onPressed: () => onPressedIcon(context, widget.imageFileList),
              icon: Icon(
                Icons.done_outline_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: CustomModalProgressHUD(
          progressIndicator: CircularProgressIndicator(color: kSecondaryColor),
          inAsyncCall: _isloading,
          child: previewImages()),
    );
  }

  void onPressedIcon(context, imagesFileList) async {
    try {
      print(userId);
      showSnackBar(_scaffoldKey,
          "It will take sometime, don't go back until its done", context);
      setState(() {
        _isloading = true;
      });
      for (int i = 0; i < 6; i++) {
        var path = imagesFileList[i].path;
        Response response = await _storageSource.uploadMedia(
            filePath: path, imageName: i.toString(), userId: userId);
        if (response is Success<String>) {
          responses.add(response.value);
        } else if (response is Error) {
          showSnackBar(_scaffoldKey, response.message, context);
        }
      }
      updateUrl(responses, context);
    } catch (e) {
      print(e);
    }
  }

  Future updateUrl(responses, context) async {
    await FirebaseFirestore.instance.collection('media').doc(userId).set({
      '1': responses[0],
      '2': responses[1],
      '3': responses[2],
      '4': responses[3],
      '5': responses[4],
      '6': responses[5]
    }).then((value) {
      setState(() {
        _isloading = false;
      });
      Navigator.pop(context);
      showSnackBar(_scaffoldKey, 'Images has been added', context);
    }).onError((error, stackTrace) {
      showSnackBar(_scaffoldKey, error.toString(), context);
    });
  }
}
