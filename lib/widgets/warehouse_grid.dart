import 'package:flutter/material.dart';
import '../core/config/game_config.dart';
import '../controllers/game_controller.dart';
import '../models/position.dart';
import 'warehouse_cell.dart';

class WarehouseGrid extends StatelessWidget {
  final GameController game;

  const WarehouseGrid({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 520,
        height: 520,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: GameConfig.rows * GameConfig.cols,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: GameConfig.cols,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            final position = Position(
              index ~/ GameConfig.cols,
              index % GameConfig.cols,
            );
            return WarehouseCell(position: position, game: game);
          },
        ),
      ),
    );
  }
}