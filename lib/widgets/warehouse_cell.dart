import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../models/position.dart';

class WarehouseCell extends StatelessWidget {
  final Position position;
  final GameController game;

  const WarehouseCell({
    super.key,
    required this.position,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey.shade100;
    IconData? icon;
    String label = '';
    Color iconColor = Colors.white;

    if (game.currentAiPath.contains(position)) {
      color = Colors.lightBlue.shade100;
      icon = Icons.circle;
      iconColor = Colors.blue;
    }

    if (game.currentAiPathB.contains(position)) {
      color = Colors.cyan.shade100;
      icon = Icons.circle;
      iconColor = Colors.cyan;
    }

    if (game.map.isObstacle(position)) {
      color = Colors.blueGrey.shade700;
      icon = Icons.block;
      iconColor = Colors.white;
    }

    if (position == game.map.counter) {
      color = Colors.orange.shade300;
      icon = Icons.storefront;
      iconColor = Colors.white;
    }

    if (position == game.dockA) {
      color = Colors.green.shade300;
      icon = Icons.battery_charging_full;
      iconColor = Colors.white;
      label = 'A';
    }

    if (position == game.dockB) {
      color = Colors.lightGreen.shade300;
      icon = Icons.battery_charging_full;
      iconColor = Colors.white;
      label = 'B';
    }

    for (final package in game.packages) {
      if (!package.delivered &&
          !package.pickedUp &&
          position == package.position) {

        color = Colors.amber.shade300;
        icon = Icons.inventory_2;

        label = package.id.replaceAll('PKG-', '');

        break;
      }
    }


    if (position == game.robotB.position) {
      color = Colors.teal.shade300;
      icon = Icons.smart_toy;
      iconColor = Colors.white;
      label = 'B';
    }

    if (position == game.robot.position) {
      color = game.robot.carryingPackage
          ? Colors.purple.shade300
          : Colors.indigo.shade300;
      icon = Icons.smart_toy;
      iconColor = Colors.white;
      label = game.robot.carryingPackage ? 'A📦' : 'A';
    }

    if (position == game.robotB.position) {
      color = Colors.teal.shade300;

      icon = Icons.smart_toy;

      label = game.robotB.carryingPackage
          ? 'B📦'
          : 'B';
    }


    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 24,
                color: iconColor,
              ),
            if (label.isNotEmpty)
              Positioned(
                right: 3,
                bottom: 2,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}