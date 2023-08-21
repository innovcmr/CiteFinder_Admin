import 'package:cite_finder_admin/app/components/user_avatar.dart';
import 'package:cite_finder_admin/app/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../data/models/chat.dart';
import '../data/models/chat_message.dart';
import '../data/models/user_model.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem(
      {Key? key,
      this.onDelete,
      this.onTap,
      required this.user,
      required this.chat})
      : super(key: key);

  final void Function(BuildContext)? onDelete;

  final VoidCallback? onTap;
  final AppUser user;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.to;
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.3,
            children: [
              SlidableAction(
                // An action can be bigger than the others.
                flex: 1,
                onPressed: onDelete,
                backgroundColor: Get.theme.colorScheme.primary,
                foregroundColor: Colors.white,
                icon: FontAwesomeIcons.trash,
                label: 'delete'.tr,
              ),
            ],
          ),
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(25),
                  color: Get.isDarkMode
                      ? Get.theme.colorScheme.tertiary
                      : Colors.grey[200]),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      UserAvatar(currentUser: user, heroTag: '${user.id}'),
                      // Positioned(
                      //     top: 4,
                      //     right: 4,
                      //     child: Container(
                      //         width: 10,
                      //         height: 10,
                      //         decoration: const BoxDecoration(
                      //             shape: BoxShape.circle, color: Colors.red))

                      //             )
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${user.fullName}',
                              overflow: TextOverflow.ellipsis,
                              style: Get.textTheme.bodyLarge!.copyWith(
                                  color: Get
                                      .theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('${chat.lastMessage}',
                              overflow: TextOverflow.ellipsis,
                              style: Get.textTheme.bodyMedium!.copyWith(
                                  color: Get
                                      .theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.w500)),
                        ]),
                  ),
                  const SizedBox(width: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chatListItemTime(chat.lastMessageTime),
                            style: Get.textTheme.bodySmall!
                                .copyWith(color: Colors.grey[400])),

                        //Unread messages badge

                        StreamBuilder<List<ChatMessage>>(
                            stream: queryCollection<ChatMessage>(
                                FirebaseFirestore.instance.collection(
                                    Config.firebaseKeys.chat_messages),
                                objectBuilder: (map) {
                              return ChatMessage.fromMap(map);
                            }, queryBuilder: (msgs) {
                              return msgs
                                  .where(Config.firebaseKeys.receiver,
                                      isEqualTo: authController
                                          .currentUser.value!.record)
                                  .where(Config.firebaseKeys.chat,
                                      isEqualTo: chat.record)
                                  .where(Config.firebaseKeys.isRead,
                                      isEqualTo: false);
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.hasError ||
                                  !snapshot.hasData ||
                                  snapshot.data == null ||
                                  snapshot.data!.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              final unreadMessagesCount = snapshot.data!.length;
                              return Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 4.5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9999),
                                      color: Colors.red),
                                  child: Text('$unreadMessagesCount',
                                      style: Get.textTheme.bodySmall!
                                          .copyWith(color: Colors.white)));
                            })
                      ])
                ],
              )),
        ),
      ),
    );
  }
}
