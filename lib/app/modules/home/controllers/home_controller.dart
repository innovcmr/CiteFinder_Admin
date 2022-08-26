import 'package:cite_finder_admin/app/modules/agent/views/agent_view.dart';
import 'package:cite_finder_admin/app/modules/dashboard/views/dashboard_view.dart';
import 'package:cite_finder_admin/app/modules/house/views/house_view.dart';
import 'package:cite_finder_admin/app/modules/user/views/user_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final index = 1.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> children = [
    {"view": DashboardView(), "label": "Dashboard", "icon": Icons.dashboard},
    {
      "view": HouseView(),
      "label": "Houses",
      "icon": Icons.maps_home_work_rounded
    },
    {
      "view": UserView(),
      "label": "Users",
      "icon": Icons.people_outline_rounded
    },
    {
      "view": AgentView(),
      "label": "House Agent",
      "icon": Icons.real_estate_agent
    },
  ];
  late Map<int, Map<String, dynamic>> child;
  @override
  void onInit() {
    child = children.asMap();
    super.onInit();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build
    // });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => index.value++;

  changeIndex(int val) {
    print(index);
    // Future.delayed(Duration(milliseconds: 100), () {
    // if () {}
    // index(val);
    // update(["drawer"]);
    // });
    // index(val);
  }

// To open and close the sidebar(drawer)
  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState!.closeDrawer();
  }
}
