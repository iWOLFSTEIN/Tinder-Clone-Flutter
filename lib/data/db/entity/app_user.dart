import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String? id;
  String? name;
  int? age;
  String? profilePhotoPath;
  String bio = "";
  Map<String, dynamic>? city;

  AppUser(
      {required this.id,
      required this.name,
      required this.age,
      required this.profilePhotoPath,
      required this.city});

  AppUser.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot['id'];
    name = snapshot['name'];
    age = snapshot['age'];
    profilePhotoPath = snapshot['profile_photo_path'];
    bio = snapshot.get('bio') ?? '';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'profile_photo_path': profilePhotoPath,
      'bio': bio,
      'city': city
    };
  }
}
