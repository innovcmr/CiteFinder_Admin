// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:cite_finder_admin/app/components/ImageWidget.dart';
import 'package:cite_finder_admin/app/components/SmallImageWidget.dart';
import 'package:cite_finder_admin/app/components/controllers/crud_controller.dart';
import 'package:cite_finder_admin/app/components/crudComponentWidget.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/modules/home/views/home_view.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:cite_finder_admin/app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      appBar: HomeView().MainAppBar(),
      drawer: MainDrawer(),
      backgroundColor: AppTheme.colors.mainGreyBg,
      body: CRUD(
        moduleName: "users",
        searchController: controller.searchController,
        selectedTileIndexController: controller.selectedUserIndex,
        canEdit: false,
        canDelete: false,
        canApprove: true,
        createView: CreateEditView(
          mode: "create",
        ),
        seeView: CreateEditView(
          mode: "view",
        ),
        approveView: CreateEditView(
          mode: "approve",
        ),
      ),
    );
  }
}

class CreateEditView extends GetView<UserController> {
  CreateEditView({Key? key, this.mode = "create"}) : super(key: key);
  final box = GetStorage();
  final String mode;
  User? moduleItem;
  final controller = Get.put(UserController.to);

  @override
  Widget build(BuildContext context) {
    if (box.read(Config.keys.selectedUser) != null && mode != "create") {
      moduleItem = User.fromJson(box.read(Config.keys.selectedUser), "map");
      if (mode == "approve") {
        // final crudController = Get.put(CrudController.to);
        controller.chosenKYC = controller.kycRequests
            .firstWhere((element) => element.user == moduleItem!.record);
      }
    }
    log(moduleItem.toString());
    return Obx(
      (() =>
          //  Scaffold(
          // body:
          // SafeArea(
          //   child:
          FractionallySizedBox(
            alignment: Alignment.center,
            widthFactor: 0.9,
            heightFactor: 0.9,
            child: GestureDetector(
              onTap: () {
                Get.focusScope?.unfocus();
              },
              child: Card(
                child: Form(
                  key: controller.getFormKey(),
                  autovalidateMode: controller.autoValidate.value
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.people_outline_rounded,
                                  color: AppTheme.colors.mainPurpleColor,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),

                                Text(
                                  mode == "create"
                                      ? "New Users"
                                      : mode == "edit"
                                          ? "Edit User"
                                          : mode == "approve"
                                              ? "Approve User(KYC)"
                                              : "View User",

                                  style: Get.textTheme.headline2!.copyWith(
                                      color: AppTheme.colors.mainPurpleColor),
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: IconButton(
                                  splashRadius: 30,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.close)),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            // fullName textfield
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue:
                                    mode != "view" && mode != "approve"
                                        ? null
                                        : moduleItem!.fullName,
                                enabled: mode != "view" && mode != "approve",
                                controller: mode == "view" || mode == "approve"

                                    ? null
                                    : controller.fullNameController,
                                focusNode: controller.fullNameFocusNode,
                                validator: Validator.isRequired,
                                decoration: InputDecoration(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    // maxHeight: 40,
                                  ),
                                  focusColor:
                                      AppTheme.colors.mainLightPurpleColor,
                                  prefixIcon: const Icon(Icons.person),
                                  labelText: "Full Name",
                                ),
                              ),
                            ),
                            // EMail TextField
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue:
                                    mode != "view" && mode != "approve"
                                        ? null
                                        : moduleItem!.email,
                                enabled: mode != "view" && mode != "approve",
                                controller: mode == "view" || mode == "approve"
                                    ? null
                                    : controller.emailController,
                                focusNode: controller.emailFocusNode,
                                validator: Validator.email,
                                decoration: InputDecoration(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    // maxHeight: 40,
                                  ),
                                  focusColor:
                                      AppTheme.colors.mainLightPurpleColor,
                                  prefixIcon: const Icon(Icons.message),
                                  labelText: "Email",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue:
                                    mode != "view" && mode != "approve"
                                        ? null
                                        : moduleItem!.phoneNumber,
                                enabled: mode != "view" && mode != "approve",
                                controller: mode == "view" || mode == "approve"

                                    ? null
                                    : controller.phoneNumberController,
                                focusNode: controller.phoneNumberFocusNode,
                                validator: Validator.phoneNumberOptional,
                                decoration: InputDecoration(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    // maxHeight: 40,
                                  ),
                                  focusColor:
                                      AppTheme.colors.mainLightPurpleColor,
                                  prefixIcon: const Icon(Icons.phone),
                                  labelText: "Phone Number",
                                  hintText: "Enter Phone Number(Optional)",
                                ),
                              ),
                            ),
                            // role form field
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: DropdownButtonFormField(
                                  focusNode: controller.userRoleFocusNode,
                                  value: mode == "view" || mode == "approve"

                                      ? moduleItem!.role
                                      : controller.selectedUserRole.value
                                          .toLowerCase(),
                                  hint: Text(
                                    'User Role',
                                    style: Get.textTheme.bodyMedium!
                                        .copyWith(color: Colors.grey[400]),
                                  ),
                                  decoration: const InputDecoration(
                                    constraints: BoxConstraints(
                                      maxWidth: 300,
                                      // maxHeight: 40,
                                    ),
                                    labelText: "User Role",
                                    hintText: "Select User Role",
                                  ),
                                  validator: Validator.isRequired,
                                  onChanged: ((String? newValue) {
                                    controller.selectedUserRole(newValue);
                                  }),
                                  items: [
                                    for (var role in [
                                      "",
                                      ...Config.firebaseKeys.userRole
                                    ])
                                      DropdownMenuItem(
                                        value: role,
                                        child: Text(
                                          role.capitalizeFirst!,
                                          style: Get.textTheme.headline4!
                                              .copyWith(color: Colors.black),
                                        ),
                                      ),
                                  ]),
                            ),
                            if (mode == "create")
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  initialValue:
                                      mode != "view" && mode != "approve"
                                          ? null
                                          : moduleItem!.email,
                                  enabled: mode != "view" && mode != "approve",
                                  controller:
                                      mode == "view" || mode == "approve"
                                          ? null
                                          : controller.passwordController,

                                  focusNode: controller.passwordFocusNode,
                                  obscureText: controller.obscurePassword.value,
                                  validator: Validator.isRequired,
                                  decoration: InputDecoration(
                                    constraints: const BoxConstraints(
                                      maxWidth: 300,
                                      // maxHeight: 40,
                                    ),
                                    labelText: "Password",
                                    helperText:
                                        "Password must be more than 6 letters and must be different from both email and username",
                                    helperMaxLines: 3,
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        controller.obscurePassword.value =
                                            !controller.obscurePassword.value;
                                      },
                                      child: Icon(
                                          controller.obscurePassword.value
                                              ? FontAwesomeIcons.eye
                                              : FontAwesomeIcons.eyeSlash,
                                          size: 18),
                                    ),
                                  ),
                                ),
                              ),
                            if (mode == "create")
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  initialValue:

                                      mode != "view" && mode != "approve"
                                          ? null
                                          : moduleItem!.email,
                                  enabled: mode != "view" && mode != "approve",
                                  controller:
                                      mode == "view" || mode == "approve"
                                          ? null
                                          : controller
                                              .passwordConfirmationController,

                                  focusNode:
                                      controller.passwordConfirmFocusNode,
                                  obscureText: controller.obscurePassword.value,
                                  validator: (value) =>
                                      controller.validatePasswords(value, true),
                                  decoration: InputDecoration(
                                    constraints: const BoxConstraints(
                                      maxWidth: 300,
                                      // maxHeight: 40,
                                    ),
                                    labelText: "Confirm Password",
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        controller.obscurePassword.value =
                                            !controller.obscurePassword.value;
                                      },
                                      child: Icon(
                                          controller.obscurePassword.value
                                              ? FontAwesomeIcons.eye
                                              : FontAwesomeIcons.eyeSlash,
                                          size: 18),
                                    ),
                                  ),
                                ),
                              ),
                            // Extra attributes not in create or editform
                            if (mode == "view" || mode == "approve")

                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.location.toString(),
                                  labelText: "Location",
                                  icondata: Icons.location_on),
                            if (mode == "view" || mode == "approve")

                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.dateAdded.toString(),
                                  labelText: "Date added",
                                  icondata: Icons.calendar_month_rounded),
                            if (mode == "view" || mode == "approve")

                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.isVerified.toString(),
                                  labelText: "Is Verified",
                                  icondata: Icons.verified),
                            if (mode == "view" || mode == "approve")

                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.isGoogleUser.toString(),
                                  labelText: "Is Google user",
                                  icondata: Icons.circle),

                            if (mode == "view" || mode == "approve")

                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.isFacebookUser.toString(),
                                  labelText: "Is Facebook user",
                                  icondata: Icons.facebook),
                          ],
                        ),
                        if (mode == "approve")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "KYC Approval ",
                                textDirection: TextDirection.ltr,
                                style: Get.textTheme.headline3!.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Wrap(
                                // alignment: WrapAlignment.spaceBetween,
                                direction: Axis.horizontal,
                                children: [
                                  KYCImageFields(
                                    imgpth: controller.chosenKYC!.idUser!,
                                    label: "User Holding Id",
                                  ),
                                  KYCImageFields(
                                    imgpth: controller.chosenKYC!.idFront!,
                                    label: "Id Front",
                                  ),
                                  KYCImageFields(
                                    imgpth: controller.chosenKYC!.idBack!,
                                    label: "Id Back",
                                  ),
                                ],
                              )
                            ],
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (mode != "view" && mode != "approve")

                          Center(
                            // widthFactor: 0.5,
                            child: ElevatedButton(
                              onPressed: controller.createNewUser,
                              child: const Text('Create User'),
                            ),
                          ),

                        if (mode == "approve")
                          Center(
                            // widthFactor: 0.5,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Confirm Delete",
                                  middleText:
                                      "Are you really sure you want to Approve this User  \n This action Cannot be undone",
                                  buttonColor: Colors.blueAccent,
                                  onCancel: () => Get.back(),
                                  onConfirm: () async {
                                    Get.showLoader();
                                    await controller.approveKYC(moduleItem!.id);
                                  },
                                );
                              },
                              child: const Text('Approve Landlord'),
                            ),
                          ),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
      // ),

      ),
    );
  }

  Column KYCImageFields({required String imgpth, required String label}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SmallImageWidget(imageUrl: imgpth),
        ),
      ],
    );
  }

  Padding customTextFieldFunction({
    required String moduleAttribute,
    required String labelText,
    required IconData icondata,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue:
            mode != "view" && mode != "approve" ? null : moduleAttribute,
        enabled: mode != "view" && mode != "approve",
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            maxWidth: 300,
            // maxHeight: 40,
          ),
          focusColor: AppTheme.colors.mainLightPurpleColor,
          labelText: labelText,
          prefixIcon: Icon(icondata),
        ),
      ),
    );
  }
}
