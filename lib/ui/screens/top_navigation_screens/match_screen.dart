import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_flutter/data/db/entity/app_user.dart';
import 'package:tinder_app_flutter/data/db/entity/chat.dart';
import 'package:tinder_app_flutter/data/db/entity/match.dart';
import 'package:tinder_app_flutter/data/db/entity/swipe.dart';
import 'package:tinder_app_flutter/data/db/remote/firebase_database_source.dart';
import 'package:tinder_app_flutter/data/provider/user_provider.dart';
import 'package:tinder_app_flutter/ui/screens/matched_screen.dart';
import 'package:tinder_app_flutter/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_app_flutter/ui/widgets/rounded_icon_button.dart';
import 'package:tinder_app_flutter/ui/widgets/swipe_card.dart';
import 'package:tinder_app_flutter/util/constants.dart';
import 'package:tinder_app_flutter/util/utils.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String>? _ignoreSwipeIds;

  Future<AppUser?> loadPerson(AppUser user) async {
    try {
      var userCity = user.city!["city"];
      var userCountry = user.city!["country"];
      var userState = user.city!["state"];

      if (_ignoreSwipeIds == null) {
        _ignoreSwipeIds = [];
        var swipes = await _databaseSource.getMatches(user.id);

        for (var i = 0; i < swipes.size; i++) {
          // Since model Swipe is not same as the collection swipe so we shall directly access the ids

          // Swipe swipe = Swipe.fromSnapshot(swipes.docs[i]);
          // _ignoreSwipeIds!.add(swipe.id!);
          print(swipes.docs[i].id);
          _ignoreSwipeIds!.add(swipes.docs[i].id);
        }
        _ignoreSwipeIds!.add(user.id!);
      }

      var res =
          await _databaseSource.getPersonsToMatchWith(100, _ignoreSwipeIds);
      print(res.docs.length);
      for (var items in res.docs) {
        print(items.id);
      }
      print("SEP");
      var docs = res.docs.toList();

      docs.sort((a, b) {
        var cityA = AppUser.fromSnapshot(a).city!["city"];
        var stateA = AppUser.fromSnapshot(a).city!["state"];
        var countryA = AppUser.fromSnapshot(a).city!["country"];
        var cityB = AppUser.fromSnapshot(b).city!["city"];
        var stateB = AppUser.fromSnapshot(b).city!["state"];
        var countryB = AppUser.fromSnapshot(b).city!["country"];

        if (cityA == userCity) {
          return -1;
        } else if (cityB == userCity) {
          return 1;
        } else if (stateA == userState) {
          return -1;
        } else if (stateB == userState) {
          return 1;
        } else if (countryA == userCountry) {
          return -1;
        } else if (countryB == userCountry) {
          return 1;
        } else
          return 0;
      });
      for (var items in res.docs) {
        print(items.id);
      }
      if (docs.length > 0) {
        var userToMatchWith = AppUser.fromSnapshot(docs[0]);
        return userToMatchWith;
      } else {
        return null;
      }
    } catch (e) {
      print('--------------------------------');
      print('thats the error bro');
      print(e.toString());
    }
    return null;
  }

  void personSwiped(AppUser myUser, AppUser otherUser, bool isLiked) async {
    _databaseSource.addSwipedUser(myUser.id, Swipe(otherUser.id, isLiked));

    // TODO: add this line to if statement where isLiked is equal to true
    _ignoreSwipeIds!.add(otherUser.id!);

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

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return FutureBuilder<AppUser?>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  child: (userSnapshot.hasData)
                      ? FutureBuilder<AppUser?>(
                          future: loadPerson(userSnapshot.data!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                !snapshot.hasData) {
                              return Center(
                                child: Container(
                                    child: Text('No users',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4)),
                              );
                            }
                            if (!snapshot.hasData) {
                              return CustomModalProgressHUD(
                                inAsyncCall: true,
                                child: Container(),
                              );
                            }
                            return Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 12, right: 12),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SwipeCard(person: snapshot.data),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 45),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RoundedIconButton(
                                                  onPressed: () {
                                                    personSwiped(
                                                        userSnapshot.data!,
                                                        snapshot.data!,
                                                        false);
                                                  },
                                                  iconData: Icons.clear,
                                                  buttonColor: kRed,
                                                  iconSize: 30,
                                                ),
                                                RoundedIconButton(
                                                  buttonColor: Colors.green,
                                                  onPressed: () {
                                                    personSwiped(
                                                        userSnapshot.data!,
                                                        snapshot.data!,
                                                        true);
                                                  },
                                                  iconData: Icons.favorite,
                                                  iconSize: 30,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : Container(),
                );
              },
            );
          },
        )));
  }
}
