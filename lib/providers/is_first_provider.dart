import 'package:flutter_riverpod/flutter_riverpod.dart';

final isFirstController = StateNotifierProvider<IsFirst, bool>((ref) {
  return IsFirst(ref);
});

class IsFirst extends StateNotifier<bool> {
  IsFirst(this.ref) : super(true);

  final Ref ref;

  void updateIsFirst(bool newState) {
    state = newState;
  }
}
