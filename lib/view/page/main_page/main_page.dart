import 'package:flutter/material.dart';
import 'package:tiktok_clone/constant.dart';
import 'package:tiktok_clone/view/widget/custom_icon.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageIndx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[pageIndx],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              pageIndx = value;
            });
          },
          backgroundColor: backgroundColor,
          selectedItemColor: Color.fromARGB(255, 232, 101, 92),
          unselectedItemColor: Colors.white,
          currentIndex: pageIndx,
          
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: CustomIcon(),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
                size: 30,
              ),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'Profile',
            ),
          ]),
    );
  }
}
