import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String profile;
  String email;
  String uid;

  UserModel(
      {required this.name,
      required this.email,
      required this.uid,
      required this.profile});

  Map<String, dynamic> toJson() => {
        'name': name,
        'profile': profile,
        'email': email,
        'uid': uid,
      };
  factory UserModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
   return UserModel(
      name: snapshot['name'],
      email: snapshot['profile'],
      uid: snapshot['uid'],
      profile: snapshot['profile'],
    );
  }
}
