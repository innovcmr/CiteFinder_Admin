import 'package:get/get.dart';

import '../controllers/house_controller.dart';

class HouseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HouseController>(
      () => HouseController(),
    );
  }
}
