import 'dart:async';

import 'package:cite_finder_admin/app/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../data/models/chat.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/user_model.dart';
import '../../../utils/config.dart';
import '../../../utils/new_utils.dart';
import '../../../utils/upload_media.dart';
import '../views/chat_details.dart';
import 'chats_details_controller.dart';

class ChatsController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final AuthController authController = AuthController.to;

  RxList<Chat> chatsList = RxList<Chat>();

  StreamSubscription? subs;

  @override
  onInit() {
    super.onInit();

    chatsList.bindStream(queryUserChats());

    subs = chatsList.stream.listen((chats) {
      if (chats.isNotEmpty) {
        // chatsList.sort((c1, c2) =>
        //     c2.lastMessageTime?.compareTo(c1.lastMessageTime!) ?? 0);
        update(['all_chats']);
      }
    });
  }

  Stream<List<Chat>> queryUserChats() {
    final collection = firestore.collection(Config.firebaseKeys.chats);

    final stream = queryCollection(collection, objectBuilder: (mapData) {
      return Chat.fromMap(mapData);
    }, queryBuilder: (chats) {
      return chats
          .where(Config.firebaseKeys.visibleTo,
              arrayContains: authController.supportUser.value!.record)
          .orderBy(Config.firebaseKeys.lastMessageTime, descending: true);
    });

    return stream;
  }

  void selectChat(Chat chat, AppUser otherUser) {
    Get.put(ChatDetailsController());
    final chatDetailsController = ChatDetailsController.to;

    chatDetailsController.initializeChat(otherUser, chat);

    Get.to(() => const ChatDetailsPage());
  }

  Future<void> deleteChat(Chat chat, AppUser otherUser) async {
    final result = await Get.defaultDialog<bool>(
        title: "deleteChat".tr,
        middleText:
            "Are you sure you want to delete your chat with ${otherUser.fullName}? ",
        confirmTextColor: Get.theme.colorScheme.onPrimary,
        buttonColor: Get.theme.colorScheme.primary,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false));

    if (result != true) return;

    await Get.showOverlay(
      asyncFunction: () async {
        try {
          //get all chat messages
          final allChatMessages = await (queryCollection(ChatMessage.collection,
              objectBuilder: (mapData) {
            return ChatMessage.fromMap(mapData);
          }, queryBuilder: (msgs) {
            return msgs.where(Config.firebaseKeys.chat, isEqualTo: chat.record);
          }).first);

          //if visibleTo array of chat is not empty, remove current user from it
          if (chat.visibleTo.isNotEmpty &&
              chat.visibleTo
                  .contains(authController.supportUser.value!.record)) {
            List<DocumentReference<Map<String, dynamic>>> oldVisibleTo =
                chat.visibleTo;
            oldVisibleTo.remove(authController.supportUser.value!.record);
            await Chat.updateChat(
                chat.id, {Config.firebaseKeys.visibleTo: oldVisibleTo});

            for (var msg in allChatMessages) {
              List<DocumentReference<Map<String, dynamic>>> oldVisibleTo =
                  msg.visibleTo;
              oldVisibleTo.remove(authController.supportUser.value!.record);
              await ChatMessage.updateChatMessage(
                  msg.id, {Config.firebaseKeys.visibleTo: oldVisibleTo});
            }
            update(['all_chats']);

            Fluttertoast.showToast(msg: "chatDeleted".tr);
            return;
          }

          //if visibleTo array is empty, hard delete all chat messages and chat itself

          //delete every message and its images
          for (var msg in allChatMessages) {
            if (msg.images.isNotEmpty) {
              for (String im in msg.images) {
                await deleteFromStorage(im);
              }
            }
            await msg.delete();
          }

          await chat.delete();
        } on Exception catch (_) {
          Fluttertoast.showToast(msg: "unexpectedError".tr);
        }
      },
      loadingWidget: SpinKitDualRing(
        color: Get.theme.colorScheme.onPrimary,
        lineWidth: 4,
      ),
    );
  }
}
