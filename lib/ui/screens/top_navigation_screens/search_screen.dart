import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static String id = 'search';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
