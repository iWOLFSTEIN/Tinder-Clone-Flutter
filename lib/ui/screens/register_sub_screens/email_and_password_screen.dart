import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/ui/widgets/bordered_text_field.dart';

class EmailAndPasswordScreen extends StatelessWidget {
  final Function(String) emailOnChanged;
  final Function(String) passwordOnChanged;

  EmailAndPasswordScreen(
      {required this.emailOnChanged, required this.passwordOnChanged});

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
                    color: const Color.fromARGB(255, 66, 43, 43),
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
                      'My Email and',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      'Password is',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
        BorderedTextField(
          labelText: 'Email',
          onChanged: emailOnChanged,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 5),
        BorderedTextField(
          labelText: 'Password',
          onChanged: passwordOnChanged,
          obscureText: true,
        ),
      ],
    );
  }
}
