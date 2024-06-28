import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rits_empty_room/type.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // collection:bkc, ドキュメント一覧を取得
  Future<void> getEmptyRooms(Campus campus, Weeks day, int period) async {
    if (campus == Campus.none || day == Weeks.none) {
      return;
    }
    final campusStr = campus.toString().substring(7);
    final dayStr = day.toString().substring(6, 9);
    final docId = dayStr + period.toString();

    final doc = await _db.collection(campusStr).doc(docId).get();
    final rooms = doc.data()!['rooms'];

    debugPrint(rooms.toString());
  }
}
