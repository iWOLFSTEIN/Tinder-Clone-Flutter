import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class AgeScreen extends StatefulWidget {
  final Function(num) onChanged;

  AgeScreen({required this.onChanged});

  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  int age = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 30,
                height: MediaQuery.of(context).size.height / 10,
                margin: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: const Image(
                  image: AssetImage('assets/icon/text.png'),
                ),
              ),
              SizedBox(height: 25),
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      'My',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      'age is',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              child: NumberPicker(
                  textStyle: TextStyle(color: kSecondaryColor),
                  selectedTextStyle:
                      TextStyle(color: kSecondaryColor, fontSize: 20),
                  itemWidth: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: kGrey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  value: age,
                  minValue: 0,
                  maxValue: 120,
                  onChanged: (value) => {
                        setState(() {
                          age = value;
                        }),
                        widget.onChanged(value)
                      }),
            ),
          ),
        ),
      ],
    );
  }
}
