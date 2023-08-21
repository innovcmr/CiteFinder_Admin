// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'dart:html';

import 'dart:developer';

import 'package:cite_finder_admin/app/data/providers/houseProvider.dart';
import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:cite_finder_admin/app/modules/chats/controllers/chats_details_controller.dart';
import 'package:cite_finder_admin/app/modules/user/controllers/user_controller.dart';
import 'package:cite_finder_admin/app/routes/app_pages.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/crud_controller.dart';
import '../data/models/user_model.dart';
import '../modules/house/controllers/house_controller.dart';

class CRUD extends GetView<CRUDController> {
  CRUD({
    Key? key,
    this.addBtnVisibility = true,
    this.onAdd,
    this.canEdit = true,
    this.canDelete = true,
    this.editView,
    this.seeView,
    this.onFilterOpen,
    this.onLoadMore,
    this.fields,
    required this.onSearch,
    required this.moduleName,
    required this.selectedTileIndexController,
    required this.createView,
    required this.searchController,
  }) : super(key: key) {
    Get.put(CRUDController());
  }

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

  VoidCallback? onFilterOpen;
  VoidCallback? onLoadMore;
  Future<List<dynamic>> Function(String) onSearch;

  List<String>? fields;

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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        controller: controller.scrollController,
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
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 900, maxWidth: 1400),
              child: Card(
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
                              // width: 900,
                              child: TextFormField(
                                  onChanged: (val) async {
                                    controller.searchKey.value = val;

                                    if (val.trim().isEmpty) {
                                      controller.isSearching.value = false;
                                      return;
                                    }

                                    controller.debouncer.run(() async {
                                      controller.isSearching.value = true;

                                      controller.searchedItems = await onSearch(
                                          controller.searchKey.value);

                                      controller.updateList();
                                    });
                                  },
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
                            onPressed: onFilterOpen,
                            icon: const Icon(Icons.filter_list),
                            splashRadius: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              if (onLoadMore != null) {
                                onLoadMore!();
                              }
                              controller.limit.value += 1;
                            },
                            icon: const Icon(Icons.replay_outlined),
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

                      Obx(() {
                        return StreamBuilder<List>(
                          stream: controller.isSearching.value
                              ? null
                              : moduleName == "users"
                                  ? userProvider.moduleStream(
                                      controller.items.isNotEmpty
                                          ? controller.items.last.createdDate
                                          : null,
                                      dummy: controller.limit.value,
                                    )
                                  : houseProvider.moduleStream(
                                      controller.items.isNotEmpty
                                          ? controller.items.last.createdDate
                                          : null,
                                      dummy: controller.limit.value,
                                    ),
                          initialData: controller.isSearching.value
                              ? controller.searchedItems
                              : controller.items,
                          builder: (context, snapshot) {
                            final items = snapshot.data;
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                "An error occurred while retrieving ${moduleName.capitalizeFirst}",
                                textAlign: TextAlign.center,
                              ));
                            }
                            if (snapshot.data!.isEmpty &&
                                controller.stopLoadingMore.value == true) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                        "No ${moduleName.capitalizeFirst} to show.")),
                              );
                            }
                            if (snapshot.hasData) {
                              if (!controller.isSearching.value &&
                                  items!.isNotEmpty) {
                                controller.items.addAll(items);

                                Future.delayed(Duration.zero, () {
                                  if (items.isEmpty) {
                                    controller.stopLoadingMore.value = true;
                                  }
                                });
                              }

                              Future.delayed(Duration.zero, () {
                                controller.isLoadingMore.value = false;
                              });

                              return GetBuilder<CRUDController>(
                                  id: "items_list",
                                  builder: (context) {
                                    List<dynamic> displayItems =
                                        controller.searchKey.trim().isNotEmpty
                                            ? controller.searchedItems
                                            : controller.items;

                                    if (moduleName == "users" &&
                                        UserController.to.currentFilter.value !=
                                            'all') {
                                      displayItems = displayItems
                                          .where((el) =>
                                              el.role ==
                                              UserController
                                                  .to.currentFilter.value)
                                          .toList();
                                    }

                                    if (moduleName == "houses" &&
                                        HouseController.to.houseFilter.value !=
                                            'all') {
                                      final filter =
                                          HouseController.to.houseFilter.value;

                                      displayItems =
                                          displayItems.where((house) {
                                        return filter == 'notApproved'
                                            ? house.isApproved != true
                                            : house.isApproved == true;
                                      }).toList();
                                    }

                                    return Column(
                                      children: [
                                        if (displayItems.isNotEmpty)
                                          Container(
                                            constraints: const BoxConstraints(
                                                minWidth: 900, maxWidth: 1400),
                                            decoration: BoxDecoration(
                                              color: AppTheme
                                                  .colors.greyInputColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            // Table headers
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  for (var key in fields == null
                                                      ? (controller.items.first
                                                          .toJson()
                                                          .keys
                                                          .toList()
                                                          .toList()
                                                          .sublist(
                                                              0, sublistEnd))
                                                      : fields!)
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5.0),
                                                        child: Text(
                                                          key.trim().isEmpty
                                                              ? "---"
                                                              : key
                                                                  .toUpperCase(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Get.textTheme
                                                              .headline4!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ),
                                                  const SizedBox(width: 60)
                                                ],
                                              ),
                                            ),
                                          ),
                                        // Row loop
                                        for (var i in displayItems)
                                          Container(
                                            constraints: const BoxConstraints(
                                                minWidth: 900, maxWidth: 1400),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: AppTheme
                                                        .colors.mainGreyBg),
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
                                                  ? selectedTileIndexController
                                                          .value ==
                                                      displayItems.indexOf(i)
                                                  : false,
                                              onTap: () {
                                                if (selectedTileIndexController
                                                        .value !=
                                                    null) {
                                                  selectedTileIndexController(
                                                      displayItems.indexOf(i));
                                                  // log("Selected ${selectedTileIndexController!.value == controller.searchedItems.indexOf(i)}");
                                                  // selectedTileIndexController!.refresh();
                                                }
                                              },
                                              title: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // COlumn loop

                                                  moduleName == "houses" &&
                                                          i.isApproved !=
                                                              null &&
                                                          i.isApproved == true
                                                      ? const Icon(
                                                          Icons
                                                              .verified_outlined,
                                                          size: 20,
                                                          color:
                                                              Colors.lightBlue,
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
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: Text(
                                                              (j is Map)
                                                                  ? j["city"]
                                                                  : j
                                                                      .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: Get
                                                                  .textTheme
                                                                  .headline4!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black)),
                                                        ),
                                                      ),
                                                    ),
                                                  IconButton(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 3),
                                                    constraints:
                                                        const BoxConstraints(),
                                                    splashRadius: 20,
                                                    icon: Icon(
                                                        Icons.remove_red_eye,
                                                        size: 20,
                                                        color: AppTheme.colors
                                                            .mainPurpleColor),
                                                    onPressed: () {
                                                      if (selectedTileIndexController
                                                              .value !=
                                                          null) {
                                                        selectedTileIndexController(
                                                            displayItems
                                                                .indexOf(i));
                                                        log("Selected ${selectedTileIndexController.value}");
                                                        selectedTileIndexController
                                                            .refresh();
                                                      }

                                                      viewModuleItem(i);
                                                    },
                                                  ),

                                                  if (canEdit)
                                                    IconButton(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 3),
                                                      constraints:
                                                          const BoxConstraints(),
                                                      onPressed: () {
                                                        if (canEdit) {
                                                          editModuleItem(i);
                                                        }
                                                      },
                                                      splashRadius: 20,
                                                      icon: Icon(Icons.edit,
                                                          size: 20,
                                                          color: AppTheme.colors
                                                              .mainPurpleColor),
                                                    ),

                                                  if (moduleName == "users")
                                                    IconButton(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 3),
                                                      constraints:
                                                          const BoxConstraints(),
                                                      splashRadius: 20,
                                                      icon: Icon(
                                                        Icons.message,
                                                        size: 20,
                                                        color: AppTheme.colors
                                                            .mainPurpleColor,
                                                      ),
                                                      onPressed: () {
                                                        if (!Get.isRegistered<
                                                            ChatDetailsController>()) {
                                                          Get.put(
                                                              ChatDetailsController());
                                                        }
                                                        Get.showOverlay(
                                                            asyncFunction:
                                                                () async {
                                                              await ChatDetailsController
                                                                  .to
                                                                  .initializeChat(
                                                                      i);

                                                              Get.rootDelegate
                                                                  .toNamed(Routes
                                                                      .CHAT_DETAILS);
                                                            },
                                                            loadingWidget:
                                                                const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ));
                                                      },
                                                    ),
                                                  if (canDelete)
                                                    IconButton(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 3),
                                                      constraints:
                                                          const BoxConstraints(),
                                                      splashRadius: 20,
                                                      icon: Icon(
                                                        Icons.delete,
                                                        size: 20,
                                                        color: AppTheme.colors
                                                            .mainRedColor,
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

                                        Obx(() => controller
                                                    .isLoadingMore.value &&
                                                !controller
                                                    .stopLoadingMore.value
                                            ? const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : const SizedBox.shrink())
                                      ],
                                    );
                                  });
                            } // end of snapshot has data
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    "Unknown Error. Refresh network and try again"),
                              ),
                            );
                          },
                        );
                      }),
                      // )
                    ],
                  ),
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
