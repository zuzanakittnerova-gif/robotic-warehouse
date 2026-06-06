import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'pages/warehouse_game_page.dart';

class BrightPickRobotApp extends StatelessWidget {
  const BrightPickRobotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrightPick Robot',
      theme: AppTheme.lightTheme,
      home: const WarehouseGamePage(),
    );
  }
}