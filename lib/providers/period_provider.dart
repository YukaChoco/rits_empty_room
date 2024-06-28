import 'package:flutter_riverpod/flutter_riverpod.dart';

final periodController = StateNotifierProvider<PeriodSelection, int>((ref) {
  return PeriodSelection(ref);
});

class PeriodSelection extends StateNotifier<int> {
  PeriodSelection(this.ref) : super(1);

  final Ref ref;

  void updatePeriod(int newState) {
    if (newState < 1 || newState > 6) {
      state = 1;
    }
    state = newState;
  }
}
