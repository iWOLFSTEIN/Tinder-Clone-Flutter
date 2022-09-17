import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/data/db/entity/app_user.dart';
import 'package:tinder_app_flutter/ui/screens/top_navigation_screens/profile_screen.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:tinder_app_flutter/util/constants.dart';
import '../../data/db/entity/swipe.dart';
import 'dart:async';
import 'package:tinder_app_flutter/data/db/entity/chat.dart';
import 'package:tinder_app_flutter/data/db/entity/match.dart';
import 'package:tinder_app_flutter/ui/screens/matched_screen.dart';
import 'package:tinder_app_flutter/util/utils.dart';

import '../../data/db/remote/firebase_database_source.dart';

enum UserMatchedStatus { MATCHED, UNMATCHED, REQUESTED }

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key? key, this.userDataDocument}) : super(key: key);

  var userDataDocument;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UserVerificationState? verificationState;
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  // List<String>? _ignoreSwipeIds;

  final uid = FirebaseAuth.instance.currentUser!.uid;
  AppUser? user;
  AppUser? otherUser;
  UserMatchedStatus? userMatchedStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserVerification(widget.userDataDocument['id']);
    getUserMatchStatus();
    getUsersData();
  }

  getUsersData() async {
    user = AppUser.fromSnapshot(await _databaseSource.getUser(uid));
    otherUser = AppUser.fromSnapshot(
        await _databaseSource.getUser(widget.userDataDocument['id']));
    setState(() {});
  }

  getUserMatchStatus() async {
    bool match = await isAMatch(uid, widget.userDataDocument['id']);
    bool requested = await isRequested(uid, widget.userDataDocument['id']);

    if (match) if (requested)
      userMatchedStatus = UserMatchedStatus.MATCHED;
    else
      userMatchedStatus = UserMatchedStatus.UNMATCHED;
    else if (requested)
      userMatchedStatus = UserMatchedStatus.REQUESTED;
    else
      userMatchedStatus = UserMatchedStatus.UNMATCHED;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                width: size.width,
                height: size.height * 0.595,
                decoration:
                    BoxDecoration(color: kGrey.withOpacity(0.1), boxShadow: [
                  BoxShadow(
                    color: kGrey.withOpacity(0.1),
                    spreadRadius: 10,
                    blurRadius: 10,
                  ),
                ]),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Material(
                              elevation: 8,
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                  height: size.height * 5 / 100,
                                  width: size.width * 10 / 100,
                                  child: Center(child: Icon(Icons.arrow_back))),
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      getProfileImage(
                        size,
                        widget.userDataDocument,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          '${widget.userDataDocument['city']['city']}, ${widget.userDataDocument['city']['state']}',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 16)),
                      Text('${widget.userDataDocument['city']['country']}',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6))),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 62.5 / 100,
                                  // color: Colors.orange,
                                  child: Text(
                                    '${widget.userDataDocument['name']}',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                    '${widget.userDataDocument['age']} years old',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                        fontSize: 16)),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (userMatchedStatus ==
                                                UserMatchedStatus.MATCHED ||
                                            userMatchedStatus ==
                                                UserMatchedStatus.REQUESTED)
                                        ? () {}
                                        : () async {
                                            setState(() {
                                              userMatchedStatus =
                                                  UserMatchedStatus.REQUESTED;
                                            });
                                            personSwiped(
                                                user!, otherUser!, true);
                                          },
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      // color: Colors.blue,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (userMatchedStatus ==
                                                      UserMatchedStatus.MATCHED)
                                                  ? Colors.red
                                                  : (userMatchedStatus ==
                                                          UserMatchedStatus
                                                              .REQUESTED)
                                                      ? Colors.yellow.shade700
                                                      : kGrey,
                                              // .withOpacity(0.5),
                                              // color: Colors.red,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kPrimaryColor
                                                      .withOpacity(0.1),
                                                  spreadRadius: 10,
                                                  blurRadius: 15,
                                                  // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Icon(
                                                Icons.favorite,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      (userMatchedStatus ==
                                              UserMatchedStatus.MATCHED)
                                          ? "MATCHED"
                                          : (userMatchedStatus ==
                                                  UserMatchedStatus.REQUESTED)
                                              ? "REQUESTED"
                                              : "MATCH",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: kSecondaryColor,
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: getBio(size, widget.userDataDocument),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i <= 10; i++)
                    Container(
                      decoration: BoxDecoration(
                          color: kGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getBio(size, user) {
    return Container(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bio', style: Theme.of(context).textTheme.headline4),
            ],
          ),
          SizedBox(height: 5),
          Wrap(children: [
            Text(
              user['bio'].length > 0 ? user['bio'] : "No bio ",
              style: TextStyle(color: kSecondaryColor),
            ),
          ]),
        ],
      ),
    );
  }

  getUserVerification(uid) async {
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

  Widget getProfileImage(size, user) {
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
                        CachedNetworkImageProvider(user['profile_photo_path']),
                    backgroundColor: kGrey.withOpacity(0.1),
                    radius: 75,
                  ),
                )
              : Badge(
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
                        CachedNetworkImageProvider(user['profile_photo_path']),
                    backgroundColor: kGrey.withOpacity(0.1),
                    radius: 75,
                  ),
                ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kSecondaryColor, width: 1.0),
          ),
        ),
      ],
    );
  }

  void personSwiped(AppUser myUser, AppUser otherUser, bool isLiked) async {
    _databaseSource.addSwipedUser(myUser.id, Swipe(otherUser.id, isLiked));

    // _ignoreSwipeIds!.add(otherUser.id!);

    if (isLiked == true) {
      if (await isMatch(myUser, otherUser) == true) {
        _databaseSource.addMatch(myUser.id, Match(otherUser.id));
        _databaseSource.addMatch(otherUser.id, Match(myUser.id));
        String chatId = compareAndCombineIds(myUser.id!, otherUser.id!);
        _databaseSource.addChat(Chat(chatId, null));

        Navigator.pushNamed(context, MatchedScreen.id, arguments: {
          "my_user_id": myUser.id,
          "my_profile_photo_path": myUser.profilePhotoPath,
          "other_user_profile_photo_path": otherUser.profilePhotoPath,
          "other_user_id": otherUser.id
        });
      }
    }
    setState(() {});
  }

  Future<bool> isMatch(AppUser myUser, AppUser otherUser) async {
    print(myUser);
    DocumentSnapshot swipeSnapshot =
        await _databaseSource.getSwipe(otherUser.id, myUser.id);
    if (swipeSnapshot.exists) {
      Swipe swipe = Swipe.fromSnapshot(swipeSnapshot);

      if (swipe.liked == true) {
        return true;
      }
    }
    return false;
  }

  Future<bool> isRequested(myUserId, otherUserId) async {
    DocumentSnapshot swipeSnapshot =
        await _databaseSource.getSwipe(myUserId, otherUserId);
    if (swipeSnapshot.exists) {
      var document = swipeSnapshot.data() as Map;
      if (document['liked']) {
        return true;
      }
    }
    return false;
  }

  Future<bool> isAMatch(myUserId, otherUserId) async {
    DocumentSnapshot swipeSnapshot =
        await _databaseSource.getSwipe(otherUserId, myUserId);
    if (swipeSnapshot.exists) {
      var document = swipeSnapshot.data() as Map;
      if (document['liked']) {
        return true;
      }
    }
    return false;
  }
}
