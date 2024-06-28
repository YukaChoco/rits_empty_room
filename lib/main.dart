import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rits_empty_room/campus_setting_page.dart';
import 'package:rits_empty_room/firebase_options.dart';
import 'package:rits_empty_room/service.dart';
import 'package:rits_empty_room/table_page.dart';
import 'package:rits_empty_room/type.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const MyHomePage(title: 'RitsEmptyRooms'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: false,
        toolbarHeight: 72,
        iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onPrimary, size: 36),
        title: Text(
          widget.title,
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
                const Text('is Drawer visible?'),
                TextButton(
                    onPressed: () {
                      final service = FirestoreService();
                      service.getEmptyRooms(Campus.bkc, Weeks.mon, 2);
                    },
                    child: Text('hoge'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
