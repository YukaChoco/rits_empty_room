import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingController = StateNotifierProvider<Loading, bool>((ref) {
  return Loading(ref);
});

class Loading extends StateNotifier<bool> {
  Loading(this.ref) : super(true);

  final Ref ref;

  void updateLoading(bool newState) {
    state = newState;
  }
}
