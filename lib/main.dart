import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rits_empty_room/campus_setting_page.dart';
import 'package:rits_empty_room/firebase_options.dart';
import 'package:rits_empty_room/providers/loading_provider.dart';
import 'package:rits_empty_room/providers/rooms_provider.dart';
import 'package:rits_empty_room/providers/selections_provider.dart';
import 'package:rits_empty_room/logics/service.dart';
import 'package:rits_empty_room/table_page.dart';
import 'package:rits_empty_room/types/type.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'RitsEmptyRooms',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF990000),
          primary: const Color(0xFF990000),
          onPrimary: const Color(0xFFEDEAE8),
          secondary: const Color(0xFFD9D9D9),
          surface: const Color(0xFFEDEAE8),
          onSurface: const Color(0xFF2A2B27),
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'RitsEmptyRooms'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomsController);
    var isLoading = ref.watch(loadingController);
    const List<(Weeks, String)> weeksOptions = <(Weeks, String)>[
      (Weeks.mon, '月'),
      (Weeks.tue, '火'),
      (Weeks.wed, '水'),
      (Weeks.thu, '木'),
      (Weeks.fri, '金'),
    ];
    final weekSelection = ref.watch(weekSelectionController);
    final periodSelection = ref.watch(periodSelectionController);

    // ここでFirestoreServiceを使ってデータを取得する
    final firestoreService = FirestoreService();
    // 初回だけデータを取得する
    if (rooms.isEmpty) {
      firestoreService.getEmptyRooms(Campus.bkc, Weeks.mon, 1).then((value) {
        ref.read(roomsController.notifier).updateRooms(value);
        ref.read(loadingController.notifier).updateLoading(false);
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: false,
        toolbarHeight: 72,
        iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onPrimary, size: 36),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                children: [
                  SvgPicture.asset('assets/logo.svg',
                      semanticsLabel: 'アプリのロゴ', width: 100, height: 100),
                  Text(
                    'RitsEmptyRooms',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('キャンパス設定画面'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CampusSettingPage(),
                  ),
                );
              },
            ),
            Divider(color: Theme.of(context).colorScheme.secondary),
            ListTile(
              title: const Text('空き教室一覧'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TablePage(),
                  ),
                );
              },
            ),
            Divider(color: Theme.of(context).colorScheme.secondary),
          ],
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
                const SizedBox(height: 30),
                const Text('空き教室一覧',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                const SizedBox(height: 20),
                // 曜日選択ボタン
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ToggleButtons(
                      isSelected: weekSelection,
                      onPressed: (int index) {
                        ref
                            .read(loadingController.notifier)
                            .updateLoading(true);
                        firestoreService
                            .getEmptyRooms(
                          Campus.bkc,
                          Weeks.values[index + 1],
                          periodSelection.indexOf(true) + 1,
                        )
                            .then((value) {
                          ref.read(roomsController.notifier).updateRooms(value);
                          ref
                              .read(loadingController.notifier)
                              .updateLoading(false);
                        });
                        ref
                            .read(weekSelectionController.notifier)
                            .updateSelection(List.generate(
                                weeksOptions.length, (i) => i == index));
                      },
                      color: Theme.of(context).colorScheme.onSurface,
                      selectedColor: Theme.of(context).colorScheme.onSurface,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                      borderColor: Theme.of(context).colorScheme.onSurface,
                      selectedBorderColor:
                          Theme.of(context).colorScheme.onSurface,
                      constraints: const BoxConstraints(
                        minWidth: 64,
                        minHeight: 28,
                      ),
                      children: weeksOptions.map((e) => Text(e.$2)).toList()),
                ),
                const SizedBox(height: 12),
                // 時限選択ボタン
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ToggleButtons(
                    isSelected: periodSelection,
                    onPressed: (int index) {
                      ref.read(loadingController.notifier).updateLoading(true);
                      firestoreService
                          .getEmptyRooms(
                              Campus.bkc,
                              Weeks.values[weekSelection.indexOf(true) + 1],
                              index + 1)
                          .then((value) {
                        ref.read(roomsController.notifier).updateRooms(value);
                        ref
                            .read(loadingController.notifier)
                            .updateLoading(false);
                      });
                      ref
                          .read(periodSelectionController.notifier)
                          .updateSelection(List.generate(
                              periodSelection.length, (i) => i == index));
                    },
                    color: Theme.of(context).colorScheme.onSurface,
                    selectedColor: Theme.of(context).colorScheme.onSurface,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(4),
                    borderColor: Theme.of(context).colorScheme.onSurface,
                    selectedBorderColor:
                        Theme.of(context).colorScheme.onSurface,
                    constraints: const BoxConstraints(
                      minWidth: 53,
                      minHeight: 28,
                    ),
                    children: List.generate(
                        6, (index) => Text((index + 1).toString())),
                  ),
                ),
                const SizedBox(height: 42),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return ListTile(
                      title: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Text(
                            room.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: room.name.length * 16,
                              height: 1,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            spacing: 8,
                            children: List.generate(
                              room.rooms.length,
                              (index) => Text(
                                room.rooms[index],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                  strokeWidth: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
