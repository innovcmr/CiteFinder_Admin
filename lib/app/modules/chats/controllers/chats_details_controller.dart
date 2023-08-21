import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart' as dash;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/image_viewer_controller.dart';
import '../../../data/models/chat.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/user.dart';
import '../../../data/models/user_model.dart';
import '../../../utils/config.dart';
import '../../../utils/new_utils.dart';
import '../../../utils/upload_media.dart';
import '../../image_viewer/image_viewer.dart';

class ChatDetailsController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final AuthController authController = AuthController.to;

  Rx<AppUser?> currentOtherUser = Rx(null);
  Rx<Chat?> currentChat = Rx(null);
  RxList<ChatMessage> messagesList = RxList<ChatMessage>();

  RxList<SelectedMedia> currentMessageMedia = RxList<SelectedMedia>();

  TextEditingController messageController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();
  RxInt messagesLimit = 1000.obs;
  StreamSubscription? subs;
  RxBool isSending = false.obs;
  RxInt messageCount = 0.obs;

  static ChatDetailsController get to => Get.find();

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  void setInitialText(String text) {
    messageController.text = text;
  }

  void bindMessages() async {
    messagesList.bindStream(queryChatMessages());
    messageCount.value = messagesList.length;
  }

  void listenMessages() {
    subs = messagesList.stream.listen((msgs) async {
      if (msgs.isEmpty) {
        return;
      }
      //when new message is received, set is read for the message to true
      if (msgs.length > messageCount.value &&
          msgs.last.receiver == authController.supportUser.value!.record) {
        ChatMessage.updateChatMessage(
            msgs.last.id, {Config.firebaseKeys.isRead: true});
      }

      if (msgs.length != messageCount.value) {
        messageCount.value = msgs.length;
      }
      update(['chat_details']);
    });
  }

  ///method to set isRead property of unread messages for current chat to true, when user opens chat
  Future<void> setReadMessages() async {
    final unreadMessages = await queryCollection<ChatMessage>(
        FirebaseFirestore.instance
            .collection(Config.firebaseKeys.chat_messages),
        objectBuilder: (map) {
      return ChatMessage.fromMap(map);
    }, queryBuilder: (msgs) {
      return msgs
          .where(Config.firebaseKeys.receiver,
              isEqualTo: authController.supportUser.value!.record)
          .where(Config.firebaseKeys.chat, isEqualTo: currentChat.value!.record)
          .where(Config.firebaseKeys.isRead, isEqualTo: false);
    }).first;

    if (unreadMessages.isNotEmpty) {
      for (final ChatMessage msg in unreadMessages) {
        await ChatMessage.updateChatMessage(
            msg.id, {Config.firebaseKeys.isRead: true});
      }
    }
  }

  Future<void> initializeChat(AppUser otherUser,
      [Chat? chat, bool isAdmin = false]) async {
    await Get.showOverlay(
        asyncFunction: () async {
          if (!isAdmin) {
            currentOtherUser = otherUser.obs;
          } else {
            final otherUserDocs = (await (queryCollection<AppUser>(
                    firestore.collection(Config.firebaseKeys.users),
                    objectBuilder: (map) {
              return AppUser.fromMap(map);
            }, queryBuilder: (users) {
              return users.where(Config.firebaseKeys.email,
                  isEqualTo: 'contact@innovcmr.com');
            }, singleRecord: true)
                .first));

            if (otherUserDocs.isEmpty) {
              throw FirebaseException(
                  plugin: 'auth',
                  code: 'support-not-found',
                  message: 'We were unable to load the support chat');
            }

            currentOtherUser = otherUserDocs[0].obs;
          }

          if (chat == null) {
            final users = [
              authController.supportUser.value!.record,
              currentOtherUser.value!.record,
            ];

            final query = await (firestore
                .collection(Config.firebaseKeys.chats)
                .where(Config.firebaseKeys.userA, isEqualTo: users.first)
                .where(Config.firebaseKeys.userB, isEqualTo: users.last)
                .where(Config.firebaseKeys.users,
                    arrayContains: authController.supportUser.value!.record)
                .limit(1)
                .get());

            if (query.docs.isNotEmpty) {
              currentChat.value = Chat.fromMap(query.docs.first.data());
              bindMessages();
              listenMessages();
              setReadMessages();
            }
          } else {
            currentChat.value = chat;
            bindMessages();
            setReadMessages();
            listenMessages();
          }
        },
        loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
  }

  dash.ChatUser get currentChatUser => dash.ChatUser(
      id: authController.supportUser.value!.id!,
      profileImage: authController.supportUser.value!.photoURL,
      firstName: authController.supportUser.value!.fullName);

  dash.ChatUser get currentOtherChatUser => dash.ChatUser(
      id: currentOtherUser.value!.id!,
      profileImage: currentOtherUser.value!.photoURL,
      firstName: currentOtherUser.value!.fullName);

  List<dash.ChatMessage> get chatMessageList => messagesList
      .map<dash.ChatMessage>((msg) => dash.ChatMessage(
          createdAt: msg.timestamp,
          user: msg.sender == currentOtherUser.value!.record
              ? currentOtherChatUser
              : currentChatUser,
          text: msg.text,
          medias: msg.images
              .map((image) => dash.ChatMedia(
                    type: dash.MediaType.image,
                    url: image,
                    uploadedDate: msg.timestamp,
                    fileName: 'image',
                  ))
              .toList()))
      .toList();

  Stream<List<ChatMessage>> queryChatMessages() {
    final collection = firestore.collection(Config.firebaseKeys.chat_messages);

    final stream = queryCollection(collection, objectBuilder: (mapData) {
      return ChatMessage.fromMap(mapData);
    }, queryBuilder: (messages) {
      return messages
          .where(Config.firebaseKeys.chat, isEqualTo: currentChat.value!.record)
          .where(Config.firebaseKeys.visibleTo,
              arrayContains: authController.supportUser.value!.record)
          .orderBy(Config.firebaseKeys.timestamp)
          .limit(messagesLimit.value);
    });

    return stream;
  }

  Future<void> uploadMedia() async {
    //TODO: upload videos

    final selectedMedia =
        await selectMediaWithSourceBottomSheet(allowVideo: false);

    if (selectedMedia != null) {
      Get.put(ImageViewerController());
      Get.to(() => ImageViewWidget(
          imageUrl: '',
          heroTag: 'image_upload',
          bytes: selectedMedia.bytes,
          showInput: true,
          imageType: "memory",
          onSend: (text) async {
            final now = DateTime.now();
            final chatMedia = dash.ChatMedia(
                type: isVideo(selectedMedia.storagePath)
                    ? dash.MediaType.video
                    : dash.MediaType.image,
                url: selectedMedia.storagePath,
                uploadedDate: now,
                fileName: 'find-home_${now.toIso8601String()}',
                customProperties: {"selectedMedia": selectedMedia});

            final message = dash.ChatMessage(
              createdAt: now,
              user: currentChatUser,
              text: text,
              medias: [chatMedia],
            );

            await sendMessage(message);
          }));
    }
  }

  Future<void> sendMessage(dash.ChatMessage message) async {
    if (currentOtherUser.value == null) return;

    messageController.clear();

    try {
      isSending.value = true;
      if (currentChat.value == null) {
        //create a new chat for the two users

        final chatMap = {
          Config.firebaseKeys.users: [
            authController.supportUser.value!.record,
            currentOtherUser.value!.record
          ],
          Config.firebaseKeys.userA: authController.supportUser.value!.record,
          Config.firebaseKeys.userB: currentOtherUser.value!.record,
          Config.firebaseKeys.visibleTo: [
            authController.supportUser.value!.record,
            currentOtherUser.value!.record
          ],
          Config.firebaseKeys.lastMessage: '',
          Config.firebaseKeys.lastMessageSeenBy: null,
          Config.firebaseKeys.lastMessageSentBy: null,
          Config.firebaseKeys.lastMessageTime: null,
        };

        final newChat = await Chat.updateChat(null, chatMap);

        currentChat.update((val) {
          currentChat.value = newChat;
        });

        bindMessages();
      }

      //upload message media files

      final messageMedia = <String>[];

      if (message.medias != null)
        // ignore: curly_braces_in_flow_control_structures
        for (dash.ChatMedia media in message.medias!) {
          if (media.customProperties == null) {
            continue;
          }
          final url = await uploadToStorage(
              media.customProperties!["selectedMedia"] as SelectedMedia);
          messageMedia.add(url);
        }

      final messageMap = {
        Config.firebaseKeys.sender:
            message.user.id == currentOtherUser.value!.id
                ? currentOtherUser.value!.record
                : authController.supportUser.value!.record,
        Config.firebaseKeys.receiver: currentOtherUser.value!.record,
        Config.firebaseKeys.chat: currentChat.value!.record,
        Config.firebaseKeys.text: message.text,
        Config.firebaseKeys.visibleTo: [
          currentOtherUser.value!.record,
          authController.supportUser.value!.record
        ],
        Config.firebaseKeys.timestamp: message.createdAt,
        Config.firebaseKeys.isRead: false,
        Config.firebaseKeys.images: messageMedia
      };

      final newMessage = await ChatMessage.updateChatMessage(null, messageMap);

      //update last message in chat

      Map<String, dynamic> chatUpdateMap = {
        Config.firebaseKeys.lastMessage: newMessage!.text,
        Config.firebaseKeys.lastMessageTime: message.createdAt,
        Config.firebaseKeys.lastMessageSentBy:
            authController.supportUser.value!.record,
        Config.firebaseKeys.lastMessageSeenBy: [
          authController.supportUser.value!.record
        ]
      };

      // if the chat was previously hidden from the user, we add him back to the visibleTo array

      chatUpdateMap.addIf(
          !currentChat.value!.visibleTo
              .contains(authController.supportUser.value!.record),
          Config.firebaseKeys.visibleTo,
          [authController.supportUser.value!.record] +
              currentChat.value!.visibleTo);

      await Chat.updateChat(currentChat.value!.id, chatUpdateMap);
    } on Exception catch (err) {
      Fluttertoast.showToast(msg: "Message not sent. Please try again");
      printError(info: err.toString());
    } finally {
      isSending.value = false;
    }
  }

  Future<void> showMoreMessages() async {
    if (messagesList.length == messagesLimit.value) {
      messagesLimit.value = messagesLimit.value + 25;
    }
  }

  Future<List<ChatMessage>?> getUnreadChatMessages() async {
    if (currentChat.value == null) return null;
    final unreadMessagesDocs = (await firestore
            .collection(Config.firebaseKeys.chat_messages)
            .where(Config.firebaseKeys.chat, isEqualTo: currentChat.value)
            .where(Config.firebaseKeys.isRead, isEqualTo: false)
            .get())
        .docs;

    if (unreadMessagesDocs.isNotEmpty) {
      final msgs = unreadMessagesDocs
          .map((snapshot) => ChatMessage.fromMap(snapshot.data()))
          .toList();

      return msgs;
    }
    return null;
  }
}
