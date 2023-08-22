import 'package:cite_finder_admin/app/components/custom_search_bar.dart';
import 'package:cite_finder_admin/app/data/models/user.dart';
import 'package:cite_finder_admin/app/modules/house/controllers/home_list_controller.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/image_viewer_controller.dart';
import '../../image_viewer/image_viewer.dart';

class HomeListView extends GetView<HomeListController> {
  const HomeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Homes List"),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                            "Home type",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                                value: controller.homeTypeFilter.value,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                items: Config
                                    .firebaseKeys.availableAccomodations
                                    .map((type) => DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type.capitalizeFirst! +
                                              (type != 'ALL' ? "s" : '')),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val == null) return;

                                  controller.selectHomeType(val);
                                });
                          })
                        ],
                      ),
                    ),
                  ),
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
                            "Location",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                                value: controller.selectedLocation.value,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                items: (["All"] +
                                        Config.firebaseKeys.availableCities)
                                    .map((type) => DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type.capitalizeFirst!),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val == null) return;

                                  controller.selectHomeLocation(val);
                                });
                          })
                        ],
                      ),
                    ),
                  ),
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
                            "Status",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                                value: controller.selectedStatus.value,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                items: ["All", "Pending", "Approved"]
                                    .map((type) => DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type.capitalizeFirst!),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val == null) return;

                                  controller.selectHomeStatus(val);
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
                          const Text("Search homes",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomSearchBar(
                            controller: controller.searchController,
                            onChanged: (val) {
                              controller.searchHomes();
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              // Body here

              Obx(
                () {
                  return controller.isSearching.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.homes.isEmpty
                          ? const Center(
                              child: Text("No Homes available for now"),
                            )
                          : ListView.separated(
                              itemCount: controller.homes.length + 1,
                              shrinkWrap: true,
                              separatorBuilder: ((context, index) {
                                return const SizedBox(
                                  height: 5,
                                );
                              }),
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
                                            flex: 4,
                                            child: Text("Name",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            flex: 2,
                                            child: Text("Type",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            flex: 2,
                                            child: Text("Town",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            flex: 3,
                                            child: Text("Base Price",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            flex: 3,
                                            child: Text("Owner",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            flex: 3,
                                            child: Text("Agent",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            flex: 1,
                                            child: Text("Approved",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            flex: 2,
                                            child: Text("Date Created",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            flex: 1,
                                            child: Text("Images",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                    ),
                                  );
                                }

                                final home = controller.homes[index - 1];
                                return Card(
                                    child: ListTile(
                                  tileColor: Colors.grey[200]!,
                                  focusColor: Colors.transparent,
                                  onTap: () {},
                                  title: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            index.toString(),
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Text(
                                            "${home.name}",
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "${home.type}",
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            "${home.location?.city}",
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            "${home.basePrice}",
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: home.ownerInfo != null
                                              ? Text(
                                                  home.ownerInfo!.name,
                                                )
                                              : home.landlord != null
                                                  ? FutureBuilder<AppUser>(
                                                      future: AppUser
                                                          .getUserFromFirestore(
                                                              home.landlord!
                                                                  .id),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError) {
                                                          return const Text(
                                                              "-");
                                                        }

                                                        if (!snapshot.hasData) {
                                                          return const Text(
                                                              "Loading...");
                                                        }

                                                        return Text(
                                                            "${snapshot.data!.fullName}");
                                                      })
                                                  : const Text('-')),
                                      Expanded(
                                        flex: 3,
                                        child: StreamBuilder<List<AppUser?>>(
                                            stream:
                                                controller.getHomeAgent(home),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError ||
                                                  snapshot.connectionState ==
                                                      ConnectionState.waiting ||
                                                  !snapshot.hasData) {
                                                return const Center(
                                                    child: Text("Loading..."));
                                              }
                                              final currentAgent =
                                                  snapshot.data!;

                                              return StreamBuilder<
                                                      List<AppUser>>(
                                                  stream: controller
                                                      .getAgentsList(),
                                                  builder:
                                                      (context, asnapshot) {
                                                    if (asnapshot.hasError ||
                                                        !asnapshot.hasData) {
                                                      return const Text("-");
                                                    }

                                                    final agents =
                                                        asnapshot.data!;

                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        DropdownButtonFormField<
                                                            String>(
                                                          focusColor: Colors
                                                              .transparent,
                                                          value: currentAgent
                                                                  .isEmpty
                                                              ? null
                                                              : currentAgent
                                                                  .first!.id,
                                                          items: agents
                                                              .map((agent) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: agent.id!,
                                                              child: Text(
                                                                agent.fullName!,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (val) {
                                                            if (val != null &&
                                                                val !=
                                                                    home.agent
                                                                        ?.id) {
                                                              home.agent =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .doc(val);
                                                              controller.setAgent(
                                                                  home.record,
                                                                  val);
                                                            }
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder()),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Checkbox(
                                                value: home.isApproved,
                                                onChanged: (val) {
                                                  if (val == null) return;
                                                  controller
                                                      .updateApprovedStatus(
                                                          home, val);
                                                }),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Text(
                                              home.dateAdded!.visualFormat(),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  icon: const Icon(Icons.image),
                                                  onPressed: home.mainImage !=
                                                              null ||
                                                          home.images != null
                                                      ? () {
                                                          Get.put(
                                                              ImageViewerController());

                                                          Get.dialog(
                                                              ImageViewWidget(
                                                            imageUrl: home
                                                                    .mainImage ??
                                                                home.images![0],
                                                            heroTag: home.id!,
                                                            galleryMode: true,
                                                            galleryItems: [
                                                                  home.mainImage!,
                                                                ] +
                                                                (home.images ??
                                                                    []),
                                                          ));
                                                        }
                                                      : null)
                                            ],
                                          )),
                                    ],
                                  ),
                                ));
                              },
                            );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
