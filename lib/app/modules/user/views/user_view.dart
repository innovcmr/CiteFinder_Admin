import 'dart:developer';

import 'package:cite_finder_admin/app/components/crudComponentWidget.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
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
      backgroundColor: AppTheme.colors.mainGreyBg,
      body: CRUD(
        moduleName: "users",
        searchController: controller.searchController,
        selectedTileIndexController: controller.selectedUserIndex,
        canEdit: true,
        onFilterOpen: () {
          controller.openFilter();
        },
        onSearch: (key) async {
          // List<User> userList = list as List<User>;

          final result = controller.searchUsers(key);

          return result;
        },
        createView: CreateEditView(
          mode: "create",
        ),
        editView: CreateEditView(
          mode: "edit",
        ),
        seeView: CreateEditView(
          mode: "view",
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
  @override
  Widget build(BuildContext context) {
    if (box.read(Config.keys.selectedUser) != null && mode != "create") {
      moduleItem = User.fromJson(box.read(Config.keys.selectedUser), "map");
    }

    final controller = Get.put(UserController.to);
    return Obx(
      (() => FractionallySizedBox(
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
                                initialValue: mode != "view"
                                    ? null
                                    : moduleItem!.fullName,
                                enabled: mode != "view",
                                controller: mode == "view"
                                    ? null
                                    : controller.fullNameController
                                  ?..text = moduleItem?.fullName ?? "",
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
                                    mode != "view" ? null : moduleItem!.email,
                                enabled: mode != "view",
                                controller: mode == "view"
                                    ? null
                                    : controller.emailController
                                  ?..text = moduleItem?.email ?? "",
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
                                initialValue: mode != "view"
                                    ? null
                                    : moduleItem!.phoneNumber,
                                enabled: mode != "view",
                                controller: mode == "view"
                                    ? null
                                    : controller.phoneNumberController
                                  ?..text = moduleItem?.phoneNumber ?? "",
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
                              padding: const EdgeInsets.all(8),
                              child: DropdownButtonFormField(
                                  focusNode: controller.userRoleFocusNode,
                                  value: mode != "create"
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
                                    if (mode != "create") {
                                      controller.updateUserRole(
                                          moduleItem!.record, newValue!);
                                    }
                                    controller.selectedUserRole(newValue);

                                    moduleItem!.role = newValue;
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
                                      mode != "view" ? null : moduleItem!.email,
                                  enabled: mode != "view",
                                  controller: mode == "view"
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
                                      mode != "view" ? null : moduleItem!.email,
                                  enabled: mode != "view",
                                  controller: mode == "view"
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
                            if (mode == "view")
                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.location.toString(),
                                  labelText: "Location",
                                  icondata: Icons.location_on),
                            if (mode == "view")
                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.dateAdded.toString(),
                                  labelText: "Date added",
                                  icondata: Icons.calendar_month_rounded),
                            if (mode == "view")
                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.isVerified.toString(),
                                  labelText: "Is Verified",
                                  icondata: Icons.verified),
                            if (mode == "view")
                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.isGoogleUser.toString(),
                                  labelText: "Is Google user",
                                  icondata: Icons.circle),
                            if (mode == "view")
                              customTextFieldFunction(
                                  moduleAttribute:
                                      moduleItem!.isFacebookUser.toString(),
                                  labelText: "Is Facebook user",
                                  icondata: Icons.facebook),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (mode != "view")
                          Center(
                            // widthFactor: 0.5,
                            child: ElevatedButton(
                              onPressed: mode == "edit"
                                  ? () {
                                      controller.editUser(moduleItem);
                                    }
                                  : controller.createNewUser,
                              child: Text(mode == "edit"
                                  ? "UpdateUser"
                                  : 'Create User'),
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

  Padding customTextFieldFunction({
    required String moduleAttribute,
    required String labelText,
    required IconData icondata,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: mode != "view" ? null : moduleAttribute,
        enabled: mode != "view",
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
