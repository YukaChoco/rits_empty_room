import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rits_empty_room/types/type.dart';

final weekController = StateNotifierProvider<WeekSelection, Weeks>((ref) {
  return WeekSelection(ref);
});

class WeekSelection extends StateNotifier<Weeks> {
  WeekSelection(this.ref) : super(Weeks.mon);

  final Ref ref;

  void updateWeek(Weeks newState) {
    state = newState;
  }
}
