import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CRUDController extends GetxController {
  CRUDController() : super();

  static CRUDController get to => Get.find();

  int prevLimit = 25;
  RxInt limit = 25.obs;
  ScrollController scrollController = ScrollController();

  RxBool isLoadingMore = false.obs;
  RxBool stopLoadingMore = false.obs;

  int prevCount = 0;
  int currentCount = 0;

  @override
  onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        // load more at list end
        if (isLoadingMore.value || stopLoadingMore.value) return;

        isLoadingMore.value = true;
        prevLimit = limit.value;
        limit.value += 25;

        log("Limit is now ${limit.value}");
      }
    });
  }

  List<dynamic> items = [];

  List<dynamic> searchedItems = [];

  RxString searchKey = "".obs;

  void updateList() {
    update(['items_list']);
    print("list udpated");
  }
}
