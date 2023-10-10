import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentPage extends StatelessWidget {
  final String id;
  CommentPage({super.key, required this.id});
  final TextEditingController commentController = TextEditingController();
  CommentController controller = Get.put(CommentController());
  @override
  Widget build(BuildContext context) {
    controller.updatePostId(id);
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Center(
                child: Container(
              width: 65,
              height: 4,
              color: Colors.white,
            )),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  final dataCom = controller.comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(dataCom.profilePhoto),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataCom.username,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          dataCom.comment,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          tago.format(dataCom.datePublished.toDate()),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${dataCom.likes.length} like',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )
                      ],
                    ),
                    trailing: InkWell(
                        onTap: () {
                          controller.likeComment(dataCom.id);
                        },
                        child: Icon(
                          Icons.favorite,
                          size: 25,
                          color:dataCom.likes.contains(controller.autController.user.uid) ?Colors.red:Colors.white,
                        )),
                  );
                },
              );
            }),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 10,
            color: Colors.black,
            child: Center(
              child: ListTile(
                title: TextFormField(
                  controller: commentController,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'comment',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
                trailing: IconButton(
                    onPressed: () =>
                        controller.postComment(commentController.text),
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
