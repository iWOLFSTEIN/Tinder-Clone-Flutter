import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_flutter/data/db/entity/app_user.dart';
import 'package:tinder_app_flutter/data/provider/user_provider.dart';
import 'package:tinder_app_flutter/ui/screens/start_screen.dart';
import 'package:tinder_app_flutter/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_app_flutter/ui/widgets/input_dialog.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:tinder_app_flutter/ui/widgets/rounded_icon_button.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void logoutPressed(UserProvider userProvider, BuildContext context) async {
    userProvider.logoutUser();
    Navigator.pop(context);
    Navigator.pushNamed(context, StartScreen.id);
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
                      ? Column(
                          children: [
                            ClipPath(
                              clipper: OvalBottomBorderClipper(),
                              child: Container(
                                width: size.width,
                                height: size.height * 0.60,
                                decoration: BoxDecoration(
                                    color: kPrimaryDark.withOpacity(0.1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: kPrimaryDark.withOpacity(0.1),
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
                                      getProfileImage(
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
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kSecondaryColor
                                                      .withOpacity(0.5),
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
                                                  color: Colors.white
                                                      .withOpacity(0.7),
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
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 85,
                                                  height: 85,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: kSecondaryColor
                                                              .withOpacity(0.5),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: kPrimaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 10,
                                                              blurRadius: 15,
                                                              // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(
                                                          Icons.camera_alt,
                                                          size: 45,
                                                          color: Colors.white,
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
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                kSecondaryColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: kSecondaryColor
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius:
                                                                    10,
                                                                blurRadius: 15,
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
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kSecondaryColor
                                                      .withOpacity(0.5),
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
                                                  Icons.edit,
                                                  size: 35,
                                                  color: Colors.white
                                                      .withOpacity(0.7),
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
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              child: CustomButton(
                                  color: kSecondaryColor.withOpacity(0.5),
                                  buttonName: 'LOGOUT',
                                  width: 300,
                                  height: 50,
                                  function: () {
                                    logoutPressed(userProvider, context);
                                  }),
                            )
                          ],
                        )
                      : Container());
            });
      }),
    );
  }

// Column(children: [
//                             getProfileImage(userSnapshot.data!, userProvider),
//                             SizedBox(height: 20),
//                             Text(
//                                 '${userSnapshot.data!.name}, ${userSnapshot.data!.age}',
//                                 style: Theme.of(context).textTheme.headline4),
//                             SizedBox(height: 40),
//                             getBio(userSnapshot.data!, userProvider),
//                             Expanded(child: Container()),
//                             CustomButton(
//                                 buttonName: 'LOGOUT',
//                                 width: 300,
//                                 height: 50,
//                                 function: () {
//                                   logoutPressed(userProvider, context);
//                                 })
//                           ])

  Widget getBio(AppUser user, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Bio', style: Theme.of(context).textTheme.headline4),
            RoundedIconButton(
              buttonColor: kPrimaryDark,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => InputDialog(
                    onSavePressed: (value) => userProvider.updateUserBio(value),
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
        Text(
          user.bio.length > 0 ? user.bio : "No bio.",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget getProfileImage(AppUser user, UserProvider firebaseProvider) {
    return Stack(
      children: [
        Container(
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.profilePhotoPath!),
            backgroundColor: kPrimaryDark.withOpacity(0.1),
            radius: 75,
          ),
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
                  await ImagePicker().getImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                firebaseProvider.updateUserProfilePhoto(
                    pickedFile.path, _scaffoldKey, context);
              }
            },
            iconData: Icons.edit,
            buttonColor: kPrimaryDark,
            iconSize: 18,
          ),
        ),
      ],
    );
  }
}