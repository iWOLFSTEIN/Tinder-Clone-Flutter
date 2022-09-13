import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tinder_app_flutter/data/db/remote/response.dart';

class FirebaseStorageSource {
  FirebaseStorage instance = FirebaseStorage.instance;

  Future<Response<String>> uploadUserProfilePhoto(
      String filePath, String? userId) async {
    String userPhotoPath = "user_photos/$userId/profile_photo";

    try {
      await instance.ref(userPhotoPath).putFile(File(filePath));
      String downloadUrl = await instance.ref(userPhotoPath).getDownloadURL();
      return Response.success(downloadUrl);
    } catch (e) {
      return Response.error(((e as FirebaseException).message ?? e.toString()));
    }
  }

  Future<Response<String>> uploadUserCnicPhotos(
      {required String? filePath,
      required String? userId,
      required String? cnicSide}) async {
    String userPhotoPath = "user_photos/$userId/cnic_photos/$cnicSide";

    try {
      await instance.ref(userPhotoPath).putFile(File(filePath!));
      String downloadUrl = await instance.ref(userPhotoPath).getDownloadURL();
      return Response.success(downloadUrl);
    } catch (e) {
      return Response.error(((e as FirebaseException).message ?? e.toString()));
    }
  }
}
