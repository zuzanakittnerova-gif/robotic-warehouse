import 'dart:math';
import '../core/config/game_config.dart';
import '../models/position.dart';
import '../models/warehouse_map.dart';

class PackageManager {
  Position packagePosition;
  final Random _random = Random();

  PackageManager({required this.packagePosition});

  void generateNewPackage({
    required WarehouseMap map,
    required Position robotPosition,
  }) {
    while (true) {
      final candidate = Position(
        _random.nextInt(GameConfig.rows),
        _random.nextInt(GameConfig.cols),
      );

      final isForbidden = map.isObstacle(candidate) ||
          candidate == robotPosition ||
          candidate == map.counter ||
          candidate == map.dock;

      if (!isForbidden) {
        packagePosition = candidate;
        return;
      }
    }
  }
}
