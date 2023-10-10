import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant.dart';
import 'package:tiktok_clone/model/user.dart';

class SearchController2 extends GetxController {
  final Rx<List<UserModel>> _searchUser = Rx<List<UserModel>>([]);

  List<UserModel> get searchedUser => _searchUser.value;

  searchUser(String typeUser) async {
    _searchUser.bindStream(firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: typeUser)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<UserModel> val = [];
      for (var element in querySnapshot.docs) {
        val.add(UserModel.fromSnap(element));
      }
      return val;
    }));
  }
}
