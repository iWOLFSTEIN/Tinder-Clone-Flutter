import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/util/constants.dart';
import 'package:tinder_app_flutter/ui/screens/login_screen.dart';
import 'package:tinder_app_flutter/ui/screens/register_screen.dart';

class StartScreen extends StatelessWidget {
  static const String id = 'start_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text.rich(TextSpan(
                text: 'Welcome to ',
                style: TextStyle(fontSize: 25, color: Colors.white),
                children: <InlineSpan>[])),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 66, 43, 43),
                  borderRadius: BorderRadius.circular(20)),
              child: const Image(
                image: AssetImage('assets/icon/text.png'),
              ),
            ),
            Image(
              image: const AssetImage('assets/images/welcome.PNG'),
              width: MediaQuery.of(context).size.width,
            ),
            const Text(
              'Find your best match with facemedating',
              style: TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  buttonName: 'Log In',
                  color: Colors.transparent,
                  textColor: kSecondaryColor,
                  function: () => Navigator.pushNamed(context, LoginScreen.id),
                ),
                CustomButton(
                  buttonName: 'Get Started',
                  function: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RegisterScreen.id);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

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
          height: height ?? 60,
          width: width ?? 140,
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


// Scaffold(
//         body: Padding(
//           padding: kDefaultPadding,
//           child: Container(
//             margin: EdgeInsets.only(bottom: 40, top: 120),
//             child: Column(
//               children: [
//                 AppIconTitle(),
//                 Expanded(child: Container()),
//                 Container(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       'Lorel ipsum dolor sit amet, consectetur adipiscing elit. '
//                       'Nulla in orci justo. Curabitur ac gravida quam.',
//                       textAlign: TextAlign.center,
//                       style: Theme.of(context).textTheme.bodyText1,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 60),
//                 RoundedButton(
//                     text: 'CREATE ACCOUNT',
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, RegisterScreen.id);
//                     }),
//                 SizedBox(height: 20),
//                 RoundedOutlinedButton(
//                   text: 'LOGIN',
//                   onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),