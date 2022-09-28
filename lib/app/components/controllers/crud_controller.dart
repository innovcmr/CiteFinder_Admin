import 'dart:developer';

import 'package:cite_finder_admin/app/data/models/kyc_model.dart';
import 'package:cite_finder_admin/app/data/models/landlord_model.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/data/providers/houseProvider.dart';
import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:cite_finder_admin/app/modules/user/controllers/user_controller.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:cite_finder_admin/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CrudController extends GetxController {
  final userProvider = UserProvider();
  final houseProvider = HouseProvider();
  final box = GetStorage();
  final searchBarController = TextEditingController();
  List originalList = [];
  RxList filteredModuleList = [].obs;
  List get filteredItems => filteredModuleList.value;
  // Rxbool verifyFilterOption = ;

  static CrudController get to => Get.find();
  final userController = Get.put(UserController());
  // List<KYC> kycRequests = [];
  User? currentKYCUser;
  // Rx<bool> hasKYCListener = false.obs;

  Rx<bool> settingsSwitch = false.obs;
  List<String> generalActions = [
    "View",
    "Edit",
    "Delete",
  ];
  var selectedFlt = Rxn<bool>();
  String moduleName = '';
  int sublistEnd = 10;
  RxString searchText = "".obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    userProvider.onInit();
    houseProvider.onInit();
    Map testData = {
      "id": "studio",
      "type": "studio",
      "images": [
        "public/1.jpg",
        "public/2.jpg",
      ],
      "numberAvailable": 4,
      "description": {
        "map": "heaven",
      },
      "price": 250.5
    };

    searchBarController.addListener(() {
      if (searchBarController.value.text.isNotEmpty) {
        // final RegExp pattern = RegExp(
        //   ".${searchBarController.value.text.toLowerCase()}*",
        //   caseSensitive: false,
        // );
        final pattern = searchBarController.value.text.toLowerCase();
        // var testResult = testData.values
        //     .toString()
        //     .split(RegExp(r"(,|\{|\}|\[|\]|\:)", caseSensitive: false))
        //     .join(' ');
        log("hahaha");
        // log('${testResult}');
        filteredModuleList.value = originalList.where((element) {
          // ignore: unnecessary_string_interpolations
          var test = element.toJson().values.length
              // .toLowerCase()
              // .split(RegExp(r"(,|\{|\}|\[|\]|\:)"))
              // .join('');
              // log('${test}')
              ;
          bool filter = element
              .toJson()
              .values
              .toString()
              .toLowerCase()
              .split(RegExp(r"(,|\{|\}|\[|\]|\:)"))
              .join('')
              .contains(pattern);

          if (filter) {
            printLong(test.toString());
          }
          // return searchString(pattern, filter);
          return filter;
        }).toList();
      }
      // filteredModuleList.value.forEach((element) {
      //   log(element.toJson());
      // });
      // log("${filteredItems.length}");
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  // Future<bool> hasKYCApproved(User item) async {
  //   if (kycRequests.isEmpty) {
  //     await getKycRequests();
  //   }
  //   return item.isVerified != null &&
  //       // item.isVerified == true
  //       // &&
  //       kycRequests.any((element) => element.user == item.record);
  // }

  // getKycRequests() async {
  //   kycRequests = await userProvider.getKycRequests();
  //   // currentKYCUser = await userProvider.getUser()
  // }
  resetFilters() {
    searchBarController.text = '';
  }

  updateFilter(val, String moduleName) {
    // selectedFlt = val;
    switch (moduleName) {
      case "users":
        if (val == "approved") {
          selectedFlt.value = true;
        } else {
          selectedFlt.value = false;
        }
        break;
      case "houses":
        selectedFlt.value = val;
        break;
    }
  }

  // applyFilter(String moduleName) async {
  // // selectedFlt = val;
  // switch (moduleName) {
  //   case "users":
  //     if (userController.kycRequests.isEmpty) {
  //       // await userController.getKycRequests();
  //     }

  //     filteredModuleList.value = originalList.where((element) {
  //       return userController.kycRequests
  //           .any((kycelement) => kycelement.user == element.record);
  //     }).toList();

  //     break;
  //   case "houses":
  //     filteredModuleList.value = originalList.where((element) {
  //       return element.isApproved == selectedFlt.value;
  //     }).toList();
  //     break;
  //   filteredModuleList.value = originalList.where((element) {
  //     return userController.hasKYCApproved(element);
  //   }).toList();
  // case "houses":
  // }
  // }

  void editModuleItem(i) {
    switch (moduleName) {
      case "users":
        box.write(Config.keys.selectedUser, i.toJson());
        break;
      case "houses":
        box.write(Config.keys.selectedHome, i.toJson());
        break;
      case "agents":
        box.write(Config.keys.selectedAgent, i.toJson());
        break;
    }
  }

  void createModuleItem() {
    // Get.dialog(createView, barrierColor: AppTheme.colors.dialogBgColor);
  }

  void viewModuleItem(var i) {
    switch (moduleName) {
      case "users":
        box.write(Config.keys.selectedUser, i.toJson());
        break;
      case "houses":
        box.write(Config.keys.selectedHome, i.toJson());
        break;
      case "agents":
        box.write(Config.keys.selectedAgent, i.toJson());
        break;
    }
  }

  void approveModuleItem(var i) {
    switch (moduleName) {
      case "users":
        box.write(Config.keys.selectedUser, i.toJson());
        break;
      case "houses":
        box.write(Config.keys.selectedHome, i.toJson());
        break;
      case "agents":
        box.write(Config.keys.selectedAgent, i.toJson());
        break;
    }
  }

  void deleteModuleItem(var item) {
    Get.defaultDialog(
      title: "Confirm Delete",
      middleText:
          "Are you really sure you want to delete this ${moduleName.trim().endsWith("s") ? moduleName.substring(0, moduleName.length - 1) : moduleName}  \n Warning! This action Cannot be undone",
      buttonColor: AppTheme.colors.mainRedColor,
      onCancel: () => Get.back(),
      onConfirm: () {
        String? id = item.id;
        if (id != null) {
          switch (moduleName) {
            // add cases according to modules
            case "users":
              userProvider.delete(id);
              break;
            case "houses":
              houseProvider.delete(id);
              break;
          }
        }
        Get.back();
      },
    );
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
