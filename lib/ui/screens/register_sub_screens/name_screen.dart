import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/ui/widgets/bordered_text_field.dart';

class NameScreen extends StatelessWidget {
  final Function(String) onChanged;

  NameScreen({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 30,
                height: MediaQuery.of(context).size.height / 8,
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
                      'My first',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      'name is',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 25),
        Expanded(
          child: BorderedTextField(
            labelText: 'Name',
            onChanged: onChanged,
            textCapitalization: TextCapitalization.words,
          ),
        ),
      ],
    );
  }
}
