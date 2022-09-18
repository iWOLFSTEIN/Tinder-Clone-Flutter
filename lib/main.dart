import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_flutter/data/provider/media_provider.dart';
import 'package:tinder_app_flutter/data/provider/user_provider.dart';
import 'package:tinder_app_flutter/ui/screens/chat_screen.dart';
import 'package:tinder_app_flutter/ui/screens/login_screen.dart';
import 'package:tinder_app_flutter/ui/screens/matched_screen.dart';
import 'package:tinder_app_flutter/ui/screens/profile_sub_screens/add_media_screen.dart';
import 'package:tinder_app_flutter/ui/screens/profile_sub_screens/edit_screen.dart';
import 'package:tinder_app_flutter/ui/screens/profile_sub_screens/setting_screen.dart';
import 'package:tinder_app_flutter/ui/screens/register_screen.dart';
import 'package:tinder_app_flutter/ui/screens/splash_screen.dart';
import 'package:tinder_app_flutter/ui/screens/start_screen.dart';
import 'package:tinder_app_flutter/ui/screens/bottom_navigation_screen.dart';
import 'package:tinder_app_flutter/util/constants.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MediaProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: kFontFamily,
          indicatorColor: kSecondaryColor,
          scaffoldBackgroundColor: kPrimaryColor,
          hintColor: kPrimaryColor,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            headline3: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold),
            headline4: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            button: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ).apply(
            bodyColor: kPrimaryColor,
            displayColor: kSecondaryColor,
          ),
          buttonTheme: ButtonThemeData(
              splashColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 14),
              buttonColor: kGrey,
              textTheme: ButtonTextTheme.accent,
              highlightColor: kSecondaryColor,
              focusColor: kSecondaryColor),
          colorScheme: ColorScheme.fromSwatch(
                  primarySwatch:
                      MaterialColor(kBackgroundColorInt, kThemeMaterialColor))
              .copyWith(secondary: kPrimaryColor),
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          StartScreen.id: (context) => StartScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          BottomNavigationScreen.id: (context) => BottomNavigationScreen(),
          MatchedScreen.id: (context) => MatchedScreen(
                myProfilePhotoPath: (ModalRoute.of(context)!.settings.arguments
                    as Map)['my_profile_photo_path'],
                myUserId: (ModalRoute.of(context)!.settings.arguments
                    as Map)['my_user_id'],
                otherUserProfilePhotoPath: (ModalRoute.of(context)!
                    .settings
                    .arguments as Map)['other_user_profile_photo_path'],
                otherUserId: (ModalRoute.of(context)!.settings.arguments
                    as Map)['other_user_id'],
              ),
          ChatScreen.id: (context) => ChatScreen(
                chatId: (ModalRoute.of(context)!.settings.arguments
                    as Map)['chat_id'],
                otherUserId: (ModalRoute.of(context)!.settings.arguments
                    as Map)['other_user_id'],
                myUserId: (ModalRoute.of(context)!.settings.arguments
                    as Map)['user_id'],
              ),
          // SettingScreen.id: (context) => SettingScreen(userProvider:),
          EditScreen.id: (context) => EditScreen(),
          AddMediaScreen.id: (context) => AddMediaScreen(),
        },
      ),
    );
  }
}
