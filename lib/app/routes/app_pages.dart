import 'package:get/get.dart';

import '../modules/ImageViewWidget/bindings/image_view_widget_binding.dart';
import '../modules/ImageViewWidget/views/image_view_widget_view.dart';
import '../modules/agent/bindings/agent_binding.dart';
import '../modules/agent/views/agent_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/house/bindings/house_binding.dart';
import '../modules/house/views/house_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/user/bindings/user_binding.dart';
import '../modules/user/views/user_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.HOUSE,
      page: () => HouseView(),
      binding: HouseBinding(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => UserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: _Paths.AGENT,
      page: () => AgentView(),
      binding: AgentBinding(),
    ),
    // GetPage(
    //   name: _Paths.CREATEEDIT,
    //   page: () => CreateEditView(),
    // ),
    // GetPage(
    //   name: _Paths.IMAGE_VIEW_WIDGET,
    //   // page: () => ImageViewWidgetView(),
    //   binding: ImageViewWidgetBinding(),
    // ),

  ];
}
