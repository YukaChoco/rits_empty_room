// campus_setting_page.dart
// ```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          '空き教室一覧',
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
            child: Stack(
              children: [
                Text(
                  '作成中の画面です',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
