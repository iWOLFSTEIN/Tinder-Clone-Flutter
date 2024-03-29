import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_flutter/data/db/remote/response.dart';
import 'package:tinder_app_flutter/data/model/user_registration.dart';
import 'package:tinder_app_flutter/data/provider/user_provider.dart';
import 'package:tinder_app_flutter/ui/screens/register_sub_screens/add_photo_screen.dart';
import 'package:tinder_app_flutter/ui/screens/register_sub_screens/age_screen.dart';
import 'package:tinder_app_flutter/ui/screens/register_sub_screens/email_and_password_screen.dart';
import 'package:tinder_app_flutter/ui/screens/register_sub_screens/name_screen.dart';
import 'package:tinder_app_flutter/ui/screens/bottom_navigation_screen.dart';
import 'package:tinder_app_flutter/ui/screens/register_sub_screens/select_city_screen.dart';
import 'package:tinder_app_flutter/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_app_flutter/util/constants.dart';
import 'package:tinder_app_flutter/util/utils.dart';
import 'package:tinder_app_flutter/ui/screens/start_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserRegistration _userRegistration = UserRegistration();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _endScreenIndex = 4;
  int _currentScreenIndex = 0;
  bool _isLoading = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void registerUser(context) async {
    setState(() {
      _isLoading = true;
    });

    await _userProvider
        .registerUser(_userRegistration, _scaffoldKey, context)
        .then((response) {
      if (response is Success) {
        Navigator.pop(context);
        Navigator.pushNamed(context, BottomNavigationScreen.id);
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  void goBackPressed() {
    if (_currentScreenIndex == 0) {
      Navigator.pop(context);
      Navigator.pushNamed(context, StartScreen.id);
    } else {
      setState(() {
        _currentScreenIndex--;
      });
    }
  }

  Widget getSubScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return NameScreen(
            onChanged: (value) => {_userRegistration.name = value});
      case 1:
        return AgeScreen(
            onChanged: (value) => {_userRegistration.age = value as int});
      case 2:
        return AddPhotoScreen(
            onPhotoChanged: (value) =>
                {_userRegistration.localProfilePhotoPath = value});
      case 3:
        return SelectCityScreen(
          onCountryChnaged: (value) {
            _userRegistration.city['country'] = value;
            print('country $value');
            print(_userRegistration.city);
          },
          onStateChanged: (value) {
            _userRegistration.city['state'] = value;
            print('state $value');
            print(_userRegistration.city);
          },
          onCityChnaged: (value) {
            _userRegistration.city['city'] = value;
            print('city $value');
            print(_userRegistration.city);
          },
        );
      case 4:
        return EmailAndPasswordScreen(
            emailOnChanged: (value) => {_userRegistration.email = value},
            passwordOnChanged: (value) => {_userRegistration.password = value});
      default:
        return Container();
    }
  }

  bool canContinueToNextSubScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return (_userRegistration.name.length >= 2);
      case 1:
        return (_userRegistration.age >= 13 && _userRegistration.age <= 120);
      case 2:
        return _userRegistration.localProfilePhotoPath.isNotEmpty;
      case 3:
        return _userRegistration.city.length == 3;
      default:
        return false;
    }
  }

  String getInvalidRegistrationMessage() {
    switch (_currentScreenIndex) {
      case 0:
        return "Name is too short";
      case 1:
        return "Invalid age";
      case 2:
        return "Invalid photo";
      case 3:
        return "select all the fields";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Register',
            style:
                TextStyle(color: kSecondaryColor, fontWeight: FontWeight.bold),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        body: CustomModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                Container(
                  child: LinearPercentIndicator(
                      lineHeight: 5,
                      percent: (_currentScreenIndex / _endScreenIndex),
                      progressColor: kSecondaryColor,
                      padding: EdgeInsets.zero),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: kDefaultPadding.copyWith(
                          left: kDefaultPadding.left / 2.0,
                          right: 0.0,
                          bottom: 4.0,
                          top: 4.0),
                      child: IconButton(
                        padding: EdgeInsets.all(0.0),
                        icon: Icon(
                          _currentScreenIndex == 0
                              ? Icons.clear
                              : Icons.arrow_back,
                          color: kSecondaryColor,
                          size: 42.0,
                        ),
                        onPressed: () {
                          goBackPressed();
                        },
                      )),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                      width: double.infinity,
                      child: getSubScreen(),
                      padding: kDefaultPadding.copyWith(top: 0, bottom: 0)),
                ),
                Container(
                  padding: kDefaultPadding,
                  child: _currentScreenIndex == (_endScreenIndex)
                      ? CustomButton(
                          height: 50,
                          width: 300,
                          buttonName: 'REGISTER',
                          function: _isLoading == false
                              ? () {
                                  registerUser(context);
                                }
                              : () {})
                      : CustomButton(
                          height: 50,
                          width: 300,
                          buttonName: 'CONTINUE',
                          function: () {
                            if (canContinueToNextSubScreen()) {
                              setState(() {
                                _currentScreenIndex++;
                              });
                            } else
                              showSnackBar(_scaffoldKey,
                                  getInvalidRegistrationMessage(), context);
                          }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
