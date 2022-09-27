import 'package:cite_finder_admin/app/data/providers/loginProvider.dart';
import 'package:cite_finder_admin/app/modules/dashboard/views/dashboard_view.dart';
import 'package:cite_finder_admin/app/modules/login/controllers/login_controller.dart';
import 'package:cite_finder_admin/app/routes/app_pages.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/extensions.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

// import '../controllers/home_dart';

class HomeView extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  // final List<Map<String, dynamic>> children = [
  //   {
  //     // "view": DashboardView(),
  //     "label": "Dashboard",
  //     "icon": Icons.dashboard,
  //     "route": "/dashboard",
  //   },
  //   {
  //     // "view": HouseView(),
  //     "label": "Houses",
  //     "icon": Icons.maps_home_work_rounded,
  //     "route": "/house"
  //   },
  //   {
  //     // "view": UserView(),
  //     "label": "Users",
  //     "icon": Icons.people_outline_rounded,
  //     "route": "/user"
  //   },
  //   {
  //     // "view": AgentView(),
  //     "label": "House Agent",
  //     "icon": Icons.real_estate_agent,
  //     "route": "/agent"
  //   },
  // ];
  @override
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.colors.mainGreyBg,
      drawerDragStartBehavior: DragStartBehavior.down,
      drawerEdgeDragWidth: 40,
      appBar: MainAppBar(),
      // body: Obx(
      //   () => children[0]["view"],
      // ),
      drawer: MainDrawer(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.menu),
      //   onPressed: openDrawer,
      // ),
    );
  }

  AppBar MainAppBar() {
    final controller = LoginController.instance;
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Welcome Admin'),
          Row(
            children: [
              IconButton(
                constraints: BoxConstraints(),
                splashRadius: 20,
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                ),
              ),
              IconButton(
                splashRadius: 20,
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(Icons.notifications),
              ),
              const CircleAvatar(
                child: Icon(Icons.person),
                maxRadius: 15,
              )
            ],
          )
        ],
      ),
      backgroundColor: AppTheme.colors.mainGreyBg,
      titleTextStyle: Get.textTheme.headline2!.copyWith(fontSize: 13),
      elevation: 0.4,
      iconTheme: IconThemeData(color: AppTheme.colors.darkerGreyTextColor),
    );
  }
}

class MainDrawer extends StatelessWidget {
  MainDrawer({
    Key? key,
  }) : super(key: key);

  final List<Map<String, dynamic>> children = [
    {
      // "view": DashboardView(),
      "label": "Dashboard",
      "icon": Icons.dashboard,
      "route": Routes.DASHBOARD,
    },
    {
      // "view": HouseView(),
      "label": "Houses",
      "icon": Icons.maps_home_work_rounded,
      "route": Routes.HOUSE
    },
    {
      // "view": UserView(),
      "label": "Users",
      "icon": Icons.people_outline_rounded,
      "route": Routes.USER
    },
    {
      // "view": AgentView(),
      "label": "House Agent",
      "icon": Icons.real_estate_agent,
      "route": Routes.AGENT
    },
  ];
  final loginProvider = LoginProvider();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 210,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            // GetBuilder(
            //   id: "drawer",
            //   builder: (controller) =>
            ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // ListTile(
                //   leading: Image.asset(
                //     Config.assets.logo,
                //     height: 30,
                //   ),
                //   trailing: IconButton(
                //     icon: const Icon(Icons.close_rounded),
                //     onPressed: closeDrawer,
                //   ),
                // ),
                // ...
                children: [
              DrawerHeader(
                  // padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  margin: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Image.asset(
                        Config.assets.logo,
                        scale: 2,
                      ),
                      Text(
                        "Find Home",
                        style: Get.textTheme.headline3!.copyWith(
                            color: AppTheme.colors.mainPurpleColor,
                            fontWeight: FontWeight.w900),
                      )
                    ],
                  )),
              for (Map<String, dynamic> item in children)
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    leading: Icon(
                      children[children.indexOf(item)]["icon"],
                      color: Get.currentRoute ==
                              children[children.indexOf(item)]["route"]
                          ? AppTheme.colors.mainPurpleColor
                          : AppTheme.colors.greySidebarTextColor,
                    ),
                    title: Text(children[children.indexOf(item)]["label"]),
                    textColor: Get.currentRoute ==
                            children[children.indexOf(item)]["route"]
                        ? AppTheme.colors.mainPurpleColor
                        : AppTheme.colors.greySidebarTextColor,
                    // selectedColor: AppTheme.colors.mainPurpleColor,
                    tileColor: Get.currentRoute ==
                            children[children.indexOf(item)]["route"]
                        ? AppTheme.colors.mainLightPurpleColor.withOpacity(0.15)
                        : null,
                    // selected: index.value ==
                    //     children.indexOf(item),
                    onTap: () {
                      Get.back();
                      Get.offAndToNamed(
                          children[children.indexOf(item)]["route"]);
                    },
                  ),
                ),
              // ignore: prefer_const_constructors
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  leading: Icon(
                    Icons.logout_rounded,
                    color:
                        //  Get.currentRoute ==
                        //         children[children.indexOf(item)]["route"]
                        //     ? AppTheme.colors.mainPurpleColor
                        //     :
                        AppTheme.colors.greySidebarTextColor,
                  ),
                  title: Text("Logout"),
                  textColor: AppTheme.colors.greySidebarTextColor,
                  onTap: () {
                    loginProvider.logOut();
                  },
                ),
              )
            ]
                // ],
                ),
        // ),
      ),
      // ),
    );
  }
}
