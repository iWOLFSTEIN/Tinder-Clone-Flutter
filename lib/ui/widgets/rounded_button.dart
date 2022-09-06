import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function? onPressed;

  RoundedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        child: Text(text, style: Theme.of(context).textTheme.button),
        onPressed: onPressed as void Function()?,
      ),
    );
  }
}
