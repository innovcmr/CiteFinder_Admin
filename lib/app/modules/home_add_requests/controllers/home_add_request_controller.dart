import 'package:cite_finder_admin/app/data/models/add_home_request.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomeAddRequestController extends GetxController {
  HomeAddRequestController() : super();

  static HomeAddRequestController get to => Get.find();

  Stream<List<AddHomeRequest>> homAddRequestsStream() {
    final collection = FirebaseFirestore.instance
        .collection(Config.firebaseKeys.addHomeRequests);

    final stream = queryCollection(collection, queryBuilder: (requests) {
      return requests.orderBy("dateAdded", descending: true);
    }, objectBuilder: (map) {
      return AddHomeRequest.fromMap(map);
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
