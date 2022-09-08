import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);
  static String id = 'edit';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        shadowColor: kSecondaryColor,
        title: Text(
          'Edit Info',
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
