import 'dart:developer';

import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/formKeys.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:get/get.dart';

class UserController extends GetxController {
  //TODO: Implement UserController

  final count = 0.obs;
  // It is necasssy to name it as ModuleItemList nd not User because this name is used in child component
  Rx<List<User>> moduleItemList = Rx<List<User>>([]);
  static UserController get to => Get.find();

  List<User> get moduleItems => moduleItemList.value;
  var createEditViewData = Rxn();
  final userProvider = UserProvider();
  final selectedUserIndex = Rxn<int>();
  // final selectedUserIndex = Rxn<int>();

  final GlobalKey<FormState> _createUserFormKey = CreateUserFormKey();

  final searchController = TextEditingController();
  final autoValidate = false.obs;
  final selectedUserRole = "".obs;
  // final selectedUserRole = Config.firebaseKeys.userRole.first.obs;
  late TextEditingController userNameController;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;

  late FocusNode userRoleFocusNode;
  late FocusNode fullNameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode phoneNumberFocusNode;

  late FocusNode locationFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode passwordConfirmFocusNode;

  late String? initialFullName;
  late String? initialEmail;
  late String? initialLocation;
  late String? initialPhoneNumber;
  RxBool obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    createEditViewData.listen((p0) {
      log("new val is $p0");
    });
    userProvider.onInit();
    //initialize text controllers
    userNameController = TextEditingController();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();

    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();

    //initialize focus nodes

    userRoleFocusNode = FocusNode();
    fullNameFocusNode = FocusNode();
    locationFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    passwordConfirmFocusNode = FocusNode();
  }

  @override
  void onReady() {
    super.onReady();
    // moduleItemList.bindStream(userProvider.moduleStream());
    // log("user count is ${moduleItems.length}");
    // log("user count is ${moduleItems.first.toString()}");
  }

  getFormKey() {
    return _createUserFormKey;
  }

  void increment() => count.value++;

  void createNewUser() async {
    Get.focusScope?.unfocus();
    if (!_createUserFormKey.currentState!.validate()) {
      autoValidate(true);
      return;
    } else {
      Get.showLoader();
      bool successful = false;
      try {
        var success = await userProvider.add(
            fullName: fullNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
            role: selectedUserRole.value,
            phoneNumber: phoneNumberController.text.trim());
        if (success) {
          clear();
          Get.snackbar("Success",
              "User successfully Created. An Email verification has been sent.",
              duration: const Duration(seconds: 6));
          Get.closeLoader();
        }
      } catch (e) {
        Get.snackbar("Error in user Creation", e.toString());
        log("Successful User Creation");
        Get.closeLoader();
      } finally {
        Get.closeLoader();
      }
    }
  }

  void clear() {
    fullNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    autoValidate(false);
  }

  String? validatePasswords(String? value, [isConfirm = false]) {
    if (value == null || GetUtils.isLengthLessThan(value, 6)) {
      return "Passwords should contain atleast 6 characters";
    } else if (GetUtils.isCaseInsensitiveContains(
        value, fullNameController.text)) {
      return "password should not be the same as name";
    } else if (GetUtils.isCaseInsensitiveContains(
        value, emailController.text)) {
      return "password should not be the same as email";
    } else if (value !=
        (!isConfirm
            ? passwordConfirmationController.text
            : passwordController.text)) {
      return "The two passwords don't match";
    } else {
      return null;
    }
  }

  @override
  void onClose() {
    clear();
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();

    userRoleFocusNode.dispose();
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmFocusNode.dispose();
    super.onClose();
  }
}
