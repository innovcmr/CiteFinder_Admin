import 'package:cite_finder_admin/app/data/models/home.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../data/models/user.dart';
import '../../../utils/new_utils.dart';

class UsersListController extends GetxController {
  UsersListController() : super();

  static UsersListController get to => Get.find();

  ScrollController scrollController = ScrollController();

  RxString selectedUserType = "all".obs;
  TextEditingController searchController = TextEditingController();

  List<AppUser> currentUsers = [];
  final collection =
      FirebaseFirestore.instance.collection(Config.firebaseKeys.users);

  RxBool showScrollToTop = false.obs;
  RxBool isSearching = false.obs;
  Debouncer debouncer = Debouncer(milliseconds: 500);

  @override
  onInit() {
    super.onInit();

    scrollController.addListener(() {
      // if we are at the top of list , hide scroll to top button
      if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          showScrollToTop.value) {
        showScrollToTop.value = false;
        return;
      }

      // once we start scrolling down, show scroll to top button
      if (scrollController.offset >=
              scrollController.position.minScrollExtent + 40 &&
          !showScrollToTop.value) {
        showScrollToTop.value = true;
      }
    });
  }

  Stream<List<AppUser>> userListStream() {
    final stream = queryCollection(collection, queryBuilder: (users) {
      return users.orderBy("dateAdded", descending: true);
    }, objectBuilder: (map) {
      return AppUser.fromMap(map);
    });

    return stream;
  }

  Stream<List<AppUser>> userRoleStream([String role = "tenant"]) {
    final stream = queryCollection(collection, queryBuilder: (users) {
      return users
          .where(Config.firebaseKeys.role, isEqualTo: selectedUserType.value)
          .orderBy("dateAdded", descending: true);
    }, objectBuilder: (map) {
      return AppUser.fromMap(map);
    });

    return stream;
  }

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void updateList() {
    update(["users_list"]);
  }

  List<AppUser> searchAppUsers(List<AppUser> userList) {
    if (searchController.text.trim().isEmpty) {
      return userList;
    }

    final result =
        userSearch(collection: userList, query: searchController.text);

    return result;
  }

  Future<void> updateUserRole(
      DocumentReference<Map<String, dynamic>> userRef, String role) async {
    runAsyncFunction(() async {
      try {
        await userRef.update({"role": role});
        Fluttertoast.showToast(msg: "User role updated.");
      } catch (e) {
        Fluttertoast.showToast(msg: "An unexpected error occured");
      }
    });
  }

  void showLandlordHomes(AppUser lanlord) async {
    final homesCollection =
        FirebaseFirestore.instance.collection(Config.firebaseKeys.homes);
    final stream = queryCollection<Home>(homesCollection, objectBuilder: (map) {
      return Home.fromMap(map);
    }, queryBuilder: (houses) {
      return houses.where(Config.firebaseKeys.landlord,
          isEqualTo: lanlord.record);
    });

    runAsyncFunction(() async {
      try {
        final landlordHomes = (await stream.first);

        Get.dialog(AlertDialog(
            title: Text("${lanlord.fullName}'s Homes"),
            content: landlordHomes.isEmpty
                ? const Center(
                    child: Text(
                      "This Landlord has no registered homes",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < landlordHomes.length; i++)
                        ListTile(
                          leading: Text((i + 1).toString()),
                          title: Text(landlordHomes[i].name!),
                          subtitle: Text(landlordHomes[i].location!.city!),
                          onTap: () {},
                        )
                    ],
                  )));
      } on Exception catch (e) {
        Fluttertoast.showToast(msg: "Unable to fetch landlord homes");
      }
    });
  }
}
