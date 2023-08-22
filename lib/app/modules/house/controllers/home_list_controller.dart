import 'package:cite_finder_admin/app/data/models/home.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:typesense/typesense.dart' as ts;

import '../../../data/models/user.dart';
import '../../../utils/new_utils.dart';

class HomeListController extends GetxController {
  HomeListController() : super() {
    searchClient = ts.Client(config);
  }

  static HomeListController get to => Get.find();

  final config = ts.Configuration(
    // Api key
    "bmMUgpw8Uqf7QMCtJp6CayxNF4a6xUHe",
    nodes: {
      ts.Node.withUri(
        Uri(
          scheme: 'https',
          host: "r6qkamspgd8wy0cnp-1.a1.typesense.net",
          port: 443,
        ),
      ),
    },
    numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
    connectionTimeout: const Duration(seconds: 10),
  );

  late ts.Client searchClient;
  RxString homeTypeFilter = Config.firebaseKeys.availableAccomodations[0].obs;
  RxString selectedLocation = "All".obs;
  RxString selectedStatus = "All".obs;

  TextEditingController searchController = TextEditingController();

  RxBool showScrollToTop = false.obs;
  RxBool isSearching = false.obs;
  Debouncer debouncer = Debouncer(milliseconds: 500);
  ScrollController scrollController = ScrollController();

  RxList<Home> homes = <Home>[].obs;

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

    searchHomes();
  }

  void selectHomeType(String val) {
    homeTypeFilter.value = val;
    searchHomes();
  }

  void selectHomeLocation(String val) {
    selectedLocation.value = val;
    searchHomes();
  }

  void selectHomeStatus(String val) {
    selectedStatus.value = val;
    searchHomes();
  }

  String buildFilterString() {
    String filterString = "";
    if (homeTypeFilter.value.isNotEmpty && homeTypeFilter.value != "ALL") {
      filterString += "type:=" + homeTypeFilter.value;
    }

    if (selectedLocation.value.isNotEmpty && selectedLocation.value != "All") {
      filterString +=
          "${filterString.isNotEmpty ? ' && ' : ''}location.city:=" +
              selectedLocation.value;
    }

    if (selectedStatus.value != "All") {
      filterString +=
          "${filterString.isNotEmpty ? ' && ' : ''}isApproved:=${selectedStatus.value == 'Approved' ? 'true' : 'false'}";
    }

    return filterString;
  }

  Future<void> searchHomes() async {
    debouncer.run(() async {
      final searchParams = {
        'q': searchController.text.trim(),
        'query_by': 'name,description,location.quarter',
        'per_page': '250',
        'filter_by': buildFilterString(),
        'page': '1',
        'sort_by': 'dateAdded:desc'
      };
      isSearching.value = true;
      try {
        final results = await searchClient
            .collection("homes")
            .documents
            .search(searchParams);

        List<dynamic> docIds =
            results["hits"].map((hit) => hit["document"]["id"]).toList();

        List<Future<Home>> homeFutures =
            docIds.map((id) => Home.getHomeFromFirestore(id)).toList();

        List<Home> res = await Future.wait(homeFutures);

        homes.value = res;
      } on Exception catch (e) {
        print(e);
        Fluttertoast.showToast(msg: "An error occured while searching");
      }

      isSearching.value = false;
    });
  }

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future<void> updateApprovedStatus(Home home, bool newVal) async {
    runAsyncFunction(() async {
      try {
        home.record.update({Config.firebaseKeys.isApproved: newVal});
        Fluttertoast.showToast(msg: "Home status updated successfully");
        searchHomes();
      } catch (e) {
        Fluttertoast.showToast(msg: "An error occured");
      }
    });
  }

  Stream<List<AppUser>> getAgentsList() {
    final stream = queryCollection(
        FirebaseFirestore.instance.collection(Config.firebaseKeys.users),
        queryBuilder: (users) {
      return users.where(Config.firebaseKeys.role,
          isEqualTo: Config.firebaseKeys.agent);
    }, objectBuilder: (map) {
      return AppUser.fromMap(map);
    });

    // final agents = await stream.first;

    return stream;
  }

  Future<void> setAgent(
      DocumentReference<Map<String, dynamic>> homeRef, String agentId) async {
    final agentRef = FirebaseFirestore.instance
        .collection(Config.firebaseKeys.users)
        .doc(agentId);
    runAsyncFunction(() async {
      try {
        await homeRef.update({Config.firebaseKeys.agent: agentRef});
        Fluttertoast.showToast(msg: "Agent updated successfully");
      } catch (e) {
        Fluttertoast.showToast(msg: "An error occured");
      }
    });
  }

  Stream<List<AppUser>> getHomeAgent(Home house) {
    final stream = queryCollection(
        FirebaseFirestore.instance.collection(Config.firebaseKeys.users),
        singleRecord: true, queryBuilder: (users) {
      return users.where(Config.firebaseKeys.id,
          isEqualTo: house.agent?.id ?? '0');
    }, objectBuilder: (map) {
      return AppUser.fromMap(map);
    });

    return stream;
  }
}
