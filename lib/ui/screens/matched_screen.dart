import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_flutter/data/db/entity/app_user.dart';
import 'package:tinder_app_flutter/data/provider/user_provider.dart';
import 'package:tinder_app_flutter/ui/screens/chat_screen.dart';
import 'package:tinder_app_flutter/ui/screens/start_screen.dart';
import 'package:tinder_app_flutter/ui/widgets/portrait.dart';
import 'package:tinder_app_flutter/ui/widgets/rounded_button.dart';
import 'package:tinder_app_flutter/ui/widgets/rounded_outlined_button.dart';
import 'package:tinder_app_flutter/util/utils.dart';

class MatchedScreen extends StatelessWidget {
  static const String id = 'matched_screen';

  final String? myProfilePhotoPath;
  final String? myUserId;
  final String? otherUserProfilePhotoPath;
  final String? otherUserId;

  MatchedScreen(
      {required this.myProfilePhotoPath,
      required this.myUserId,
      required this.otherUserProfilePhotoPath,
      required this.otherUserId});

  void sendMessagePressed(BuildContext context) async {
    AppUser? user =
        await (Provider.of<UserProvider>(context, listen: false).user);

    Navigator.pop(context);
    Navigator.pushNamed(context, ChatScreen.id, arguments: {
      "chat_id": compareAndCombineIds(myUserId!, otherUserId!),
      "user_id": user!.id,
      "other_user_id": otherUserId
    });
  }

  void keepSwipingPressed(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 42.0,
            horizontal: 18.0,
          ),
          margin: EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Portrait(imageUrl: myProfilePhotoPath),
                    Portrait(imageUrl: otherUserProfilePhotoPath)
                  ],
                ),
              ),
              Column(
                children: [
                  CustomButton(
                    buttonName: 'SEND MESSAGE',
                    height: 50,
                    width: 300,
                    function: () {
                      sendMessagePressed(context);
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                      buttonName: 'KEEP SWIPPING',
                      width: 300,
                      height: 50,
                      function: () {
                        keepSwipingPressed(context);
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
