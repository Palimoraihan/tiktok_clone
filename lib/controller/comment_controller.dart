import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant.dart';
import 'package:tiktok_clone/controller/auth_controller.dart';
import 'package:tiktok_clone/model/comment.dart';

class CommentController extends GetxController {
  final Rx<List<CommentModel>> _comments = Rx<List<CommentModel>>([]);
  List<CommentModel> get comments => _comments.value;
  AuthController autController = Get.put(AuthController());

  String _postId = '';

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(
      firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map(
        (QuerySnapshot querySnapshot) {
          List<CommentModel> retValue = [];
          for (var element in querySnapshot.docs) {
            retValue.add(CommentModel.fromSnap(element));
          }
          return retValue;
        },
      ),
    );
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(autController.user.uid)
            .get();
        var allDoc = await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDoc.docs.length;
        CommentModel comment = CommentModel(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profile'],
          uid: autController.user.uid,
          id: 'Comment $len',
        );
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJson());
        DocumentSnapshot doc =
            await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Comment error while $e');
    }
  }

  likeComment(String id) async {
    var uid = autController.user.uid;
    DocumentSnapshot doc = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();
    if ((doc.data() as dynamic)['likes'].contains(uid)) {
      firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id).update({
            'likes':FieldValue.arrayRemove([uid])
          });
    }else{
      firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}
