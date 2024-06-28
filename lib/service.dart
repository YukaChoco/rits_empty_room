import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // collection:bkc, ドキュメント一覧を取得
  Future<void> getBkcList() async {
    final doc = await _db.collection("bkc").doc('mon1').get();
    debugPrint(doc.data().toString());
  }
}
