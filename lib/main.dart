import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rits_empty_room/campus_setting_page.dart';
import 'package:rits_empty_room/firebase_options.dart';
import 'package:rits_empty_room/rooms_provider.dart';
import 'package:rits_empty_room/service.dart';
import 'package:rits_empty_room/table_page.dart';
import 'package:rits_empty_room/type.dart';

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
    print('rooms: $rooms');
    var isLoading = true;
    print('isLoading: $isLoading');
    // ここでFirestoreServiceを使ってデータを取得する
    final firestoreService = FirestoreService();
    // 初回だけデータを取得する
    if (rooms.isEmpty) {
      firestoreService.getEmptyRooms(Campus.bkc, Weeks.mon, 1).then((value) {
        ref.read(roomsController.notifier).updateRooms(value);
        isLoading = false;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('空き教室一覧',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return ListTile(
                      title: Text(room.name),
                      subtitle: Row(
                        children: List.generate(
                          room.rooms.length,
                          (index) => Text(room.rooms[index]),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
