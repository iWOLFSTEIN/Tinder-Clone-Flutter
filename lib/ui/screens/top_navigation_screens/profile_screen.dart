import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_flutter/data/db/entity/app_user.dart';
import 'package:tinder_app_flutter/data/provider/user_provider.dart';
import 'package:tinder_app_flutter/ui/screens/account_verification_screen.dart';
import 'package:tinder_app_flutter/ui/screens/profile_sub_screens/add_media_screen.dart';
import 'package:tinder_app_flutter/ui/screens/profile_sub_screens/edit_screen.dart';
import 'package:tinder_app_flutter/ui/screens/profile_sub_screens/setting_screen.dart';
import 'package:tinder_app_flutter/ui/screens/profile_sub_screens/show_media_screen.dart';
import 'package:tinder_app_flutter/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_app_flutter/ui/widgets/input_dialog.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:tinder_app_flutter/ui/widgets/rounded_icon_button.dart';
import 'package:tinder_app_flutter/util/constants.dart';
import 'dart:io' show Platform;


enum UserVerificationState { UNVERIFIED, VERIFIED, PENDING }

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  UserVerificationState? verificationState;
  @override
  void initState() {
    super.initState();
    verificationState = UserVerificationState.UNVERIFIED;
    getUserVerification();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      key: _scaffoldKey,
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return FutureBuilder<AppUser?>(
            future: userProvider.user,
            builder: (context, userSnapshot) {
              return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  child: userSnapshot.hasData
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              ClipPath(
                                clipper: OvalBottomBorderClipper(),
                                child: Container(
                                  width: size.width,
                                  height:(Platform.isIOS)? size.height*0.50: size.height * 0.60,
                                  decoration: BoxDecoration(
                                      color: kGrey.withOpacity(0.1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: kGrey.withOpacity(0.1),
                                          spreadRadius: 10,
                                          blurRadius: 10,
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30, bottom: 40),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        getProfileImage(size,
                                            userSnapshot.data!, userProvider),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                            '${userSnapshot.data!.name}, ${userSnapshot.data!.age}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SettingScreen(
                                                                  userProvider:
                                                                      userProvider))),
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: kPrimaryColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: kSecondaryColor
                                                              .withOpacity(0.1),
                                                          spreadRadius: 10,
                                                          blurRadius: 15,
                                                          // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Icon(
                                                      Icons.settings,
                                                      size: 35,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "SETTINGS",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: kSecondaryColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        Navigator.pushNamed(
                                                            context,
                                                            AddMediaScreen.id),
                                                    child: Container(
                                                      width: 85,
                                                      height: 85,
                                                      child: Stack(
                                                        // fit: StackFit.expand,
                                                        children: [
                                                          Container(
                                                            width: 80,
                                                            height: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: kGrey,
                                                              // .withOpacity(0.5),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: kPrimaryColor
                                                                      .withOpacity(
                                                                          0.1),
                                                                  spreadRadius:
                                                                      10,
                                                                  blurRadius:
                                                                      15,
                                                                  // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              size: 45,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 8,
                                                            right: 0,
                                                            child: Container(
                                                              width: 25,
                                                              height: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    kSecondaryColor,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: kSecondaryColor
                                                                        .withOpacity(
                                                                            0.1),
                                                                    spreadRadius:
                                                                        10,
                                                                    blurRadius:
                                                                        15,
                                                                    // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color:
                                                                      kPrimaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text("ADD MEDIA",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: kSecondaryColor,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, EditScreen.id);
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: kPrimaryColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: kSecondaryColor
                                                              .withOpacity(0.1),
                                                          spreadRadius: 10,
                                                          blurRadius: 15,
                                                          // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Icon(Icons.edit,
                                                        size: 35,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "EDIT INFO",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: kSecondaryColor,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: getBio(userSnapshot.data!, userProvider),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 15),
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text('Media',
                              //         // style: TextStyle(
                              //         //     color: kSecondaryColor, fontSize: 24

                              //         //     ),
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .headline4),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              (userSnapshot.data!.id == null)
                                  ? Container()
                                  : showMedia(
                                      context,
                                      // _scaffoldKey,
                                      userSnapshot.data!.id,
                                      size.height,
                                      size.width),

                              SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        )
                      : Container());
            });
      }),
    );
  }

  Widget getBio(AppUser user, UserProvider userProvider) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bio', style: Theme.of(context).textTheme.headline4),
              RoundedIconButton(
                buttonColor: kSecondaryColor,
                onPressed: () {
                  showDialog(
                    barrierColor: Colors.white,
                    context: context,
                    builder: (_) => InputDialog(
                      onSavePressed: (value) =>
                          userProvider.updateUserBio(value),
                      labelText: 'Bio',
                      startInputText: user.bio,
                    ),
                  );
                },
                iconData: Icons.edit,
                iconSize: 18,
                paddingReduce: 4,
              ),
            ],
          ),
          SizedBox(height: 5),
          Wrap(
            children: [
              Text(
                user.bio.length > 0 ? user.bio : "No bio.",
                style: TextStyle(color: kSecondaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getUserVerification() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Stream<DocumentSnapshot> userVerification = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('verification')
        .doc('cnic_verification')
        .snapshots();

    userVerification.listen((snapshot) {
      if (!snapshot.exists) {
        setState(() {
          verificationState = UserVerificationState.UNVERIFIED;
        });
      } else {
        var document = snapshot.data() as Map;
        if (document['status'] == 'pending') {
          if (this.mounted)
            setState(() {
              verificationState = UserVerificationState.PENDING;
            });
        } else if (document['status'] == 'verified') {
          if (this.mounted)
            setState(() {
              verificationState = UserVerificationState.VERIFIED;
            });
        }
      }
    });
  }

  Widget getProfileImage(size, AppUser user, UserProvider firebaseProvider) {
    return Stack(
      children: [
        Container(
          child: (verificationState == UserVerificationState.VERIFIED)
              ? Badge(
                  badgeColor: Colors.blue,
                  toAnimate: false,
                  padding: EdgeInsets.all(4),
                  position: BadgePosition.topEnd(top: 0, end: 0),
                  badgeContent: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Icon(
                      Icons.verified,
                      color: Colors.white,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(user.profilePhotoPath!),
                    backgroundColor: kGrey.withOpacity(0.1),
                    radius: 75,
                  ),
                )
              : GestureDetector(
                  onTap: (() {
                    var alertDialogue = (verificationState ==
                            UserVerificationState.PENDING)
                        ? AlertDialog(
                            title: Text(
                              'Verification Pending!',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            content: Text(
                                'Your account verification is on pending. Please wait until admin verifies you.'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                            ],
                          )
                        : AlertDialog(
                            title: Text(
                              'Account unvarified!',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            content: Text(
                                'Please verify your account to avoid restrictions.'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return AccountVerificationScreen();
                                        }));
                                      },
                                      child: Text(
                                        'Verify',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                            ],
                          );

                    showDialog(
                        context: context, builder: (context) => alertDialogue);
                  }),
                  child: Badge(
                    badgeColor: Colors.yellow.shade700,
                    toAnimate: false,
                    padding: EdgeInsets.all(4),
                    position: BadgePosition.topEnd(top: 0, end: 0),
                    badgeContent: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(
                        Icons.warning,
                        color: Colors.white,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user.profilePhotoPath!),
                      backgroundColor: kGrey.withOpacity(0.1),
                      radius: 75,
                    ),
                  ),
                )
          //   ;
          // })
          ,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kSecondaryColor, width: 1.0),
          ),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: RoundedIconButton(
            onPressed: () async {
              final pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                firebaseProvider.updateUserProfilePhoto(
                    pickedFile.path, _scaffoldKey, context);
              }
            },
            iconData: Icons.edit,
            buttonColor: kSecondaryColor,
            iconSize: 18,
          ),
        ),
      ],
    );
  }
}
