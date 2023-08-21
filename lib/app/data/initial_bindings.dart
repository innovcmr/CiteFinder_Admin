import 'package:cite_finder_admin/app/controllers/auth_controller.dart';
import 'package:cite_finder_admin/app/controllers/crud_controller.dart';
import 'package:cite_finder_admin/app/modules/agent/controllers/agent_controller.dart';
import 'package:cite_finder_admin/app/modules/bookingRequests/controllers/booking_requests_controller.dart';
import 'package:cite_finder_admin/app/modules/home_add_requests/controllers/home_add_request_controller.dart';
import 'package:cite_finder_admin/app/modules/home_search_request/controllers/home_search_request_controller.dart';
import 'package:cite_finder_admin/app/modules/user/controllers/user_list_controller.dart';
import 'package:get/get.dart';

import '../modules/chats/controllers/chats_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());

    Get.lazyPut(() => ChatsController());
    Get.lazyPut(() => AgentController());
    Get.lazyPut(() => BookingRequestsController());
    Get.lazyPut(() => CRUDController());
    Get.lazyPut(() => HomeSearchRequestController());
    Get.lazyPut(() => HomeAddRequestController());
    Get.lazyPut(() => UsersListController());
  }
}
