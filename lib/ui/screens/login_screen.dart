import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_flutter/data/db/remote/response.dart';
import 'package:tinder_app_flutter/data/provider/user_provider.dart';
import 'package:tinder_app_flutter/ui/screens/bottom_navigation_screen.dart';
import 'package:tinder_app_flutter/ui/screens/start_screen.dart';
import 'package:tinder_app_flutter/ui/widgets/bordered_text_field.dart';
import 'package:tinder_app_flutter/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_app_flutter/ui/widgets/rounded_button.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _inputEmail = '';
  String _inputPassword = '';
  bool _isLoading = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of(context, listen: false);
  }

  void loginPressed(context) async {
    setState(() {
      _isLoading = true;
    });
    await _userProvider
        .loginUser(_inputEmail, _inputPassword, _scaffoldKey, context)
        .then((response) {
      if (response is Success<UserCredential>) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            BottomNavigationScreen.id, (route) => false);
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
          ),
          shadowColor: kSecondaryColor,
          backgroundColor: kSecondaryColor,
        ),
        body: CustomModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Padding(
            padding: kDefaultPadding,
            child: Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: MediaQuery.of(context).size.height / 8,
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
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
                          'Login to your account',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  BorderedTextField(
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _inputEmail = value,
                  ),
                  SizedBox(height: 5),
                  BorderedTextField(
                    labelText: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    onChanged: (value) => _inputPassword = value,
                  ),
                  Expanded(child: Container()),
                  CustomButton(
                      width: 300,
                      height: 50,
                      buttonName: 'LOGIN',
                      function: () {
                        loginPressed(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
