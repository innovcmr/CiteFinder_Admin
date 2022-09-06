import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HouseController extends GetxController {
  //TODO: Implement HouseController

  final count = 0.obs;
  final searchController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   //   // executes after build
    // });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
