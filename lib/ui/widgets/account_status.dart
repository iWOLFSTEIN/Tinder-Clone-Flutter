import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountStatus extends StatelessWidget {
  const AccountStatus({Key? key, this.uid}) : super(key: key);
  final uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('verification')
            .doc('cnic_verification')
            .snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          bool verificationState = false;
          if (snapshot.data!.data() != null) {
            var document = snapshot.data!.data() as Map;
            if (document['status'] == 'verified') verificationState = true;
          }

          return Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, right: 15),
                child: (!verificationState)
                    ? CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white.withOpacity(0.0),
                        child:
                            Icon(Icons.warning, color: Colors.yellow.shade700))
                    : CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.verified, color: Colors.blue)),
              ));
        }));
  }
}
