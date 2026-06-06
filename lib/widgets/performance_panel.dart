import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';

class PerformancePanel extends StatelessWidget {
  final GameController game;

  const PerformancePanel({
    super.key,
    required this.game,
  });

  Widget _batteryBar(String title, int battery) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title batéria: $battery %',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: battery / 100,
          minHeight: 8,
        ),
      ],
    );
  }

  String _robotStatus({
    required bool carryingPackage,
    required bool isLowBattery,
    required bool hasPackage,
  }) {
    if (isLowBattery) return 'ide sa dobiť';
    if (carryingPackage) return 'nesie balík';
    if (hasPackage) return 'ide po balík';
    return 'čaká';
  }

  @override
  Widget build(BuildContext context) {
    final robotAStatus = _robotStatus(
      carryingPackage: game.robot.carryingPackage,
      isLowBattery: game.robot.hasLowBattery,
      hasPackage: game.robotAPackage != null,
    );

    final robotBStatus = _robotStatus(
      carryingPackage: game.robotB.carryingPackage,
      isLowBattery: game.robotB.hasLowBattery,
      hasPackage: game.robotBPackage != null,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fleet Dashboard',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _batteryBar('Robot A', game.robot.battery),
            const SizedBox(height: 8),
            Text('Stav A: $robotAStatus'),
            Text('Balík A: ${game.robotAPackage?.id ?? "žiadny"}'),

            const SizedBox(height: 16),

            _batteryBar('Robot B', game.robotB.battery),
            const SizedBox(height: 8),
            Text('Stav B: $robotBStatus'),
            Text('Balík B: ${game.robotBPackage?.id ?? "žiadny"}'),

            const Divider(height: 24),

            Text('Aktívna objednávka: ${game.activeOrderId}'),
            Text('AI doručenia: ${game.aiDeliveries}'),
            Text('AI kroky: ${game.aiMoves}'),
            Text(
              'Priemer AI krokov: ${game.aiMovesPerDelivery.toStringAsFixed(1)} / doručenie',
            ),
            Text('Nabíjanie: ${game.chargingVisits}x'),
          ],
        ),
      ),
    );
  }
}