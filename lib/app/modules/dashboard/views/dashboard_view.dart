import 'package:cite_finder_admin/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeView().MainAppBar(),
      drawer: MainDrawer(),
      body: Center(
        child: Text(
          'DashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
