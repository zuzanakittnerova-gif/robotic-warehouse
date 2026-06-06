import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';

class AiInsightPanel extends StatelessWidget {
  final GameController game;

  const AiInsightPanel({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.psychology),
            const SizedBox(width: 10),
        Expanded(
          child: Text(
            game.aiGeneratedInsight,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 13),
          ),
        ),
          ],
        ),
      ),
    );
  }
}