import 'package:cite_finder_admin/app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}
