import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant.dart';
import 'package:tiktok_clone/controller/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  Rx<String> _uid = ''.obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    print(_uid.value);
    List<String> thumbnail = [];
    var myVideo = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();
    for (var i = 0; i < myVideo.docs.length; i++) {
      thumbnail.add((myVideo.docs[i].data() as dynamic)['thumbnail']);
    }
    DocumentSnapshot useDoc =
        await firestore.collection('users').doc(_uid.value).get();
    final userData = useDoc.data()! as dynamic;
    String name = userData['name'];
    String profileUrl = userData['profile'];
    int likes = 0;
    int follower = 0;
    int following = 0;
    bool isFollowing = false;
    for (var item in myVideo.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    var followerDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    follower = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });
    _user.value = {
      'followers': follower.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profile': profileUrl,
      'name': name,
      'thumbnail': thumbnail,
    };
    update();
  }
}
