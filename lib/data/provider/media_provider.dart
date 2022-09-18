import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tinder_app_flutter/data/db/entity/user_media_entity.dart';
import '../../util/utils.dart';
import '../db/remote/firebase_storage_source.dart';
import '../db/remote/response.dart';

class MediaProvider with ChangeNotifier {
  UserMediaEntity? userMediaE;
  final FirebaseStorageSource _storageSource = FirebaseStorageSource();
  List<String>? responses = [];
  bool isLoading = false;
  Future updateUrl(imagesFileList, context, uid, key) async {
    for (int i = 0; i < 6; i++) {
      var path = imagesFileList[i].path;
      Response response = await _storageSource.uploadMedia(
          filePath: path, imageName: i.toString(), userId: uid);
      if (response is Success<String>) {
        responses!.add(response.value);
      } else if (response is Error) {
        showSnackBar(key, response.message, context);
      }
    }
    UserMediaEntity userMediaEntity = UserMediaEntity(userMedia: responses);
    addMedia(userMediaEntity, uid, key, context);
  }

  void addMedia(UserMediaEntity userMediaEntity, uid, key, context) {
    FirebaseFirestore.instance
        .collection('media')
        .doc(uid)
        .set(userMediaEntity.toMap())
        .onError((error, stackTrace) {
      showSnackBar(key, error.toString(), context);
    });
    userMediaE = userMediaEntity;
    notifyListeners();
  }

  Future<UserMediaEntity?> getMedia(uid, context, key) async {
    if (userMediaE != null) return userMediaE;
    isLoading = true;
    userMediaE = UserMediaEntity.fromSnapshot(
        await FirebaseFirestore.instance.collection('media').doc(uid).get());
    isLoading = false;
    return userMediaE;

    // print(e.toString());
    // showSnackBar(key, '$e', context);
    // return null;
  }

  // Future<DocumentSnapshot> getUserMedia(uid) {
  //   return FirebaseFirestore.instance.collection('media').doc(uid).get();
  // }
}
