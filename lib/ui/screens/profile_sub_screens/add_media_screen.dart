import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class AddMediaScreen extends StatelessWidget {
  const AddMediaScreen({Key? key}) : super(key: key);
  static String id = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        shadowColor: kSecondaryColor,
        title: Text('Add Media'),
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
