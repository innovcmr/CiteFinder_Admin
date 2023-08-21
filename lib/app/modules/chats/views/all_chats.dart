import 'package:cite_finder_admin/app/data/models/user.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../components/ChatListItem.dart';
import '../../../components/PageScrollView.dart';
import '../../../controllers/auth_controller.dart';
import '../controllers/chats_controller.dart';

class AllChatsPage extends GetView<ChatsController> {
  const AllChatsPage({Key? key}) : super(key: key);

  static String get name => '/chats';

  @override
  Widget build(BuildContext context) {
    final AuthController authController = AuthController.to;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PageScrollView(
          title: 'allChats'.tr,
          showLeading: true,
          overrideBackButton: true,
          onExit: () {
            if (Get.rootDelegate.history.length == 1) {
              Get.rootDelegate.offNamed(Routes.HOME);
              return;
            }

            Get.back();
          },
          body: Obx(() {
            return authController.supportUser.value == null
                ? const Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : controller.chatsList.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.35),
                        child: Center(
                            child: Text("You have no chats for now".tr,
                                style: Get.textTheme.titleLarge)),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.chatsList.length,
                        itemBuilder: (context, index) {
                          final chat = controller.chatsList[index];

                          return FutureBuilder<AppUser>(
                              future: chat.users.length > 1
                                  ? AppUser.getUserFromFirestore(
                                      chat.users
                                          .firstWhere(
                                            (ref) =>
                                                ref !=
                                                authController
                                                    .supportUser.value!.record,
                                          )
                                          .id,
                                    )
                                  : Future.error("userNotFound".tr),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SpinKitThreeBounce(
                                        color: Get.theme.primaryColor,
                                        size: 18),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Text('errorRetrievingThisChat'.tr);
                                }

                                final otherUser = snapshot.data!;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: ChatListItem(
                                    user: otherUser,
                                    chat: chat,
                                    onTap: () {
                                      controller.selectChat(chat, otherUser);
                                    },
                                    onDelete: (ctx) =>
                                        controller.deleteChat(chat, otherUser),
                                  ),
                                );
                              });
                        },
                      );
          }),
        ),
      ),
    );
  }
}
