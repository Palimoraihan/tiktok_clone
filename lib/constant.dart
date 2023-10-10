import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/view/page/add/add_page.dart';
import 'package:tiktok_clone/view/page/home/home_page.dart';
import 'package:tiktok_clone/view/page/message/message_page.dart';
import 'package:tiktok_clone/view/page/profile/profile_page.dart';
import 'package:tiktok_clone/view/page/search/search_page.dart';

List page = [
  HomePage(),
  SearchPage(),
  AddPage(),
  MessagePage(),
  ProfilePage(uid: fireAuth.currentUser!.uid,)
];

const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

var fireAuth = FirebaseAuth.instance;
var fireStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
