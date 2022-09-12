// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'dart:html';

import 'dart:developer';

import 'package:cite_finder_admin/app/data/providers/houseProvider.dart';
import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CRUD extends GetView {
  CRUD({
    Key? key,
    this.addBtnVisibility = true,
    this.onAdd,
    this.canEdit = true,
    this.canDelete = true,
    this.editView,
    this.seeView,
    required this.moduleName,
    required this.selectedTileIndexController,
    required this.createView,
    required this.searchController,
  }) : super(key: key);

  final String moduleName;
  final bool canEdit;
  final bool canDelete;
  bool addBtnVisibility;
  final Function()? onAdd;
  final TextEditingController searchController;
  final GetView createView;
  final GetView? editView;
  final GetView? seeView;
  Rx<bool> settingsSwitch = false.obs;
  Rxn<int> selectedTileIndexController;
  List<String> generalActions = [
    "View",
    "Edit",
    "Delete",
  ];
  int sublistEnd = 7;
  final userProvider = UserProvider();
  final houseProvider = HouseProvider();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    userProvider.onInit();
    houseProvider.onInit();
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
      Get.dialog(editView!, barrierColor: AppTheme.colors.dialogBgColor);
    }

    void createModuleItem() {
      Get.dialog(createView, barrierColor: AppTheme.colors.dialogBgColor);
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
      Get.dialog(seeView!, barrierColor: AppTheme.colors.dialogBgColor);
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

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Title and add button section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  moduleName.capitalizeFirst ?? '',
                  style: Get.textTheme.headline2!
                      .copyWith(color: AppTheme.colors.mainPurpleColor),
                ),
                if (addBtnVisibility)
                  ElevatedButton(
                    onPressed: createModuleItem,
                    child: Text(
                      "+ADD",
                      style: Get.textTheme.headline4!
                          .copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                        minimumSize: const Size(110, 40),
                        primary: AppTheme.colors.mainLightPurpleColor),
                  )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            // card section
            // Obx(
            //   () =>
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "All ${moduleName.capitalizeFirst}",
                        style: Get.textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ),
                    // SizedBox(height: 10),
                    // Searchbar section
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: TextFormField(
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  contentPadding: EdgeInsets.zero,
                                  labelText: "Search Here",
                                  isDense: true,
                                  prefixIcon: Icon(Icons.search,
                                      color: AppTheme
                                          .colors.inputPlaceholderColor),
                                ),
                                controller: searchController),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list),
                          splashRadius: 20,
                        ),

                        // // settings section
                        // settingsSwitch.value
                        //     ? TextButton(
                        //         onPressed: () {
                        //           // controller.logOut();
                        //         },
                        //         child: Card(
                        //           elevation: 2.0,
                        //           margin: EdgeInsets.zero,
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 20.0, vertical: 10.0),
                        //             child: Text("mememe"),
                        //           ),
                        //         ),
                        //       )
                        //     : SizedBox(),
                        IconButton(
                          onPressed: () {
                            settingsSwitch.value = !settingsSwitch.value;
                          },
                          icon: const Icon(Icons.more_vert),
                          splashRadius: 20,
                        ),

                        PopupMenuButton(
                            splashRadius: 20,
                            onSelected: (String val) {
                              switch (val) {
                                case "view":
                              }
                            },
                            itemBuilder: (context) {
                              return generalActions.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice.toLowerCase(),
                                  child: Text(
                                    choice,
                                    style: Get.textTheme.headline4,
                                  ),
                                );
                              }).toList();
                            })
                      ],
                    ),

                    StreamBuilder<List>(
                      stream: moduleName == "users"
                          ? userProvider.moduleStream()
                          : houseProvider.moduleStream(),
                      builder: (context, snapshot) {
                        final items = snapshot.data;
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        // if (snapshot.hasData) {
                        //   log("items>>>>>>> ${items!.first.toString()}");
                        // }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            "An error occurred while retrieving ${moduleName.capitalizeFirst}",
                            textAlign: TextAlign.center,
                          ));
                        }
                        if (snapshot.data!.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                                    "No ${moduleName.capitalizeFirst} to show.")),
                          );
                        }
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              if (items!.isNotEmpty)
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.colors.greyInputColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  // Table headers
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        for (var key in items.first
                                            .toJson()
                                            .keys
                                            .toList()
                                            .sublist(0, sublistEnd))
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Text(
                                                key.trim().isEmpty
                                                    ? "---"
                                                    : key.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: Get.textTheme.headline4!
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 60)
                                      ],
                                    ),
                                  ),
                                ),
                              // Row loop
                              for (var i in items)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: AppTheme.colors.mainGreyBg),
                                    ),
                                  ),
                                  child: ListTile(
                                    // tileColor: ,
                                    selectedTileColor: AppTheme
                                        .colors.mainLightPurpleColor
                                        .withOpacity(0.2),
                                    selected: selectedTileIndexController
                                                .value !=
                                            null
                                        ? selectedTileIndexController.value ==
                                            items.indexOf(i)
                                        : false,
                                    onTap: () {
                                      if (selectedTileIndexController.value !=
                                          null) {
                                        selectedTileIndexController(
                                            items.indexOf(i));
                                        // log("Selected ${selectedTileIndexController!.value == items.indexOf(i)}");
                                        // selectedTileIndexController!.refresh();
                                      }
                                    },
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // COlumn loop

                                        moduleName == "houses" &&
                                                i.isApproved != null &&
                                                i.isApproved == true
                                            ? const Icon(
                                                Icons.verified_outlined,
                                                size: 20,
                                                color: Colors.lightBlue,
                                              )
                                            : const SizedBox(
                                                width: 20,
                                              ),

                                        for (var j in i
                                            .toJson()
                                            .values
                                            .toList()
                                            .sublist(0, sublistEnd))
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: ListTile(
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Text(j.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: Get
                                                        .textTheme.headline4!
                                                        .copyWith(
                                                            color:
                                                                Colors.black)),
                                              ),
                                            ),
                                          ),
                                        IconButton(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          constraints: const BoxConstraints(),
                                          splashRadius: 20,
                                          icon: Icon(Icons.remove_red_eye,
                                              size: 20,
                                              color: AppTheme
                                                  .colors.mainPurpleColor),
                                          onPressed: () {
                                            if (selectedTileIndexController
                                                    .value !=
                                                null) {
                                              selectedTileIndexController(
                                                  items.indexOf(i));
                                              log("Selected ${selectedTileIndexController.value}");
                                              selectedTileIndexController
                                                  .refresh();
                                            }

                                            viewModuleItem(i);
                                          },
                                        ),

                                        if (canEdit)
                                          IconButton(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3),
                                            constraints: const BoxConstraints(),
                                            onPressed: () {
                                              if (canEdit) {
                                                editModuleItem(i);
                                              }
                                            },
                                            splashRadius: 20,
                                            icon: Icon(Icons.edit,
                                                size: 20,
                                                color: AppTheme
                                                    .colors.mainPurpleColor),
                                          ),
                                        if (canDelete)
                                          IconButton(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3),
                                            constraints: const BoxConstraints(),
                                            splashRadius: 20,
                                            icon: Icon(
                                              Icons.delete,
                                              size: 20,
                                              color:
                                                  AppTheme.colors.mainRedColor,
                                            ),
                                            onPressed: () {
                                              deleteModuleItem(i);
                                            },
                                          ),

                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.center,
                                        //   children: [

                                        //   ],
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        } // end of snapshot has data
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                                "Unknown Error. Refresh network and try again"),
                          ),
                        );
                      },
                    ),
                    // )
                  ],
                ),
              ),
            ),
            // ), //End of high end obx
          ],
        ),
      ),
    );
  }
}
