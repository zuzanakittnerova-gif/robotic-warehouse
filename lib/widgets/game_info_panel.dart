import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';

class GameInfoPanel extends StatelessWidget {
  final GameController game;

  const GameInfoPanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
    Text(
    'Doručené: ${game.delivered}',
      style: Theme.of(context).textTheme.titleMedium,
    ),
      ],
    ),
    const SizedBox(height: 12),
    LinearProgressIndicator(
    value: game.robot.battery / 100,
    minHeight: 10,
    borderRadius: BorderRadius.circular(20),
    ),
    const SizedBox(height: 12),
    Container(
    width: double.infinity,

      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(game.message, textAlign: TextAlign.center),
    ),
      ],
    );
  }
}