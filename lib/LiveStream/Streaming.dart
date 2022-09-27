// import 'package:chat_app/Services/FirebaseUserData.dart';
// import 'package:chat_app/utils/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:flutter/material.dart';

class Streaming extends StatefulWidget {
  /// non-modifiable channel name of the page
  final channelName;

  /// non-modifiable client role of the page
  final role;

  final id;

  /// Creates a call page with given channel name.
  const Streaming({Key? key, this.channelName, this.role, this.id})
      : super(key: key);

  @override
  _StreamingState createState() => _StreamingState();
}

class _StreamingState extends State<Streaming> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine? _engine;
  final appId = "fb6325f90dde442a8b16aeb5be262992";
  final token =
      "007eJxTYPg8VdR29jbW3r9m3SKHD6z0u39gs3qX2S8esfUHUt62VzkoMKQlmRkbmaZZGqSkpJqYGCVaJBmaJaYmmSalGpkZWVoaFbfoJn+8qpd8JzueiZEBAkF8doaS1OKSzLx0BgYAOD4keA==";

  var comment = TextEditingController();

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine!.leaveChannel();
    _engine!.destroy();
    super.dispose();
  }

  late Stream<DocumentSnapshot> streamerData;

  var streamerName;

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    checkStreamExist();

    streamerData = firestore.collection('users').doc(widget.id).snapshots();
    // db.streamUserData(email: widget.email);

    streamerData.listen((snapshot) {
      var doc = snapshot.data() as Map;
      setState(() {
        streamerName = doc['name'];
      });
    });
  }

  checkStreamExist() async {
    Stream<DocumentSnapshot> streamer =
        firestore.collection('LiveStreams').doc(widget.id).snapshots();
    streamer.listen((snapshot) {
      if (!snapshot.exists) {
        // Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) Navigator.pop(context);
        // });
      }
    });
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine!.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    await _engine!.setVideoEncoderConfiguration(configuration);
    await _engine!.joinChannel(token, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine!.enableVideo();
    await _engine!.enableAudio();
    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine!.setClientRole(widget.role);
    await _engine!.setEnableSpeakerphone(true);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine!.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
          uid: uid,
          channelId: widget.channelName,
        )));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // final userData = FirebaseGetUserData();

  /// Toolbar layout
  Widget _toolbar({var height, var width}) {
    if (widget.role == ClientRole.Audience) {
      return Container(
        //color: Colors.white,
        // alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(
            vertical: height * 1.7 / 100, horizontal: width * 2.5 / 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('LiveStreams')
                    .doc(widget.id)
                    .collection('Likes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  if (listEquals(snapshot.data!.docs, [])) {
                    return Row(
                      children: [
                        Text(
                          '0',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        )
                      ],
                    );
                  }

                  var counter = 0;
                  for (var data in snapshot.data!.docs) {
                    counter++;
                  }
                  return Row(
                    children: [
                      Text(
                        '$counter',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 16,
                      )
                    ],
                  );
                }),
            SizedBox(
              height: height * 1 / 100,
            ),
            Row(
              children: [
                StreamBuilder<DocumentSnapshot>(
                    stream: firestore
                        .collection('LiveStreams')
                        .doc(widget.id)
                        .collection('Likes')
                        .doc(auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Icon(
                            Icons.favorite_border_outlined,
                            size: ((MediaQuery.of(context).size.height +
                                        MediaQuery.of(context).size.width) /
                                    2) *
                                4.5 /
                                100,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        );
                      }
                      if (!snapshot.data!.exists) {
                        return Container(
                          child: InkWell(
                            onTap: () async {
                              try {
                                await firestore
                                    .collection('LiveStreams')
                                    .doc(widget.id)
                                    .collection('Likes')
                                    .doc(auth.currentUser!.uid)
                                    .set({'id': auth.currentUser!.uid});
                              } catch (e) {}
                            },
                            child: Icon(
                              Icons.favorite_border_outlined,
                              size: ((MediaQuery.of(context).size.height +
                                          MediaQuery.of(context).size.width) /
                                      2) *
                                  4.5 /
                                  100,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        );
                      }
                      return Container(
                        child: InkWell(
                          onTap: () async {
                            try {
                              await firestore
                                  .collection('LiveStreams')
                                  .doc(widget.id)
                                  .collection('Likes')
                                  .doc(auth.currentUser!.uid)
                                  .delete();
                            } catch (e) {}
                          },
                          child: Icon(
                            Icons.favorite,
                            size: ((MediaQuery.of(context).size.height +
                                        MediaQuery.of(context).size.width) /
                                    2) *
                                4.5 /
                                100,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }),
                SizedBox(
                  width: width * 3 / 100,
                ),
                Expanded(
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 7 / 100,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.4)),
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(50),
                        //     bottomLeft: Radius.circular(50))

                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: TextField(
                      controller: comment,
                      style: TextStyle(color: Colors.white),
                      autocorrect: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          isCollapsed: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'write something',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.4))),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 1 / 100,
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      var myDocument = snapshot.data!.data() as Map;
                      return
                          //  Container(
                          //   height: MediaQuery.of(context).size.height * 6.3 / 100,
                          //   decoration: BoxDecoration(
                          //       color: Colors.black.withOpacity(0.4),
                          //       border: Border.all(
                          //           color: Colors.white.withOpacity(0.4)),
                          //       borderRadius: BorderRadius.only(
                          //           topRight: Radius.circular(50),
                          //           bottomRight: Radius.circular(50))),
                          //   child:

                          Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 2 / 100),
                        child: InkWell(
                          onTap: () async {
                            var timestamp = DateTime.now();

                            if (!(comment.text == '')) {
                              var myComment = comment.text;

                              comment.text = '';

                              await firestore
                                  .collection('LiveStreams')
                                  .doc(widget.id)
                                  .collection('Comments')
                                  .add({
                                'name': myDocument['name'],
                                'text': myComment,
                                'timestamp': timestamp
                              });
                            }
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.blue,
                            size: ((MediaQuery.of(context).size.height +
                                        MediaQuery.of(context).size.width) /
                                    2) *
                                4.5 /
                                100,
                          ),
                        ),
                      )
                          // ,
                          // )
                          ;
                    })
              ],
            ),
          ],
        ),
      );
    }
    //  return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('LiveStreams')
                  .doc(widget.id)
                  .collection('Likes')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (listEquals(snapshot.data!.docs, [])) {
                  return Padding(
                    padding: EdgeInsets.only(left: width * 2 / 100),
                    child: Row(
                      children: [
                        Text(
                          '0',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        )
                      ],
                    ),
                  );
                }

                var counter = 0;
                for (var data in snapshot.data!.docs) {
                  counter++;
                }
                return Padding(
                  padding: EdgeInsets.only(left: width * 2 / 100),
                  child: Row(
                    children: [
                      Text(
                        '$counter',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 16,
                      )
                    ],
                  ),
                );
              }),
          SizedBox(
            height: height * 1 / 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RawMaterialButton(
                onPressed: _onToggleMute,
                child: Icon(
                  muted ? Icons.mic_off : Icons.mic,
                  color: muted ? Colors.white : Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: muted ? Colors.blueAccent : Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
              RawMaterialButton(
                onPressed: () => _onCallEnd(context),
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.redAccent,
                padding: const EdgeInsets.all(15.0),
              ),
              RawMaterialButton(
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(12.0),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  final storage = FirebaseFirestore.instance;
  //final auth = FirebaseAuth.instance;
  void _onCallEnd(BuildContext context) async {
    try {
      Navigator.pop(context);

      await firestore
          .collection('LiveStreams')
          .doc(auth.currentUser!.uid)
          .collection('Comments')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      await storage
          .collection('LiveStreams')
          .doc(widget.id)
          .collection('Watchers')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      await storage
          .collection('LiveStreams')
          .doc(widget.id)
          .collection('Likes')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      await firestore
          .collection('LiveStreams')
          .doc(auth.currentUser!.uid)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine!.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine!.switchCamera();
  }

  // FirebaseGetUserData db = FirebaseGetUserData();
  bool isWatching = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var size = (height + width) / 2;
    return WillPopScope(
      onWillPop: () async {
        try {
          if (auth.currentUser!.uid == widget.id) {
            Navigator.pop(context);

            await firestore
                .collection('LiveStreams')
                .doc(auth.currentUser!.uid)
                .collection('Comments')
                .get()
                .then((snapshot) {
              for (DocumentSnapshot ds in snapshot.docs) {
                ds.reference.delete();
              }
            });

            await storage
                .collection('LiveStreams')
                .doc(widget.id)
                .collection('Watchers')
                .get()
                .then((snapshot) {
              for (DocumentSnapshot ds in snapshot.docs) {
                ds.reference.delete();
              }
            });

            await firestore
                .collection('LiveStreams')
                .doc(auth.currentUser!.uid)
                .delete();
          } else {
            Navigator.pop(context);
            await storage
                .collection('LiveStreams')
                .doc(widget.id)
                .collection('Watchers')
                .doc(auth.currentUser!.uid)
                .delete();
          }
        } catch (e) {}
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text((streamerName == null) ? '...' : streamerName),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              Container(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: (widget.role == ClientRole.Broadcaster)
                          ? height * 15 / 100
                          : height * 12 / 100,
                      left: width * 2 / 100),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection('LiveStreams')
                          .doc(widget.id)
                          .collection('Comments')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }

                        var comments = snapshot.data!.docs;
                        List<Widget> widgetList = [];
                        for (var comment in comments) {
                          var commentDocument = comment.data() as Map;
                          final name = commentDocument['name'];
                          final text = commentDocument['text'];

                          widgetList.add(Padding(
                            padding:
                                EdgeInsets.only(bottom: height * 1.2 / 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyan),
                                ),
                                SizedBox(
                                  height: height * 0.2 / 100,
                                ),
                                Text(
                                  text,
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ));
                        }

                        return Container(
                          height: height * 40 / 100,
                          width: width * 60 / 100,
                          child: ListView(
                            reverse: true,
                            children: widgetList,
                          ),
                        );
                      }),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: height * 2 / 100, left: width * 2 / 100),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 1000),
                        padding: EdgeInsets.only(
                            bottom: height * 0.2 / 100,
                            top: height * 0 / 100,
                            left: width * 1.7 / 100,
                            right: width * 2.5 / 100),
                        // decoration: BoxDecoration(
                        //     color: Colors.black.withOpacity(0.4),
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(50))),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: firestore
                                .collection('LiveStreams')
                                .doc(widget.id)
                                .collection('Watchers')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return (!isWatching)
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isWatching = !isWatching;
                                          });
                                        },
                                        child: Icon(Icons.remove_red_eye,
                                            color: Colors.white
                                            // .withOpacity(0.6)
                                            ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isWatching = !isWatching;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.remove_red_eye,
                                                color: Colors.white
                                                // .withOpacity(0.6)
                                                ),
                                            SizedBox(
                                              width: width * 2 / 100,
                                            ),
                                            Text('0',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    // .withOpacity(0.6),
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      );
                              }
                              if (listEquals(snapshot.data!.docs, [])) {
                                return (!isWatching)
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isWatching = !isWatching;
                                          });
                                        },
                                        child: Icon(Icons.remove_red_eye,
                                            color: Colors.white
                                            // .withOpacity(0.6)
                                            ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isWatching = !isWatching;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.remove_red_eye,
                                                color: Colors.white
                                                // .withOpacity(0.6)
                                                ),
                                            SizedBox(
                                              width: width * 2 / 100,
                                            ),
                                            Text('0',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    // .withOpacity(0.6),
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      );
                              }

                              var counter = 0;
                              for (var data in snapshot.data!.docs) {
                                counter++;
                              }
                              return (!isWatching)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isWatching = !isWatching;
                                        });
                                      },
                                      child: Icon(Icons.remove_red_eye,
                                          color: Colors.white
                                          // .withOpacity(0.6)
                                          ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isWatching = !isWatching;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.remove_red_eye,
                                              color: Colors.white
                                              // .withOpacity(0.6)
                                              ),
                                          SizedBox(
                                            width: width * 2 / 100,
                                          ),
                                          Text('$counter',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  // .withOpacity(0.6),
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    );
                            }),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              _toolbar(height: height, width: width),
            ],
          ),
        ),
      ),
    );
  }
}
