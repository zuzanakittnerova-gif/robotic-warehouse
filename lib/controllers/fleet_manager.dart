import '../models/package_item.dart';
import '../models/position.dart';

class FleetManager {
  static PackageItem chooseClosestPackage({
    required Position robotPosition,
    required List<PackageItem> packages,
    required List<Position> Function(Position start, Position target) findPath,
  }) {
    final availablePackages =
    packages.where((p) => !p.pickedUp && !p.delivered).toList();

    availablePackages.sort((a, b) {
      final pathA = findPath(robotPosition, a.position).length;
      final pathB = findPath(robotPosition, b.position).length;
      return pathA.compareTo(pathB);
    });

    return availablePackages.first;
  }
}