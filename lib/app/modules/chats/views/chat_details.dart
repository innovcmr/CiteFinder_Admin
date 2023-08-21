import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import "package:intl/intl.dart";

import '../../../components/CircularButton.dart';
import '../../../components/user_avatar.dart';
import '../../../controllers/image_viewer_controller.dart';
import '../../../utils/new_utils.dart';
import '../../image_viewer/image_viewer.dart';
import '../controllers/chats_details_controller.dart';

class ChatDetailsPage extends GetView<ChatDetailsController> {
  const ChatDetailsPage({Key? key}) : super(key: key);

  static String get name => "/chat-details";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.isDarkMode
            ? Get.theme.colorScheme.background
            : Colors.grey[300],
        body: Obx(() {
          return SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: DashChat(
                      currentUser: controller.currentChatUser,
                      onSend: controller.isSending.value
                          ? (msg) => {}
                          : controller.sendMessage,
                      messages: controller.chatMessageList.reversed.toList(),
                      messageOptions: MessageOptions(
                          showTime: true,
                          // messageMediaBuilder: (msg1, msg2, msg3) {},
                          onTapMedia: (media) {
                            if (media.type == MediaType.image) {
                              Get.put(ImageViewerController());
                              Get.to(() => ImageViewWidget(
                                    imageUrl: media.url,
                                    heroTag: media.url,
                                  ));
                            } else {
                              //TODO: for videos send to video player
                            }
                          }),
                      messageListOptions: MessageListOptions(
                          dateSeparatorFormat: DateFormat.yMMMd(),
                          dateSeparatorBuilder: (date) {
                            if (isToday(date)) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25.0),
                                child: Text("today".tr),
                              );
                            } else if (isYesterday(date)) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25.0),
                                child: Text("yesterday".tr),
                              );
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25.0),
                                child: Text(dateTimeFormat(
                                    DateFormat.YEAR_ABBR_MONTH_DAY, date)),
                              );
                            }
                          },
                          onLoadEarlier: controller.showMoreMessages),
                      inputOptions: InputOptions(
                          sendButtonBuilder: (send) {
                            return InkWell(
                                onTap: send,
                                child: Obx(() {
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: !controller.isSending.value
                                        ? Icon(Icons.send_outlined,
                                            color:
                                                Get.theme.colorScheme.onPrimary,
                                            size: 18)
                                        : SpinKitDualRing(
                                            color:
                                                Get.theme.colorScheme.onPrimary,
                                            lineWidth: 3,
                                            size: 18),
                                  );
                                }));
                          },
                          inputToolbarStyle: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          inputToolbarMargin: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          inputToolbarPadding: EdgeInsets.zero,
                          leading: [
                            IconButton(
                                onPressed: controller.uploadMedia,
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.camera_alt_outlined),
                                color: Get.theme.colorScheme.primary)
                          ],
                          alwaysShowSend: true,
                          textController: controller.messageController,
                          focusNode: controller.messageFocusNode,
                          inputDecoration: InputDecoration(
                              hintText: "leaveAMessage".tr,
                              hintStyle: TextStyle(
                                  color: Colors.grey[500], fontSize: 14),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              )

                              // suffixIcon: Container(
                              //   decoration:BoxDecoration
                              // )
                              ))),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      width: double.infinity,
                      height: 90,
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                          color: Get.theme.colorScheme.background),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularButton(
                            color: Get.theme.colorScheme.surface,
                            radius: 30,
                            onTap: () {
                              Get.back();
                              Get.delete<ChatDetailsController>();
                            },
                            child: const Icon(Icons.arrow_back, size: 30),
                          ),
                          const SizedBox(width: 5),
                          UserAvatar(
                            currentUser: controller.currentOtherUser.value!,
                            heroTag: controller.currentOtherUser.value!.id!,
                            radius: 23,
                          ),
                          const SizedBox(width: 15),
                          Text(controller.currentOtherUser.value!.fullName!,
                              style: Get.textTheme.titleLarge),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                //TODO: open chat menu
                              },
                              icon: const Icon(Icons.more_vert))
                        ],
                      )),
                )
              ],
            ),
          );
        }));
  }
}
