import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);
  static String id = 'setting';
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
      body: Center(
        child: Text(
          'We are working on this screen',
          style:
              TextStyle(color: kSecondaryColor, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
