import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant.dart';
import 'package:tiktok_clone/controller/profile_controller.dart';
import 'package:tiktok_clone/view/page/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.updateUserId(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (ctx) {
          return ctx.user.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.black,
                    leading: IconButton(
                      onPressed: () {
                        if (widget.uid == controller.authController.user.uid) {
                        } else {
                          Get.back();
                        }
                      },
                      icon: Icon(
                          widget.uid == controller.authController.user.uid
                              ? Icons.person_add_alt_1_outlined
                              : Icons.arrow_back),
                    ),
                    centerTitle: false,
                    title: Text(controller.user['name']),
                    actions: const [Icon(Icons.more_vert)],
                  ),
                  body: SafeArea(
                      child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: controller.user['profile'],
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    controller.user['following'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text('Following')
                                ],
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Column(
                                children: [
                                  Text(
                                    controller.user['followers'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text('Followers')
                                ],
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Column(
                                children: [
                                  Text(
                                    controller.user['likes'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text('Likes')
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 47,
                        width: 140,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () async {
                              if (widget.uid ==
                                  controller.authController.user.uid) {
                                await fireAuth.signOut();
                              } else {}
                            },
                            child: Text(
                                widget.uid == controller.authController.user.uid
                                    ? 'Sign Out'
                                    : controller.user['isFollowing']
                                        ? 'Unfollow'
                                        : 'Follow'),
                          ),
                        ),
                      ),
                    ],
                  )),
                );
        });
  }
}
// TextButton(
//             onPressed: () async {
//               await fireAuth.signOut();
//               Get.offAll(LoginPage());
//             },
//             child: Text('Log Out')),