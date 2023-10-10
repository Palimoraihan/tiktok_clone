import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/home_comtroller.dart';
import 'package:tiktok_clone/view/page/home/comment_page.dart';
import 'package:tiktok_clone/view/widget/video_player_item.dart';

import '../../widget/circle_animation.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.grey,
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.circular(25)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(body: Obx(() {
      return PageView.builder(
        itemCount: controller.videoList.length,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final dataItem = controller.videoList[index];
          return Stack(
            children: [
              VideoPlayerItem(videoUrl: dataItem.videoUrl),
              Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                dataItem.username,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                dataItem.caption,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 2.5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.music_note,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    dataItem.songName,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        margin: EdgeInsets.only(top: size.height / 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildProfile(dataItem.profilePhoto),
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        controller.likeVideo(dataItem.id),
                                    child: Icon(
                                      Icons.favorite,
                                      size: 40,
                                      color: dataItem.likes.contains(
                                              controller.autController.user.uid)
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    '${dataItem.likes.length}',
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ]),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () => showModalBottomSheet(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.5),
                                    enableDrag: true,
                                    barrierColor: Colors.transparent,
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    builder: (context) => CommentPage(
                                      id: dataItem.id,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.comment,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  '${dataItem.commentCount}',
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.reply,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  '${dataItem.shareCount}',
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                            CircleAnimation(
                              child: buildMusicAlbum(dataItem.profilePhoto),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              )
            ],
          );
        },
      );
    }));
  }
}
