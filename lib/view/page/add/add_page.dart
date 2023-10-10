import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constant.dart';
import 'package:tiktok_clone/view/page/auth/confirm_page.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});
  pickVideo(ImageSource imageSource, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: imageSource);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmPage(videoFile: File(video.path), videoPath: video.path,),
        ),
      );
    }
  }

  showOptionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Galery',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Camera',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: ()=> Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showOptionDialog(context),
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(color: buttonColor),
            child: Center(
              child: Text(
                'Add Your Video',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
