import 'package:cite_finder_admin/app/components/crudComponentWidget.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      backgroundColor: AppTheme.colors.mainGreyBg,
      body: CRUD(
        title: "Users",
        subTitle: "All Users",
        moduleItems: controller.moduleItems,
        searchController: controller.searchController,
      ),
    );
  }
}
