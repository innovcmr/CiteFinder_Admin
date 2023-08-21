import 'package:cached_network_image/cached_network_image.dart';
import 'package:cite_finder_admin/app/components/loaderWidget.dart';
import 'package:cite_finder_admin/app/controllers/auth_controller.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final authController = AuthController.to;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Obx(() {
      return Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: AppTheme.colors.mainGreyBg,
        drawerDragStartBehavior: DragStartBehavior.down,
        drawerEdgeDragWidth: 40,
        appBar: authController.currentUser.value == null
            ? null
            : AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Welcome ${authController.currentUser.value!.fullName}'),
                    Row(
                      children: [
                        IconButton(
                          constraints: BoxConstraints(),
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search_outlined,
                          ),
                        ),
                        IconButton(
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(Icons.notifications),
                        ),
                        InkWell(
                          onTap: () {
                            showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                    Get.width * 0.93, 30, 10, 10),
                                items: [
                                  PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(Duration.zero, () {
                                          authController.signoutUser();
                                        });
                                      },
                                      child: const Text("Logout"))
                                ]);
                          },
                          child: Obx(() {
                            return CircleAvatar(
                              child:
                                  authController.currentUser.value!.photoUrl ==
                                          null
                                      ? const Icon(Icons.person)
                                      : null,
                              backgroundImage: authController
                                          .currentUser.value!.photoUrl ==
                                      null
                                  ? null
                                  : CachedNetworkImageProvider(authController
                                      .currentUser.value!.photoUrl!),
                              maxRadius: 15,
                            );
                          }),
                        )
                      ],
                    )
                  ],
                ),
                backgroundColor: AppTheme.colors.mainGreyBg,
                titleTextStyle: Get.textTheme.headline2!.copyWith(fontSize: 13),
                elevation: 0.4,
                iconTheme:
                    IconThemeData(color: AppTheme.colors.darkerGreyTextColor),
              ),
        body: Obx(
          () => authController.currentUser.value == null
              ? Center(
                  child: LoaderWidget(
                    dense: true,
                  ),
                )
              : controller.children[controller.index.value]["view"],
        ),
        drawer: Drawer(
          width: 210,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.children.length,
                itemBuilder: (BuildContext context, int index) {
                  // ListTile(
                  //   leading: Image.asset(
                  //     Config.assets.logo,
                  //     height: 30,
                  //   ),
                  //   trailing: IconButton(
                  //     icon: const Icon(Icons.close_rounded),
                  //     onPressed: controller.closeDrawer,
                  //   ),
                  // ),
                  // ...
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Obx(() {
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        leading: Icon(
                          controller.children[index]["icon"],
                          color: controller.index.value == index
                              ? AppTheme.colors.mainPurpleColor
                              : AppTheme.colors.darkerGreyTextColor,
                        ),
                        title: Text(controller.children[index]["label"]),
                        textColor: AppTheme.colors.darkerGreyTextColor,
                        selectedColor: AppTheme.colors.mainPurpleColor,
                        selectedTileColor: AppTheme.colors.mainLightPurpleColor
                            .withOpacity(0.15),
                        selected: controller.index.value == index,
                        onTap: () => controller.changeIndex(index),
                      );
                    }),
                  );
                }
                // ],
                ),
          ),
          // ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.menu),
        //   onPressed: controller.openDrawer,
        // ),
      );
    });
  }
}
