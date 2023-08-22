import 'package:cite_finder_admin/app/controllers/crud_controller.dart';
import 'package:cite_finder_admin/app/modules/agent/views/agent_view.dart';
import 'package:cite_finder_admin/app/modules/bookingRequests/views/booking_request_view.dart';
import 'package:cite_finder_admin/app/modules/chats/controllers/chats_controller.dart';
import 'package:cite_finder_admin/app/modules/dashboard/views/dashboard_view.dart';
import 'package:cite_finder_admin/app/modules/home_add_requests/views/home_add_requests_view.dart';
import 'package:cite_finder_admin/app/modules/home_search_request/views/home_search_request_view.dart';
import 'package:cite_finder_admin/app/modules/house/views/home_list_view.dart';
import 'package:cite_finder_admin/app/modules/house/views/house_view.dart';
import 'package:cite_finder_admin/app/modules/user/views/users_list.dart';
import 'package:cite_finder_admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final index = 0.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  static HomeController get to => Get.find();

  final List<Map<String, dynamic>> children = [
    {
      "view": DashboardView(),
      "label": "Dashboard",
      "icon": Icons.dashboard,
      "tab": "dashboard"
    },
    {
      "view": const HomeListView(),
      "label": "Home List",
      "icon": FontAwesomeIcons.house,
      "tab": "home-list"
    },
    {
      "view": const UserListView(),
      "label": "Users",
      "icon": Icons.people_alt_outlined,
      "tab": "users"
    },
    {
      "view": AgentView(),
      "label": "Agent Requests",
      "icon": Icons.real_estate_agent,
      "tab": "agents"
    },
    {
      "view": const Center(child: CircularProgressIndicator()),
      "label": "Chats",
      "icon": Icons.message,
      "tab": "chats"
    },
    {
      "view": const BookingRequestsView(),
      "label": "Booking Requests",
      "icon": Icons.bedroom_parent_outlined,
      "tab": "booking-requests"
    },
    {
      "view": const HomeSearchRequestView(),
      "label": "Home Search Requests",
      "icon": Icons.search,
      "tab": "home-search-requests"
    },
    {
      "view": const AddHomeRequestView(),
      "label": "Home Add Requests",
      "icon": FontAwesomeIcons.houseMedicalCircleCheck,
      "tab": "house-add-requests"
    },
  ];
  late Map<int, Map<String, dynamic>> child;
  @override
  void onInit() {
    child = children.asMap();
    super.onInit();

    final tab =
        Get.rootDelegate.currentConfiguration!.currentPage?.parameters!["tab"];

    if (tab == null) {
      index.value = 0;
      return;
    }

    final tabIndex = children.indexWhere((child) => child["tab"] == tab);

    if (tabIndex == -1) return;

    index.value = tabIndex;
  }

  Future<void> navigateToPage(int index) async {
    this.index.value = index;
    await Get.rootDelegate
        .offNamed(Routes.HOME, parameters: {'tab': children[index]['tab']});
  }

  Future<void> navigateToPageByTab(String tab) async {
    final tabIndex = children.indexWhere((child) => child["tab"] == tab);

    if (tabIndex == -1) return;

    index.value = tabIndex;
    await Get.rootDelegate
        .offNamed(Routes.HOME, parameters: {'tab': children[tabIndex]['tab']});
  }

  changeIndex(int val) {
    // if (val < 2) {
    //   final crudController = CRUDController.to;

    //   crudController.reset();
    //   navigateToPage(val);
    //   return;
    // }

    if (val == 4) {
      if (!Get.isRegistered<ChatsController>()) {
        Get.put(ChatsController());
      }

      Get.rootDelegate.toNamed(Routes.CHATS);
      return;
    }

    navigateToPage(val);

// To open and close the sidebar(drawer)
    void openDrawer() {
      scaffoldKey.currentState!.openDrawer();
    }

    void closeDrawer() {
      scaffoldKey.currentState!.closeDrawer();
    }
  }
}
