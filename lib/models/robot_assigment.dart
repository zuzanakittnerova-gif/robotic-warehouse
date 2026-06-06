import 'position.dart';
import 'package_item.dart';

class RobotAssignment {
  final String robotName;
  final PackageItem package;
  final List<Position> path;

  RobotAssignment({
    required this.robotName,
    required this.package,
    required this.path,
  });
}