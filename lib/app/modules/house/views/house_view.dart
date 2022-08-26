import 'package:cite_finder_admin/app/components/crudComponentWidget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/themes/themes.dart';
import '../controllers/house_controller.dart';

class HouseView extends GetView<HouseController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HouseController());
    return Scaffold(
      backgroundColor: AppTheme.colors.mainGreyBg,
      body: CRUD(
        title: "Houses",
        subTitle: "All Houses",
        searchController: controller.searchController,
      ),
    );
  }
}
