import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant.dart';
import 'package:tiktok_clone/model/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String vidioPath) async {
    final compressVid = await VideoCompress.compressVideo(
      vidioPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressVid!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = fireStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = fireStorage.ref().child('thumnail').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = fireAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage('Video $len', videoPath);
      String thumbnailUrl =
          await _uploadImageToStorage('Video $len', videoPath);

      VideoModel video = VideoModel(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: 'Video $len',
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        thumbnail: thumbnailUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profile'],
      );
      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );
      Get.snackbar('Succes', 'Your video success upload');
      Get.back();
    } catch (e) {
      Get.snackbar('Error Upload Video', 'Your video has been canceled');
    }
  }
}
