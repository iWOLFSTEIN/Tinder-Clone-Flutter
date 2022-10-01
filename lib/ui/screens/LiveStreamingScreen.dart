import 'dart:math';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tinder_app_flutter/LiveStream/StartStream.dart';
import 'package:tinder_app_flutter/LiveStream/Streaming.dart';
// import 'package:volume/volume.dart';

class LiveStreamingScreen extends StatefulWidget {
  LiveStreamingScreen({Key? key}) : super(key: key);

  @override
  _LiveStreamingScreenState createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen>
    with AutomaticKeepAliveClientMixin<LiveStreamingScreen> {
  final myUid = FirebaseAuth.instance.currentUser!.uid;
  final storage = FirebaseFirestore.instance;
  // AudioManager? audioManager;
  // int? maxVol, currentVol;
  // ShowVolumeUI showVolumeUI = ShowVolumeUI.HIDE;

  @override
  void initState() {
    super.initState();
    // audioManager = AudioManager.STREAM_SYSTEM;
    // initAudioStreamType();
    // updateVolumes();
  }

  // Future<void> initAudioStreamType() async {
  //   await Volume.controlVolume(AudioManager.STREAM_SYSTEM);
  // }

  // updateVolumes() async {
  //   // get Max Volume
  //   maxVol = await Volume.getMaxVol;
  //   // get Current Volume
  //   currentVol = await Volume.getVol;

  //   if (mounted) setState(() {});
  // }

  // setVol(int i) async {
  //   await Volume.setVol(i, showVolumeUI: showVolumeUI);
  // }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  List<Widget> streamersList = [];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    var size = (heigth + width) / 4;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF13293D),
      //   title: Text('Live Streams'),
      // ),
      body: StreamBuilder<QuerySnapshot>(
          stream: storage.collection('LiveStreams').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // if (listEquals(snapshot.data!.docs, [])) {
            //   return Center(
            //     child: Text(
            //       'No live streams',
            //       style: TextStyle(color: Colors.black.withOpacity(0.4)),
            //     ),
            //   );
            // }
            List<Widget> streamers = [];
            streamers = [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 1 / 100, vertical: heigth * 1 / 100),
                child: InkWell(
                  onTap: () async {
                    var id = "testing_app";
                    // generateRandomString(16);

                    try {
                      await _handleCameraAndMic(Permission.microphone);
                      await _handleCameraAndMic(Permission.camera);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartStream(
                                    role: ClientRole.Broadcaster,
                                    id: myUid,
                                    chennelId: id,
                                  )));

                      await storage.collection('LiveStreams').doc(myUid).set({
                        'id': myUid,
                        'chennelId': id,
                      });
                    } catch (e) {}
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Container(),
                        // Container(),
                        Padding(
                          padding: EdgeInsets.only(top: heigth * 5 / 100),
                          child: Icon(
                            Icons.stream_rounded,
                            size: size * 30 / 100,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: heigth * 5 / 100,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: heigth * 1 / 100),
                          child: Text(
                            'Go Live !',
                            style: TextStyle(
                              fontSize: 19,
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Container(),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xFFE1E4E8),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(colors: [
                          Color(0xFF1AB4E4).withOpacity(0.7),
                          Color(0xFF00EFD3).withOpacity(0.4),
                          // Color(0xFFE1E4E8),
                        ], begin: Alignment.topRight, end: Alignment.bottomLeft)
                        // border: Border.all(
                        //   color: Colors.white,
                        //   //  width: width * 0.5 / 100
                        // )
                        ),
                  ),
                ),
              ),
            ];

            for (var data in snapshot.data!.docs) {
              var document = data.data() as Map;
              var chennelId = document['chennelId'];
              var streamerId = document['id'];
              if (streamerId == myUid) continue;
              var widget = StreamBuilder<DocumentSnapshot>(
                  stream:
                      storage.collection('users').doc(streamerId).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        color: Colors.black,
                      );
                    }
                    var userDocument = snapshot.data!.data() as Map;
                    var name = userDocument['name'];
                    var profilePic = userDocument['profile_photo_path'];

                    return
                        //  (snapshot.data.data()['profilePic'] == '' ||
                        //         snapshot.data.data()['profilePic'] == null)
                        //     ? Padding(
                        //         padding: EdgeInsets.symmetric(
                        //             horizontal: width * 1 / 100,
                        //             vertical: heigth * 1 / 100),
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //               borderRadius:
                        //                   BorderRadius.all(Radius.circular(20)),
                        //               color: Colors.black,
                        //               image: DecorationImage(
                        //                   image: AssetImage('images/user1.png'),
                        //                   fit: BoxFit.cover)),
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.end,
                        //             children: [
                        //               Padding(
                        //                 padding: EdgeInsets.only(
                        //                     bottom: heigth * 2 / 100),
                        //                 child: Text(
                        //                   name,
                        //                   style: TextStyle(
                        //                       color: Colors.white,
                        //                       fontSize: size * 7 / 100),
                        //                 ),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     :
                        // FutureBuilder(
                        //     future: FireStorageService.loadImage(
                        //         context, snapshot.data.data()['profilePic']),
                        //     builder: (context, snapshot) {
                        //       if (!snapshot.hasData) {
                        //         return Center(
                        //             child: CircularProgressIndicator());
                        //       }
                        //       return
                        InkWell(
                      onTap: () async {
                        try {
                          await _handleCameraAndMic(Permission.microphone);
                          await _handleCameraAndMic(Permission.camera);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Streaming(
                                        channelName: chennelId,
                                        role: ClientRole.Audience,
                                        id: streamerId,
                                      )));

                          await storage
                              .collection('LiveStreams')
                              .doc(streamerId)
                              .collection('Watchers')
                              .doc(myUid)
                              .set({'id': myUid});

                          // var aM = AudioManager.STREAM_MUSIC;

                          // if (mounted)
                          //   setState(() {
                          //     audioManager = aM;
                          //   });
                          // await Volume.controlVolume(aM);

                          // var expectedVolume = maxVol! / 2;
                          // setVol(expectedVolume.toInt());
                          // updateVolumes();
                        } catch (e) {}
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 1 / 100,
                            vertical: heigth * 1 / 100),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(profilePic),
                                  fit: BoxFit.cover)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width * 4 / 100,
                                    bottom: heigth * 2 / 100),
                                child:
                                    //  Container(
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.black.withOpacity(0.55),
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(20))),
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child:
                                    Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size * 6 / 100),
                                ),
                                // ),
                                // ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    // });
                  });

              streamers.add(widget);
            }

            streamersList = streamers;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (width * 40 / 100 / (heigth * 15 / 100) / 2),
                children: streamersList,
              ),
            );
          }),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
