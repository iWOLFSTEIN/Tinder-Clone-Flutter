import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/db/entity/user_media_entity.dart';
import '../../../data/provider/media_provider.dart';
import '../../../util/constants.dart';
import '../../widgets/custom_modal_progress_hud.dart';

// class ShowMediaScreen extends StatefulWidget {
//   const ShowMediaScreen({Key? key}) : super(key: key);

//   @override
//   State<ShowMediaScreen> createState() => _ShowMediaScreenState();
// }

// class _ShowMediaScreenState extends State<ShowMediaScreen> {
//   final key = GlobalKey<ScaffoldState>();
//   var uid = FirebaseAuth.instance.currentUser!.uid;

//   @override
Widget showMedia(context, key, uid, height, width) {
  return Container(
    child: Consumer<MediaProvider>(builder: (context, mediaProvider, child) {
      return FutureBuilder<UserMediaEntity?>(
          future: mediaProvider.getMedia(uid, context, key),
          builder: (context, userSnapshot) {
            print('Mehdi-------------------------------');
            userSnapshot.data?.userMedia != null
                ? print(userSnapshot.data?.userMedia)
                : print('sorry no data');
            return CustomModalProgressHUD(
                inAsyncCall: mediaProvider.isLoading,
                child: userSnapshot.data?.userMedia != null
                    ? Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            for (var i = 0; i <= 5; i++)
                              Container(
                                decoration: BoxDecoration(
                                    color: kGrey.withOpacity(0.3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: userSnapshot.data?.userMedia![i],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    : Center(
                        child: Container(
                        child: Text(
                          'Add Your Pictures',
                          style: TextStyle(color: kSecondaryColor),
                        ),
                      )));
          });
    }),
  );
}
// }
