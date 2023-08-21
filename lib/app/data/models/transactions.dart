import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class Transaction {
  String? id;
  String ref;
  String zitoRef;
  String status;
  String paymentMethod;
  double amount;
  String memo;
  String type;
  String? receipt;
  DateTime dateAdded;
  DocumentReference<Map<String, dynamic>> user;

  Transaction(
      {this.id,
      required this.ref,
      required this.zitoRef,
      required this.status,
      required this.paymentMethod,
      required this.amount,
      required this.memo,
      required this.type,
      required this.dateAdded,
      this.receipt,
      required this.user});

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
        id: map[Config.firebaseKeys.id],
        ref: map["ref"],
        zitoRef: map["zitoRef"],
        status: map[Config.firebaseKeys.status],
        paymentMethod: map[Config.firebaseKeys.paymentMethod],
        amount: (map[Config.firebaseKeys.amount] as int).toDouble(),
        memo: map["memo"],
        type: map[Config.firebaseKeys.type],
        user: map[Config.firebaseKeys.user],
        receipt: map[Config.firebaseKeys.receipt],
        dateAdded: toDate(map[Config.firebaseKeys.dateAdded])!);
  }

  toMap() {
    return {
      Config.firebaseKeys.id: id,
      "ref": ref,
      "zitoRef": zitoRef,
      "memo": memo,
      Config.firebaseKeys.status: status,
      Config.firebaseKeys.type: type,
      Config.firebaseKeys.user: user,
      Config.firebaseKeys.paymentMethod: paymentMethod,
      Config.firebaseKeys.amount: amount,
      Config.firebaseKeys.dateAdded: dateAdded
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection(Config.firebaseKeys.transactions);
  DocumentReference<Map<String, dynamic>> get record => id != null
      ? FirebaseFirestore.instance
          .collection(Config.firebaseKeys.transactions)
          .doc(id)
      : FirebaseFirestore.instance
          .collection(Config.firebaseKeys.transactions)
          .doc();

  static Future<Transaction> getTransactionFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.transactions)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return Transaction.fromMap(objectData);
    }
    throw Exception("couldNotGetData".tr);
  }

  static Future<Transaction?> update(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.transactions)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.transactions)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({
        ...fields,
        Config.firebaseKeys.id: doc.id,
      });
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return Transaction.fromMap(updatedData);
    } else {
      return null;
    }
  }

  Future<bool> delete() async {
    try {
      await record.delete();
      return true;
    } catch (err) {
      return false;
    }
  }
}
