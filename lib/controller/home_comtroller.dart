import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant.dart';
import 'package:tiktok_clone/controller/auth_controller.dart';
import 'package:tiktok_clone/model/video.dart';

class HomeController extends GetxController {
  final Rx<List<VideoModel>> _videoList = Rx<List<VideoModel>>([]);
  List<VideoModel> get videoList => _videoList.value;
  AuthController autController = Get.put(AuthController());

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(firestore
        .collection('videos')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<VideoModel> retVal = [];
      for (var element in querySnapshot.docs) {
        retVal.add(VideoModel.fromSnap(element));
      }
      return retVal;
    }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    String uid = autController.user.uid;

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update(
        {
          'likes': FieldValue.arrayRemove([uid]),
        },
      );
    }else{
      await firestore.collection('videos').doc(id).update(
        {
          'likes': FieldValue.arrayUnion([uid]),
        },
      );
    }
  }
}
