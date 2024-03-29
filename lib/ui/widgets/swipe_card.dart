import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/data/db/entity/app_user.dart';
import 'package:tinder_app_flutter/ui/widgets/account_status.dart';
import 'package:tinder_app_flutter/ui/widgets/rounded_icon_button.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class SwipeCard extends StatefulWidget {
  final AppUser? person;

  SwipeCard({required this.person});

  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  bool showInfo = false;

  @override
  Widget build(BuildContext context) {
    // print(widget.person!.name);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)),
          height: MediaQuery.of(context).size.height * 0.700,
          width: MediaQuery.of(context).size.width * 0.85,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                    imageUrl: widget.person!.profilePhotoPath!,
                    fit: BoxFit.cover),
                AccountStatus(
                  uid: widget.person!.id,
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            child: Column(
              children: [
                Padding(
                    padding: showInfo
                        ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                        : EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: getUserContent(context)),
                showInfo ? getBottomInfo() : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getUserContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: widget.person!.name,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text: '  ${widget.person!.age}',
                    style: TextStyle(fontSize: 20)),
              ],
            )),
          ],
        ),
        RoundedIconButton(
          onPressed: () {
            setState(() {
              showInfo = !showInfo;
            });
          },
          iconData: showInfo ? Icons.arrow_downward : Icons.person,
          iconSize: 16,
          buttonColor: kColorPrimaryVariant,
        ),
      ],
    );
  }

  Widget getBottomInfo() {
    return Column(
      children: [
        Divider(
          color: kGrey,
          thickness: 1.5,
          height: 0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            color: Colors.black.withOpacity(.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Opacity(
                  opacity: 0.8,
                  child: Text(
                    widget.person!.bio.length > 0
                        ? widget.person!.bio
                        : "No bio.",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
