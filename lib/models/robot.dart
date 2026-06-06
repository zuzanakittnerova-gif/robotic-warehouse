import 'dart:math';
import '../core/config/game_config.dart';
import 'position.dart';

class Robot {
  Position position;
  int battery;
  bool carryingPackage;

  Robot({
    required this.position,
    this.battery = 100,
    this.carryingPackage = false,
  });

  void moveTo(Position newPosition) {
    position = newPosition;
    battery = max(0, battery - GameConfig.moveBatteryCost);
  }

  void charge() {
    battery = 100;
  }

  bool get isBatteryEmpty => battery <= 0;
  bool get hasLowBattery => battery <= GameConfig.lowBatteryLimit;
}
