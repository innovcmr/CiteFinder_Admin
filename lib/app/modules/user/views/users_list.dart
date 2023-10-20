import 'package:cite_finder_admin/app/components/custom_search_bar.dart';
import 'package:cite_finder_admin/app/controllers/notifications_controller.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/modules/user/controllers/user_list_controller.dart';
import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user.dart';
import '../../../routes/app_pages.dart';
import '../../chats/controllers/chats_details_controller.dart';

class UserListView extends GetView<UsersListController> {
  const UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User List"),
      ),
      floatingActionButton: Obx(() {
        return InkWell(
          onTap:
              controller.showScrollToTop.value ? controller.scrollToTop : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: controller.showScrollToTop.value ? 70 : 0,
            height: controller.showScrollToTop.value ? 70 : 0,
            decoration: BoxDecoration(
                color: Get.theme.colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: kElevationToShadow[4]),
            child: Icon(Icons.arrow_upward,
                size: controller.showScrollToTop.value ? 30 : 0),
          ),
        );
      }),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "User type",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                                value: controller.selectedUserType.value,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                items: [
                                  "all",
                                  "agent",
                                  "landlord",
                                  "admin",
                                  "tenant"
                                ]
                                    .map((type) => DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type.capitalizeFirst! +
                                              (type != 'all' ? "s" : '')),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val == null) return;

                                  controller.selectedUserType.value = val;
                                  controller.updateList();
                                });
                          })
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Search Users",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomSearchBar(
                            controller: controller.searchController,
                            onChanged: (val) {
                              controller.debouncer.run(() {
                                controller.updateList();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() {
                    return controller.selectedUsers.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                      value: controller.selectedUsers.length ==
                                          controller.currentUsers.length,
                                      onChanged: (val) {
                                        if (val == true) {
                                          controller.selectedUsers.value =
                                              controller.currentUsers;
                                        } else {
                                          controller.selectedUsers.value = [];
                                        }
                                      }),
                                  const Text(
                                    "Select all",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                ]),
                          )
                        : const SizedBox.shrink();
                  }),
                  Obx(() {
                    return controller.selectedUsers.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: IconButton(
                                onPressed: () {
                                  NotificationsController.to
                                      .showNotificationForm(controller
                                          .selectedUsers
                                          .map((u) => u.id!)
                                          .toList());
                                },
                                icon: const Icon(Icons.notification_add_rounded,
                                    size: 30)),
                          )
                        : const SizedBox.shrink();
                  }),
                ],
              ),
              GetBuilder<UsersListController>(
                  id: "users_list",
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: StreamBuilder<List<AppUser>>(
                        stream: controller.selectedUserType.value == "all"
                            ? controller.userListStream()
                            : controller.userRoleStream(),
                        initialData: controller.currentUsers,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            debugPrint(snapshot.error.toString());
                            return Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Text(snapshot.error.toString()),
                            );
                          }
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              controller.currentUsers.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final List<AppUser> users =
                              controller.searchAppUsers(snapshot.data!);

                          controller.currentUsers = users;

                          Future.delayed(Duration.zero, () {
                            controller.selectedUsers.value = controller
                                .selectedUsers
                                .where((selectedUser) =>
                                    users.indexWhere(
                                        (u) => u.id == selectedUser.id) !=
                                    -1)
                                .toList();
                          });

                          return ListView.separated(
                            itemCount: users.length + 1,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return ListTile(
                                  tileColor: Colors.grey[200]!,
                                  title: const Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text("SN",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Expanded(
                                          flex: 5,
                                          child: Text("Full Name",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Email",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Phone Number",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Expanded(
                                          flex: 1,
                                          child: Text("Town",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Expanded(
                                          flex: 2,
                                          child: Text("Role",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Date Created",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Expanded(
                                          flex: 2,
                                          child: Text("Actions",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                  ),
                                );
                              }

                              final user = users[index - 1];
                              return Obx(() {
                                return Card(
                                    child: ListTile(
                                  tileColor: Colors.grey[200]!,
                                  selected: controller.isSelected(user),
                                  selectedTileColor: AppTheme
                                      .colors.mainPurpleColor
                                      .withOpacity(.3),
                                  // selectedColor: AppTheme.colors.mainPurpleColor
                                  //     .withOpacity(.5),
                                  onTap: () {
                                    print("Tap");
                                  },
                                  onLongPress: () {
                                    print("LongPress");
                                    if (!controller.isSelected(user)) {
                                      controller.selectUser(user);
                                    } else {
                                      controller.unselectUser(user);
                                    }
                                  },
                                  title: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            index.toString(),
                                          )),
                                      Expanded(
                                          flex: 5,
                                          child: Text(
                                            "${user.fullName}",
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            "${user.email}",
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            "${user.phoneNumber}",
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${user.location}",
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: DropdownButton<String>(
                                          focusColor: Colors.transparent,
                                          icon: const Icon(
                                              Icons.expand_more_outlined),
                                          isExpanded: true,
                                          iconSize: 30,
                                          value: user.role,
                                          items: [
                                            "tenant",
                                            "agent",
                                            "admin",
                                            "landlord"
                                          ]
                                              .map<DropdownMenuItem<String>>(
                                                  (String status) =>
                                                      DropdownMenuItem<String>(
                                                          value: status,
                                                          child: Text(status)))
                                              .toList(),
                                          onChanged: (val) {
                                            if (val == null ||
                                                val == user.role) {
                                              return;
                                            }

                                            controller.updateUserRole(
                                                user.record!, val);
                                          },
                                        ),
                                        // Text(request.status)
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Text(
                                              user.dateAdded!.visualFormat(),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.message),
                                                onPressed: () {
                                                  runAsyncFunction(() async {
                                                    if (!Get.isRegistered<
                                                        ChatDetailsController>()) {
                                                      Get.put(
                                                          ChatDetailsController());
                                                    }
                                                    await ChatDetailsController
                                                        .to
                                                        .initializeChat(user);

                                                    Get.rootDelegate.toNamed(
                                                        Routes.CHAT_DETAILS);
                                                  });
                                                },
                                              ),
                                              if (user.role == "landlord")
                                                IconButton(
                                                  icon: const Icon(Icons.house),
                                                  onPressed: () {
                                                    controller
                                                        .showLandlordHomes(
                                                            user);
                                                  },
                                                ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.notification_add),
                                                onPressed: () {
                                                  NotificationsController.to
                                                      .showNotificationForm(
                                                          [user.id!]);
                                                },
                                              ),
                                              Obx(() => controller
                                                      .selectedUsers.isNotEmpty
                                                  ? Checkbox(
                                                      value: controller
                                                          .isSelected(user),
                                                      onChanged: (val) {
                                                        if (val == true) {
                                                          controller
                                                              .selectUser(user);
                                                        } else {
                                                          controller
                                                              .unselectUser(
                                                                  user);
                                                        }
                                                      })
                                                  : const SizedBox.shrink())
                                            ],
                                          )),
                                    ],
                                  ),
                                ));
                              });
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 5,
                              );
                            },
                          );
                        },
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
