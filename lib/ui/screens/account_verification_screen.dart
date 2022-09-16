import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinder_app_flutter/data/db/remote/firebase_storage_source.dart';
import 'package:tinder_app_flutter/ui/widgets/custom_modal_progress_hud.dart';

import '../../data/db/remote/response.dart';

class AccountVerificationScreen extends StatefulWidget {
  AccountVerificationScreen({Key? key}) : super(key: key);

  @override
  State<AccountVerificationScreen> createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  final picker = ImagePicker();
  String? _cnicFront;
  String? _cnicBack;
  FirebaseStorageSource _firebaseStorageSource = FirebaseStorageSource();
  var userId = FirebaseAuth.instance.currentUser!.uid;

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) return pickedFile.path;
  }

  bool _buttonPressed = false;
  bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomModalProgressHUD(
        inAsyncCall: _isUploading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: Icon(Icons.arrow_back)),
                Text(
                  'Verify Your Account',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'We require your CNIC for account verification. Verification may take upto 2 working days.',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 15,
                  ),
                ),
                Container(
                  height: height * 30 / 100,
                  width: width,
                  decoration: BoxDecoration(
                      color: Color(0xFFE1E4E8),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: GestureDetector(
                    onTap: () async {
                      var path = await pickImageFromGallery();
                      setState(() {
                        _cnicFront = path;
                      });
                    },
                    child: (_cnicFront != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.file(
                              File(_cnicFront!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/upload.png',
                                height: 50,
                                width: 50,
                              ),
                              Text(
                                'CNIC FRONT',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              )
                            ],
                          ),
                  ),
                ),
                Container(
                  height: height * 30 / 100,
                  width: width,
                  decoration: BoxDecoration(
                      color: Color(0xFFE1E4E8),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: GestureDetector(
                    onTap: () async {
                      var path = await pickImageFromGallery();
                      setState(() {
                        _cnicBack = path;
                      });
                    },
                    child: (_cnicBack != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.file(
                              File(_cnicBack!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/upload.png',
                                height: 50,
                                width: 50,
                              ),
                              Text(
                                'CNIC BACK',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              )
                            ],
                          ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: (_buttonPressed) ? Colors.blue : null,
                      border: Border.all(
                          color: (_buttonPressed) ? Colors.white : Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                      onPressed: () async {
                        playButtonAnimation();
                        setState(() {
                          _isUploading = true;
                        });
                        await uploadCnicPhotos();
                        setState(() {
                          _isUploading = false;
                        });
                      },
                      child: Text(
                        'Verify',
                        style: TextStyle(
                            color:
                                (_buttonPressed) ? Colors.white : Colors.blue),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  playButtonAnimation() {
    setState(() {
      _buttonPressed = true;
    });
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _buttonPressed = false;
      });
    });
  }

  uploadCnicPhotos() async {
    if (_cnicFront != null && _cnicBack != null) {
      var response0 = await (_firebaseStorageSource.uploadUserCnicPhotos(
          filePath: _cnicFront, userId: userId, cnicSide: 'front'));
      var response1 = await (_firebaseStorageSource.uploadUserCnicPhotos(
          filePath: _cnicBack, userId: userId, cnicSide: 'back'));

      if (response0 is Success<String> && response1 is Success<String>) {
        updateFirestoreReference(response0.value, response1.value)
            .then((value) => Navigator.pop(context));
      } else {
        AlertDialog alertDialog = AlertDialog(
          title: Text(
            'Error!',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Text('An error occurred. Please try later.'),
        );
        showDialog(context: context, builder: ((context) => alertDialog));
      }
    }
  }

  Future updateFirestoreReference(res0, res1) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('verification')
        .doc('cnic_verification')
        .set({'status': 'pending', 'front': res0, 'back': res1});
  }
}
