import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class Portrait extends StatelessWidget {
  final String? imageUrl;
  final double height;

  Portrait({this.imageUrl, this.height = 225.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.height * 0.65,
      height: height,
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: kGrey),
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.0),
        child: imageUrl!.isNotEmpty
            ? CachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.fitHeight)
            : null,
      ),
    );
  }
}
