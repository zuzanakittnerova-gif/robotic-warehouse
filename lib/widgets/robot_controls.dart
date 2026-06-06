import 'package:flutter/material.dart';
import 'arrow_button.dart';

class RobotControls extends StatelessWidget {
  final bool aiEnabled;
  final VoidCallback onToggleAi;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;
  final VoidCallback onReset;
  final VoidCallback onSelectRobotA;
  final VoidCallback onSelectRobotB;

  const RobotControls({
    super.key,
    required this.aiEnabled,
    required this.onToggleAi,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onMoveLeft,
    required this.onMoveRight,
    required this.onReset,
    required this.onSelectRobotA,
    required this.onSelectRobotB,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: onToggleAi,
          icon: Icon(aiEnabled ? Icons.pause : Icons.psychology),
          label: Text(aiEnabled ? 'Vypnúť AI režim' : 'Zapnúť AI režim'),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onSelectRobotA,
              child: const Text('Robot A'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSelectRobotB,
              child: const Text('Robot B'),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ArrowButton(icon: Icons.keyboard_arrow_up, onPressed: onMoveUp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ArrowButton(icon: Icons.keyboard_arrow_left, onPressed: onMoveLeft),
            const SizedBox(width: 12),
            ArrowButton(icon: Icons.restart_alt, onPressed: onReset),
            const SizedBox(width: 12),
            ArrowButton(icon: Icons.keyboard_arrow_right, onPressed: onMoveRight),
          ],
        ),
        ArrowButton(icon: Icons.keyboard_arrow_down, onPressed: onMoveDown),
      ],
    );
  }
}