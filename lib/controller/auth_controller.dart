import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constant.dart';
import 'package:tiktok_clone/model/user.dart';
import 'package:tiktok_clone/view/page/auth/login_page.dart';
import 'package:tiktok_clone/view/page/auth/signup_page.dart';
import 'package:tiktok_clone/view/page/main_page/main_page.dart';

class AuthController extends GetxController {
  late Rx<File?> _pickedImage;
  late Rx<User?> _user;
  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(fireAuth.currentUser);
    _user.bindStream(fireAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => const MainPage());
    }
  }

  void pickImage() async {
    final pickerImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerImage != null) {
      Get.snackbar('Profile Picture', 'Succesfuly select some image');
    }
    _pickedImage = Rx<File?>(File(pickerImage!.path));
  }

  Future<String> _uploadImage(File image) async {
    Reference ref =
        fireStorage.ref().child('profile').child(fireAuth.currentUser!.uid);

    UploadTask uplaodLoad = ref.putFile(image);
    TaskSnapshot snap = await uplaodLoad;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void createUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential credential =
            await fireAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String imageUrl = await _uploadImage(image);
        UserModel userMod = UserModel(
            name: username,
            email: email,
            uid: credential.user!.uid,
            profile: imageUrl);
        await firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userMod.toJson());
        Get.snackbar('Success', 'Your profile has been add');
      } else {
        Get.snackbar('Error', 'All data required');
      }
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await fireAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Get.snackbar('Success', 'login success');
      } else {
        Get.snackbar('Error', 'All data required for login');
      }
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }
}
