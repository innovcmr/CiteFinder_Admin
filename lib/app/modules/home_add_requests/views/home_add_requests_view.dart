import 'package:cite_finder_admin/app/data/models/add_home_request.dart';
import 'package:cite_finder_admin/app/data/models/home_room_model.dart';
import 'package:cite_finder_admin/app/data/models/house_model.dart';
import 'package:cite_finder_admin/app/data/models/room_request.dart';
import 'package:cite_finder_admin/app/modules/bookingRequests/controllers/booking_requests_controller.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/town.dart';
import '../controllers/home_add_request_controller.dart';

class AddHomeRequestView extends GetView<HomeAddRequestController> {
  const AddHomeRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Add Requests'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<AddHomeRequest>>(
            stream: controller.homAddRequestsStream(),
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
                                child: Text("Owner Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 3,
                                child: Text("Owner Phone",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 2,
                                child: Text("Town",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 2,
                                child: Text("Quarter",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 2,
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
                        selected: false,
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
                            Expanded(flex: 5, child: Text(request.ownerName)),
                            Expanded(flex: 3, child: Text(request.ownerPhone)),
                            Expanded(
                                flex: 2,
                                child: FutureBuilder<Town>(
                                    future: Town.getTownFromFirestore(
                                        request.town.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text("-");
                                      }

                                      if (!snapshot.hasData) {
                                        return const Text("Loading...");
                                      }

                                      return Text(snapshot.data!.name!);
                                    })),
                            Expanded(flex: 2, child: Text(request.quarter)),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(request.dateAdded.visualFormat()),
                                ))
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
