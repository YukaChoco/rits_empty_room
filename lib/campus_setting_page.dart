// campus_setting_page.dart
// ```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rits_empty_room/providers/campus_provider.dart';
import 'package:rits_empty_room/providers/campus_selections_provider.dart';
import 'package:rits_empty_room/providers/rooms_provider.dart';
import 'package:rits_empty_room/types/type.dart';

class CampusSettingPage extends ConsumerWidget {
  const CampusSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const List<(Campus, String)> campusOptions = <(Campus, String)>[
      (Campus.kic, '衣笠キャンパス(KIC)'),
      (Campus.oic, '大阪いばらきキャンパス(OIC)'),
      (Campus.bkc, 'びわこ・くさつキャンパス(BKC)'),
    ];
    final campusSelection = ref.watch(campusSelectionController);

    void onSelect(int i) {
      ref.read(campusSelectionController.notifier).updateSelection(
            List<bool>.generate(campusOptions.length, (index) => index == i),
          );
      ref.read(campusController.notifier).updateCampus(campusOptions[i].$1);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: false,
        toolbarHeight: 72,
        iconTheme: const IconThemeData(
          color: Color(0xFFEDEAE8),
          size: 36,
        ),
        title: Text(
          'キャンパス設定画面',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            right: 20,
            bottom: 20,
            child: SvgPicture.asset(
              'assets/logo.svg',
              semanticsLabel: 'アプリのロゴ',
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.secondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (var i = 0; i < campusOptions.length; i++)
                  ListTile(
                    title: GestureDetector(
                        onTap: () {
                          onSelect(i);
                        },
                        child: Text(campusOptions[i].$2)),
                    leading: Radio(
                      value: campusSelection[i],
                      groupValue: true,
                      onChanged: (bool? value) {
                        onSelect(i);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
