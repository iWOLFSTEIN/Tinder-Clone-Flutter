import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../data/db/entity/user_media_entity.dart';
import '../../../data/provider/media_provider.dart';
import '../../../util/constants.dart';
import '../../widgets/custom_modal_progress_hud.dart';
import '../image_view_screen.dart';

// class ShowMediaScreen extends StatefulWidget {
//   const ShowMediaScreen({Key? key}) : super(key: key);

//   @override
//   State<ShowMediaScreen> createState() => _ShowMediaScreenState();
// }

// class _ShowMediaScreenState extends State<ShowMediaScreen> {
//   final key = GlobalKey<ScaffoldState>();
//   var uid = FirebaseAuth.instance.currentUser!.uid;

//   @override
Widget showMedia(
    context,
//  key,
    uid,
    height,
    width) {
  // print('printing the uid of searched user');
  // print(uid);
  return
      //   //  Container(
      //   // child:
      //   Consumer<MediaProvider>(builder: (context, mediaProvider, child) {
      // return FutureBuilder<UserMediaEntity?>(
      //     future: mediaProvider.getMedia(
      //       uid,
      //       //  context,
      //       //  key
      //     ),
      //     builder: (context, userSnapshot) {
      //       // userSnapshot.data?.userMedia != null
      //       //     ? print(userSnapshot.data?.userMedia)
      //       //     : print('sorry no data');
      //       return CustomModalProgressHUD(
      //           inAsyncCall: mediaProvider.isLoading,
      //           child: userSnapshot.data?.userMedia != null
      //               ?

      StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('media')
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            if (!snapshot.data!.exists) {
              return Container();
            }
            List<Widget> widgetsList = [];
            var document = snapshot.data!.data() as Map;

            for (var i = 0; i < document['userMedia'].length; i++) {
              var widget = GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageViewScreen(
                              imageUrl: document['userMedia'][i])));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: kGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: document['userMedia'][i],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
              //     Container(
              //   decoration: BoxDecoration(
              //       color: kGrey.withOpacity(0.3),
              //       borderRadius: BorderRadius.all(Radius.circular(10))),
              // );
              widgetsList.add(widget);
            }
            return Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: widgetsList,
              ),
            );
          })
      //                 : Center(
      //                     child: Container(
      //                     child: Text(
      //                       // 'Add Your Pictures',
      //                       "No pictures to show",
      //                       style: TextStyle(

      //                           // color: kSecondaryColor
      //                           color: Colors.black.withOpacity(0.4)),
      //                     ),
      //                   )));
      //       });
      // })
      //   ,
      // )
      ;
}
// }
