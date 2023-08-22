import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final homesCollection = FirebaseFirestore.instance.collection("homes");
  final bookingsCollection =
      FirebaseFirestore.instance.collection(Config.firebaseKeys.roomRequests);
  Rx<int?> userCount = Rx(null);
  Rx<int?> agentCount = Rx(null);
  Rx<int?> houseCount = Rx(null);
  Rx<int?> bookingsCount = Rx(null);
  RxBool isLoading = false.obs;

  static DashboardController get to => Get.find();

  @override
  onInit() {
    super.onInit();
    getUserCount();
    getAgentsCount();
    getHouseCount();
    getBookingsCount();
  }

  Future<int> getUserCount() async {
    final query = await userCollection.count().get();

    userCount.value = query.count;
    return query.count;
  }

  Future<int> getAgentsCount() async {
    final query =
        await userCollection.where("role", isEqualTo: "agent").count().get();
    agentCount.value = query.count;
    return query.count;
  }

  Future<int> getHouseCount() async {
    final query = await homesCollection.count().get();
    houseCount.value = query.count;
    return query.count;
  }

  Future<int> getBookingsCount() async {
    final query = await bookingsCollection
        .where("status", whereIn: ["Pending", "Approved"])
        .count()
        .get();
    bookingsCount.value = query.count;
    return query.count;
  }

  Future<void> refreshDashboard() async {
    isLoading.value = true;

    try {
      await getUserCount();
      await getAgentsCount();
      await getHouseCount();
      await getBookingsCount();

      Fluttertoast.showToast(msg: "Dashboard refreshed successfully");
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "An unexpected error occurred");
    }

    isLoading.value = false;
  }
}
