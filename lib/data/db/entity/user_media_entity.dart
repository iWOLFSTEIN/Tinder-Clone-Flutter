import 'package:cloud_firestore/cloud_firestore.dart';

class UserMediaEntity {
  List<dynamic>? userMedia;

  UserMediaEntity({
    required this.userMedia,
  });

  UserMediaEntity.fromSnapshot(DocumentSnapshot snapshot) {
    userMedia = snapshot.data().toString().contains('userMedia')
        ? snapshot['userMedia']
        : null;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userMedia': userMedia,
    };
  }
}
