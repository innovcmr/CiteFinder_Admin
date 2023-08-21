import 'package:cite_finder_admin/app/controllers/image_viewer_controller.dart';
import 'package:cite_finder_admin/app/data/models/agent_request.dart';
import 'package:cite_finder_admin/app/modules/image_viewer/image_viewer.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/user_model.dart';
import '../controllers/agent_controller.dart';

class AgentView extends GetView<AgentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Agent Requests'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<AgentRequest>>(
            stream: controller.agentRequestStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('There are no requests for now'),
                );
              }

              final requests = snapshot.data!;

              return ListView.builder(
                  itemCount: requests.length + 1,
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
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 5,
                                child: Text("Full Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 2,
                                child: Text("Town",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 2,
                                child: Text("ID Pictures",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 3,
                                child: Text("Phone Number",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 2,
                                child: Text("Status",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 3,
                                child: Text("Date",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      );
                    }

                    final request = requests[index - 1];
                    return Card(
                      child: ListTile(
                        focusColor: Colors.transparent,
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Request'),
                                  content: const Text(
                                      'Are you sure you want to delete this request?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          controller
                                              .deleteRequest(request.record!);
                                          Get.back();
                                        },
                                        child: const Text('Delete'))
                                  ],
                                );
                              });
                        },
                        title: Row(
                          children: [
                            Expanded(flex: 1, child: Text(index.toString())),
                            Expanded(flex: 5, child: Text(request.fullName)),
                            Expanded(flex: 2, child: Text(request.city)),
                            Expanded(
                                flex: 2,
                                child: InkWell(
                                    onTap: () {
                                      Get.put(ImageViewerController());

                                      Get.dialog(ImageViewWidget(
                                        imageUrl: request.idFront,
                                        heroTag: request.id!,
                                        galleryMode: true,
                                        galleryItems: [
                                          request.idFront,
                                          request.idBack,
                                          request.idUser
                                        ],
                                      ));
                                    },
                                    child: Text(
                                      "View Images",
                                      style: TextStyle(
                                          color:
                                              AppTheme.colors.mainPurpleColor),
                                    ))),
                            Expanded(flex: 3, child: Text(request.phoneNumber)),
                            Expanded(
                              flex: 2,
                              child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                icon: const Icon(Icons.expand_more_outlined),
                                isExpanded: true,
                                iconSize: 30,
                                value: request.status,
                                items: ["Pending", "Approved", "Rejected"]
                                    .map<DropdownMenuItem<String>>(
                                        (String status) =>
                                            DropdownMenuItem<String>(
                                                value: status,
                                                child: Text(status)))
                                    .toList(),
                                onChanged: (val) {
                                  if (val == null || val == request.status) {
                                    return;
                                  }

                                  controller.updateRequest(request.record!,
                                      {Config.firebaseKeys.status: val});
                                },
                              ),
                              // Text(request.status)
                            ),
                            Expanded(
                                flex: 3,
                                child: Text(request.dateAdded
                                    .visualFormat(showTime: true)))
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
