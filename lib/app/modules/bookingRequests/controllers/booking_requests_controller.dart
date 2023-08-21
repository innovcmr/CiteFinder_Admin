import 'package:cite_finder_admin/app/data/models/room_request.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BookingRequestsController extends GetxController {
  BookingRequestsController() : super();

  static BookingRequestsController get to => Get.find();

  Stream<List<RoomRequestModel>> bookingRequestsStream() {
    final collection =
        FirebaseFirestore.instance.collection(Config.firebaseKeys.roomRequests);

    final stream = queryCollection(collection, queryBuilder: (requests) {
      return requests.orderBy("dateAdded", descending: true);
    }, objectBuilder: (map) {
      return RoomRequestModel.fromMap(map);
    });

    return stream;
  }

  Future<void> updateRequest(
      DocumentReference ref, Map<String, dynamic> updateMap) async {
    try {
      await ref.update(updateMap);

      Fluttertoast.showToast(msg: "Request updated successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "An unexpected error occured");
    }
  }

  Future<void> deleteRequest(DocumentReference ref) async {
    runAsyncFunction(() async {
      try {
        await ref.delete();

        Fluttertoast.showToast(msg: "Request deleted successfully!");
      } catch (e) {
        Fluttertoast.showToast(msg: "An unexpected error occured");
      }
    });
  }
}
