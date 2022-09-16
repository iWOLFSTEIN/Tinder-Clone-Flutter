import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/ui/screens/user_profile_screen.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static String id = 'search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? name;
  var uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFE1E4E8),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                onChanged: ((value) {
                  setState(() {
                    name = value.toTitleCase();
                  });
                }),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Search name',
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.4))),
              ),
            ),
          ),
          (name == null || name == '')
              ? InfoResult(
                  info: 'No results',
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('name', isEqualTo: name)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return InfoResult(
                        info: 'Loading...',
                      );
                    }
                    if (listEquals(snapshot.data!.docs, [])) {
                      return InfoResult(
                        info: 'No match found',
                      );
                    }
                    print('printing data list');
                    print(snapshot.data!.docs);
                    List<Widget> widgetsList = [];
                    for (var i in snapshot.data!.docs) {
                      var document = i.data() as Map;
                      if (document['id'] == uid) continue;
                      var widget = ListTile(
                        onTap: (() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserProfileScreen(
                              userDataDocument: document,
                            );
                          }));
                        }),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          backgroundImage: CachedNetworkImageProvider(
                              document['profile_photo_path']),
                        ),
                        title: Text(
                          document['name'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          (document['bio'] == null || document['bio'] == "")
                              ? "No bio"
                              : document['bio'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                      widgetsList.add(widget);
                    }

                    return Expanded(
                      child: ListView(
                        children: widgetsList,
                      ),
                    );
                  })
        ],
      ),
    ));
  }
}

class InfoResult extends StatelessWidget {
  const InfoResult({Key? key, this.info}) : super(key: key);

  final info;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Center(
            child: Text(
          info,
          style: TextStyle(color: Colors.black.withOpacity(0.4)),
        )),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
