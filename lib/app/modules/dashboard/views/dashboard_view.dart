import 'package:cite_finder_admin/app/modules/home/controllers/home_controller.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                controller.refreshDashboard();
              },
              icon: const Icon(FontAwesomeIcons.arrowRotateRight))
        ],
      ),
      body: Center(
        child: GridView.extent(
          maxCrossAxisExtent: Get.width * 0.3,
          padding: const EdgeInsets.all(8.0),
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: [
            DashboardCard(
              title: "Users",
              count: controller.userCount,
              onTap: () {
                HomeController.to.navigateToPageByTab("users");
              },
            ),
            DashboardCard(
              title: "Houses",
              count: controller.houseCount,
              onTap: () {
                HomeController.to.navigateToPageByTab("home-list");
              },
            ),
            DashboardCard(
              title: "Agents",
              count: controller.agentCount,
              onTap: () {
                HomeController.to.navigateToPageByTab("agents");
              },
            ),
            DashboardCard(
              title: "Bookings",
              count: controller.bookingsCount,
              onTap: () {
                HomeController.to.navigateToPageByTab("booking-requests");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard(
      {Key? key, required this.title, required this.count, this.onTap})
      : super(key: key);

  final String title;
  final Rx<int?> count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: AppTheme.colors.mainPurpleColor,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() => count.value == null ||
                            DashboardController.to.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Get.theme.colorScheme.onPrimary,
                          ))
                        : Text(
                            "$count",
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          )),
                  ]),
            )),
      ),
    );
  }
}
