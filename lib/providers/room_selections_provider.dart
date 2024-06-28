import 'package:flutter_riverpod/flutter_riverpod.dart';

final weekSelectionController =
    StateNotifierProvider<WeekSelection, List<bool>>((ref) {
  return WeekSelection(ref);
});

class WeekSelection extends StateNotifier<List<bool>> {
  WeekSelection(this.ref) : super(List.generate(5, (index) => index == 0));

  final Ref ref;

  void updateSelection(List<bool> newSelection) {
    state = newSelection;
  }
}

final periodSelectionController =
    StateNotifierProvider<PeriodSelection, List<bool>>((ref) {
  return PeriodSelection(ref);
});

class PeriodSelection extends StateNotifier<List<bool>> {
  PeriodSelection(this.ref) : super(List.generate(6, (index) => index == 0));

  final Ref ref;

  void updateSelection(List<bool> newSelection) {
    state = newSelection;
  }
}
