import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_flutter/data/db/entity/user_media_entity.dart';
import 'package:tinder_app_flutter/data/provider/media_provider.dart';
import 'package:tinder_app_flutter/util/constants.dart';

import '../../../data/provider/user_provider.dart';
import '../start_screen.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key, required this.userProvider}) : super(key: key);
  static String id = 'setting';
  UserProvider userProvider;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void logoutPressed(UserProvider userProvider, BuildContext context) async {
    Provider.of<MediaProvider>(context, listen: false).userMediaE = null;
    userProvider.logoutUser();
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(context, StartScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        shadowColor: kSecondaryColor,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Center(
              child: Container(
            margin: EdgeInsets.only(top: 30),
            child: CustomButton(
                color: kSecondaryColor,
                buttonName: 'LOGOUT',
                width: 300,
                height: 50,
                function: () {
                  logoutPressed(widget.userProvider, context);
                }),
          )),
        ],
      ),
    );
  }
}
