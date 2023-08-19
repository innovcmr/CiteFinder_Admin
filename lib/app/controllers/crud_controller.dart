import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class CRUDController extends GetxController {
  CRUDController() : super();

  static CRUDController get to => Get.find();

  int prevLimit = 25;
  RxInt limit = 25.obs;
  ScrollController scrollController = ScrollController();

  final Debouncer debouncer = Debouncer(milliseconds: 500);

  RxBool isLoadingMore = false.obs;
  RxBool stopLoadingMore = false.obs;

  RxBool isSearching = false.obs;

  RxBool isListLoading = false.obs;

  @override
  onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        // load more at list end
        if (isLoadingMore.value || stopLoadingMore.value || isSearching.value)
          return;

        isLoadingMore.value = true;
        prevLimit = limit.value;
        limit.value += 25;

        log("Limit is now ${limit.value}");
      }
    });
  }

  void reset() {
    items.clear();
    searchedItems.clear();
    searchKey.value = "";
    prevLimit = 25;
    limit.value = 25;
    isSearching.value = false;
    isLoadingMore.value = false;
    stopLoadingMore.value = false;
    isListLoading.value = false;
  }

  List<dynamic> items = [];

  List<dynamic> searchedItems = [];

  RxString searchKey = "".obs;

  void updateList() {
    update(['items_list']);
    print("list udpated");
  }
}
