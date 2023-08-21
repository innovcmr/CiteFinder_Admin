import 'package:cite_finder_admin/app/modules/chats/controllers/chats_controller.dart';
import 'package:cite_finder_admin/app/modules/chats/controllers/chats_details_controller.dart';
import 'package:cite_finder_admin/app/modules/chats/views/all_chats.dart';
import 'package:cite_finder_admin/app/modules/chats/views/chat_details.dart';
import 'package:get/get.dart';

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
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/user/bindings/user_binding.dart';
import '../modules/user/views/user_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

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
    GetPage(
      name: _Paths.CHATS,
      page: () => const AllChatsPage(),
      binding: BindingsBuilder(() => ChatsController()),
    ),
    GetPage(
      name: _Paths.CHAT_DETAILS,
      page: () => const ChatDetailsPage(),
      binding: BindingsBuilder(() => ChatDetailsController()),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
  ];
}
