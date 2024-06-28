import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rits_empty_room/rooms.dart';
import 'package:rits_empty_room/type.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // collection:bkc, ドキュメント一覧を取得
  Future<List<Room>> getEmptyRooms(Campus campus, Weeks day, int period) async {
    if (campus == Campus.none || day == Weeks.none) {
      return [];
    }
    final campusStr = campus.toString().substring(7);
    final dayStr = day.toString().substring(6, 9);
    final docId = dayStr + period.toString();

    final doc = await _db.collection(campusStr).doc(docId).get();
    final rooms = doc.data()!['rooms'];

    // c1Rooms, c2Roomsに分類
    final c1 = c1Rooms.where((room) => rooms.contains(room)).toList();
    final c2 = c2Rooms.where((room) => rooms.contains(room)).toList();

    return [
      Room(name: 'コラーニングI', rooms: c1),
      Room(name: 'コラーニングⅡ', rooms: c2),
    ];
  }
}
