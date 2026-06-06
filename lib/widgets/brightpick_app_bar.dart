import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';

class BrightPickAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final GameController game;

  const BrightPickAppBar({
    super.key,
    required this.game,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'BrightPick Fleet Simulator',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }
}