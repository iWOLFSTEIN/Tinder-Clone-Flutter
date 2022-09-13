import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/top_navigation_screens/profile_screen.dart';

class AccountStatus extends StatefulWidget {
  const AccountStatus({Key? key, this.uid}) : super(key: key);
  final uid;
  @override
  State<AccountStatus> createState() => _AccountStatusState();
}

class _AccountStatusState extends State<AccountStatus> {
  UserVerificationState verificationState = UserVerificationState.UNVERIFIED;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserVerification();
  }

  getUserVerification() async {
    Stream<DocumentSnapshot> userVerification = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('verification')
        .doc('cnic_verification')
        .snapshots();

    userVerification.listen((snapshot) {
      if (!snapshot.exists) {
        setState(() {
          verificationState = UserVerificationState.UNVERIFIED;
        });
      } else {
        var document = snapshot.data() as Map;
        if (document['status'] == 'pending') {
          setState(() {
            verificationState = UserVerificationState.PENDING;
          });
        } else if (document['status'] == 'verified') {
          verificationState = UserVerificationState.VERIFIED;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, right: 15),
          child: (verificationState == UserVerificationState.UNVERIFIED ||
                  verificationState == UserVerificationState.PENDING)
              ? CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.white.withOpacity(0.0),
                  child: Icon(Icons.warning, color: Colors.yellow.shade700))
              : CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.verified, color: Colors.blue)),
        ));
  }
}
