import 'package:cite_finder_admin/app/data/models/home_room_model.dart';
import 'package:cite_finder_admin/app/data/models/house_model.dart';
import 'package:cite_finder_admin/app/data/models/room_request.dart';
import 'package:cite_finder_admin/app/modules/bookingRequests/controllers/booking_requests_controller.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BookingRequestsView extends GetView<BookingRequestsController> {
  const BookingRequestsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Booking Requests'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<RoomRequestModel>>(
            stream: controller.bookingRequestsStream(),
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
                                flex: 4,
                                child: Text("Home",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 2,
                                child: Text("Type",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 1,
                                child: Text("Period Unit",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                flex: 2,
                                child: Text("Status",
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
                    String paymentPeriod = "Yearly";
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
                            Expanded(
                                flex: 4,
                                child: FutureBuilder<House>(
                                    future: House.getFromFirestore(
                                        request.home!.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text("-");
                                      }

                                      if (!snapshot.hasData) {
                                        return const Text("Loading...");
                                      }
                                      paymentPeriod =
                                          snapshot.data!.paymentPeriod ??
                                              "Yearly";
                                      return Text(snapshot.data!.name!);
                                    })),
                            Expanded(
                                flex: 2,
                                child: request.roomType == null
                                    ? const Text("-")
                                    : FutureBuilder<HomeRoom>(
                                        future: HomeRoom.getFromFirestore(
                                            request.roomType!.id),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            print(snapshot.error.toString());
                                            return const Text("-");
                                          }

                                          if (!snapshot.hasData) {
                                            return const Text("Loading...");
                                          }
                                          return Text(snapshot.data!.type!);
                                        })),
                            Expanded(
                                flex: 1,
                                child: Text(request.periodCount.toString() +
                                    " ($paymentPeriod)")),
                            Expanded(
                              flex: 2,
                              child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                icon: const Icon(Icons.expand_more_outlined),
                                isExpanded: true,
                                iconSize: 30,
                                value: request.status,
                                items: [
                                  "Pending",
                                  "Approved",
                                  "Rejected",
                                  "Paid"
                                ]
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
