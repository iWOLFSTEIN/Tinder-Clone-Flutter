import 'package:flutter/material.dart';
import '../../util/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      this.color,
      required this.buttonName,
      this.textColor,
      required this.function,
      this.height,
      this.width})
      : super(key: key);
  final Color? color;
  final String buttonName;
  final Color? textColor;
  final double? width;
  final double? height;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          function();
        },
        child: Container(
          height: height ?? 50,
          width: width ?? 300,
          decoration: BoxDecoration(
              color: color ?? kSecondaryColor,
              border: Border.all(
                color: kSecondaryColor,
                // width: 5,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              buttonName,
              style: TextStyle(
                  color: textColor ?? kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
        ));
  }
}
