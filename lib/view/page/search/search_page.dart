import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/search_controller.dart';
import 'package:tiktok_clone/model/user.dart';
import 'package:tiktok_clone/view/page/profile/profile_page.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final SearchController2 controller = Get.put(SearchController2());
  @override
  Widget build(BuildContext context) {
    return Obx((){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: TextFormField(
              decoration: const InputDecoration(
                filled: false,
                hintText: 'Search',
              ),
              onFieldSubmitted: (value) => controller.searchUser(value),
            ),
          ),
          body: controller.searchedUser.isEmpty
              ? Center(
                  child: Text('Search User'),
                )
              : ListView.builder(
                itemCount: controller.searchedUser.length,
                  itemBuilder: (context, index) {
                    UserModel user = controller.searchedUser[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(uid: user.uid),)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profile),
                        ),
                        title:  Text(user.name),
                      ),
                    );
                  },
                ),
        );
      }
    );
  }
}
