import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rits_empty_room/providers/rooms_provider.dart';
import 'package:rits_empty_room/types/type.dart';

final campusController = StateNotifierProvider<CampusSelection, Campus>((ref) {
  return CampusSelection(ref);
});

class CampusSelection extends StateNotifier<Campus> {
  CampusSelection(this.ref) : super(Campus.bkc);

  final Ref ref;

  void updateCampus(Campus newState) {
    state = newState;
  }
}
