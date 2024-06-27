import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rits_empty_room/firebase_options.dart';

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
  // ドロワーの表示状態を管理する変数
  bool _isDrawerVisible = false;

  // モーダルを表示する関数
  void _showDrawer() {
    setState(() {
      _isDrawerVisible = true;
    });
  }

  // モーダルを非表示にする関数
  void _hideDrawer() {
    setState(() {
      _isDrawerVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              title: const Text('Item 1'),
              onTap: () {
                _hideDrawer();
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                _hideDrawer();
              },
            ),
            ListTile(
              title: const Text('Item 3'),
              onTap: () {
                _hideDrawer();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'is Drawer visible?',
            ),
            Text(
              '$_isDrawerVisible',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _hideDrawer,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
