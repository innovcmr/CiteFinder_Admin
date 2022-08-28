import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/extensions.dart';
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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: AppTheme.colors.mainGreyBg,
      drawerDragStartBehavior: DragStartBehavior.down,
      drawerEdgeDragWidth: 40,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Welcome Admin'),
            Row(
              children: [
                IconButton(
                  splashRadius: 20,
                  alignment: Alignment.centerRight,
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
                const CircleAvatar(
                  child: Icon(Icons.person),
                  maxRadius: 15,
                )
              ],
            )
          ],
        ),
        backgroundColor: AppTheme.colors.mainGreyBg,
        titleTextStyle: Get.textTheme.headline2!.copyWith(fontSize: 13),
        elevation: 0.4,
        iconTheme: IconThemeData(color: AppTheme.colors.darkerGreyTextColor),
      ),
      body: Obx(
        () => controller.children[controller.index.value]["view"],
      ),
      drawer:
          // Obx(
          //   () => Drawer(
          //     width: 210,
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: ListView(
          //         children: [
          //           // const DrawerHeader(
          //           //   child: Text(
          //           //     'Drawer Header',
          //           //     style: TextStyle(color: Colors.white),
          //           //   ),
          //           //   decoration: BoxDecoration(
          //           //     color: Colors.blue,
          //           //   ),
          //           // ),
          //           ListTile(
          //             leading: Image.asset(
          //               Config.assets.logo,
          //               height: 30,
          //             ),
          //             trailing: IconButton(
          //               icon: const Icon(Icons.close_rounded),
          //               onPressed: controller.closeDrawer,
          //             ),
          //           ),
          //           ...controller.children
          //               .mapIndexed(
          //                 (item, index) => Padding(
          //                   padding: const EdgeInsets.all(3.0),
          //                   child: ListTile(
          //                     shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(40)),
          //                     leading: Icon(
          //                       item["icon"],
          //                       color: controller.index.value == index
          //                           ? AppTheme.colors.mainPurpleColor
          //                           : AppTheme.colors.greySidebarTextColor,
          //                     ),
          //                     title: Text(item["label"]),
          //                     textColor: AppTheme.colors.greySidebarTextColor,
          //                     selectedColor: AppTheme.colors.mainPurpleColor,
          //                     selectedTileColor: AppTheme
          //                         .colors.mainLightPurpleColor
          //                         .withOpacity(0.15),
          //                     selected: controller.index.value == index,
          //                     onTap: controller.changeIndex(index),
          //                   ),
          //                 ),
          //               )
          //               .toList(),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          Drawer(
        width: 210,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<HomeController>(
            id: "drawer",
            builder: (controller) => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      leading: Icon(
                        controller.children[index]["icon"],
                        color: controller.index.value == index
                            ? AppTheme.colors.mainPurpleColor
                            : AppTheme.colors.greySidebarTextColor,
                      ),
                      title: Text(controller.children[index]["label"]),
                      textColor: AppTheme.colors.greySidebarTextColor,
                      selectedColor: AppTheme.colors.mainPurpleColor,
                      selectedTileColor: AppTheme.colors.mainLightPurpleColor
                          .withOpacity(0.15),
                      selected: controller.index.value == index,
                      onTap: controller.changeIndex(index),
                    ),
                  );
                }
                // ],
                ),
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
  }
}
