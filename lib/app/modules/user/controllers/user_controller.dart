import 'dart:developer';

import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

class UserController extends GetxController {
  //TODO: Implement UserController

  final count = 0.obs;
  // It is necasssy to name it as ModuleItemList nd not User because this name is used in child component
  Rx<List<User>> moduleItemList = Rx<List<User>>([]);
  List<User> get moduleItems => moduleItemList.value;
  final userProvider = UserProvider();

  final searchController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    userProvider.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // moduleItemList.bindStream(userProvider.moduleStream());
    // log("user count is ${moduleItems.length}");
    // log("user count is ${moduleItems.first.toString()}");
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
