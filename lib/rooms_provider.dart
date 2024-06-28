import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rits_empty_room/rooms.dart';

final roomsController = StateNotifierProvider<Rooms, List<Room>>((ref) {
  return Rooms(ref);
});

class Rooms extends StateNotifier<List<Room>> {
  Rooms(this.ref) : super([]);

  final Ref ref;

  void updateRooms(List<Room> newRooms) {
    state = newRooms;
  }
}
