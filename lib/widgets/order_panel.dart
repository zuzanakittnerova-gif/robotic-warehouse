import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';

class OrderPanel extends StatelessWidget {
  final GameController game;

  const OrderPanel({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            const Text(
              'Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            ...game.orders.map(
                  (o) => Text(
                '${o.completed ? "✓" : "⏳"} ${o.id}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}