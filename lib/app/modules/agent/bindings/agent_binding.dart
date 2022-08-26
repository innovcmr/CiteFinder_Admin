import 'package:get/get.dart';

import '../controllers/agent_controller.dart';

class AgentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentController>(
      () => AgentController(),
    );
  }
}
