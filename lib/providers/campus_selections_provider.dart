import 'package:flutter_riverpod/flutter_riverpod.dart';

final campusSelectionController =
    StateNotifierProvider<CampusSelection, List<bool>>((ref) {
  return CampusSelection(ref);
});

class CampusSelection extends StateNotifier<List<bool>> {
  CampusSelection(this.ref) : super(List.generate(3, (index) => index == 0));

  final Ref ref;

  void updateSelection(List<bool> newSelection) {
    state = newSelection;
  }
}
