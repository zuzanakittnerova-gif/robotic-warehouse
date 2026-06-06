import 'dart:collection';

import '../models/position.dart';
import '../models/robot.dart';
import '../models/warehouse_map.dart';
import '../models/order.dart';
import '../models/package_item.dart';

class GameController {
  final WarehouseMap map = WarehouseMap();

  late Robot robot;
  late Robot robotB;

  final Position dockA = const Position(11, 11);
  final Position dockB = const Position(11, 8);

  final Position parkingA = const Position(10, 11);
  final Position parkingB = const Position(10, 9);

  int delivered = 0;
  int manualMoves = 0;
  int aiMoves = 0;
  int manualDeliveries = 0;
  int aiDeliveries = 0;
  int obstacleHits = 0;
  int chargingVisits = 0;
  int lowBatteryWarnings = 0;
  int avoidedObstacles = 0;

  bool aiModeEnabled = false;

  String selectedRobot = 'A';

  List<Position> currentAiPath = [];
  List<Position> currentAiPathB = [];
  Map<Position, int> visitCount = {};

  List<Order> orders = [];
  List<PackageItem> packages = [];

  PackageItem? robotAPackage;
  PackageItem? robotBPackage;

  String message = 'Choď po zásielku.';

  GameController() {
    reset();
  }

  void reset() {
    robot = Robot(position: const Position(1, 11));
    robotB = Robot(position: parkingB);

    delivered = 0;
    manualMoves = 0;
    aiMoves = 0;
    manualDeliveries = 0;
    aiDeliveries = 0;
    obstacleHits = 0;
    chargingVisits = 0;
    lowBatteryWarnings = 0;
    avoidedObstacles = 0;

    aiModeEnabled = false;
    currentAiPath = [];
    currentAiPathB = [];
    visitCount.clear();

    orders = [
      Order(id: '#1001'),
      Order(id: '#1002'),
      Order(id: '#1003'),
      Order(id: '#1004'),
      Order(id: '#1005'),
      Order(id: '#1006'),
      Order(id: '#1007'),
      Order(id: '#1008'),
      Order(id: '#1009'),
      Order(id: '#1010'),
    ];

    packages = [
      PackageItem(id: 'PKG-1', position: const Position(2, 8)),
      PackageItem(id: 'PKG-2', position: const Position(5, 10)),
      PackageItem(id: 'PKG-3', position: const Position(7, 1)),
    ];

    robotAPackage = null;
    robotBPackage = null;

    message = 'Hra reštartovaná. AI rozdelí balíky podľa vzdialenosti.';
  }

  void toggleAiMode() {
    aiModeEnabled = !aiModeEnabled;
    currentAiPath = [];
    currentAiPathB = [];

    message = aiModeEnabled
        ? 'AI režim zapnutý. Robot A aj Robot B si rozdeľujú balíky.'
        : 'AI režim vypnutý.';
  }

  void selectRobot(String robotName) {
    selectedRobot = robotName;
    message = 'Ručne ovládaš Robot $robotName.';
  }

  void runAiStep() {
    if (!aiModeEnabled) return;

    _assignPackagesToRobots();

    _runRobotA();
    _runRobotB();
  }

  void _assignPackagesToRobots() {
    final availablePackages =
    packages.where((p) => !p.pickedUp && !p.delivered).toList();

    if (availablePackages.isEmpty) {
      if (!robot.carryingPackage) robotAPackage = null;
      if (!robotB.carryingPackage) robotBPackage = null;
      message = 'Všetky voľné balíky sú rozobraté alebo doručené.';
      return;
    }

    if (robotAPackage != null && robotAPackage!.delivered) {
      robotAPackage = null;
    }

    if (robotBPackage != null && robotBPackage!.delivered) {
      robotBPackage = null;
    }

    if (robotAPackage == null && !robot.carryingPackage) {
      final packagesForA = availablePackages
          .where((p) => p.id != robotBPackage?.id)
          .toList();

      if (packagesForA.isNotEmpty) {
        robotAPackage = _chooseClosestPackage(
          robot.position,
          packagesForA,
        );
      }
    }

    if (robotBPackage == null && !robotB.carryingPackage) {
      final packagesForB = availablePackages
          .where((p) => p.id != robotAPackage?.id)
          .toList();

      if (packagesForB.isNotEmpty) {
        robotBPackage = _chooseClosestPackage(
          robotB.position,
          packagesForB,
        );
      }
    }
  }

  PackageItem _chooseClosestPackage(
      Position robotPosition,
      List<PackageItem> availablePackages,
      ) {
    availablePackages.sort((a, b) {
      final distanceA = _findPathFromTo(robotPosition, a.position).length;
      final distanceB = _findPathFromTo(robotPosition, b.position).length;
      return distanceA.compareTo(distanceB);
    });

    return availablePackages.first;
  }

  void _runRobotA() {
    final target = _selectTargetForRobotA();
    final path = _findPathFromTo(robot.position, target);

    currentAiPath = path;

    if (path.length < 2) return;

    if (path.length > 2) {
      avoidedObstacles++;
    }

    moveRobotTo(path[1]);
  }

  void _runRobotB() {
    if (robotB.position == dockB && !robotB.hasLowBattery) {
      robotB.moveTo(parkingB);
      return;
    }

    if (robotBPackage == null &&
        !robotB.carryingPackage &&
        robotB.position == parkingB) {
      currentAiPathB = [];
      return;
    }

    final target = _selectTargetForRobotB();
    final path = _findPathFromTo(robotB.position, target);

    currentAiPathB = path;

    if (path.length < 2) return;

    final nextPosition = path[1];

    if (nextPosition == robot.position && nextPosition != dockB) return;
    if (nextPosition == robotB.position) return;

    robotB.moveTo(nextPosition);
    visitCount[nextPosition] = (visitCount[nextPosition] ?? 0) + 1;

    _checkRobotBPosition();
  }

  Position _selectTargetForRobotA() {
    if (robot.hasLowBattery && robot.position != dockA) {
      message = 'AI: Robot A má nízku batériu, ide do dokovacej stanice.';
      return dockA;
    }

    if (robot.carryingPackage) {
      message =
      'AI: Robot A nesie ${robotAPackage?.id ?? 'balík'} na výdajný pult.';
      return map.counter;
    }

    return robotAPackage?.position ?? parkingA;
  }

  Position _selectTargetForRobotB() {
    if (robotB.hasLowBattery && robotB.position != dockB) {
      return dockB;
    }

    if (robotB.carryingPackage) {
      return map.counter;
    }

    return robotBPackage?.position ?? parkingB;
  }

  List<Position> _findPathFromTo(
      Position start,
      Position target,
      ) {
    final queue = Queue<Position>();
    final visited = <Position>{};
    final previous = <Position, Position?>{};

    queue.add(start);
    visited.add(start);
    previous[start] = null;

    const directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
    ];

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();

      if (current == target) {
        return _reconstructPath(previous, target);
      }

      for (final direction in directions) {
        final next = current.move(direction[0], direction[1]);

        if (!next.isInsideWarehouse) continue;
        if (map.isObstacle(next)) continue;
        if (visited.contains(next)) continue;

        final isDock = next == dockA || next == dockB;

        if (!isDock && next == robot.position && start != robot.position) {
          continue;
        }

        if (!isDock && next == robotB.position && start != robotB.position) {
          continue;
        }

        visited.add(next);
        previous[next] = current;
        queue.add(next);
      }
    }

    return [];
  }

  List<Position> _reconstructPath(
      Map<Position, Position?> previous,
      Position target,
      ) {
    final path = <Position>[];
    Position? current = target;

    while (current != null) {
      path.insert(0, current);
      current = previous[current];
    }

    return path;
  }

  void moveRobot(int dRow, int dCol) {
    if (selectedRobot == 'A') {
      final nextPosition = robot.position.move(dRow, dCol);
      moveRobotTo(nextPosition);
    } else {
      final nextPosition = robotB.position.move(dRow, dCol);
      moveRobotBTo(nextPosition);
    }
  }

  void moveRobotTo(Position nextPosition) {
    if (robot.isBatteryEmpty) {
      message = 'Robot A je vybitý. Musí sa dobiť.';
      return;
    }

    if (!nextPosition.isInsideWarehouse) {
      message = 'Pozor, koniec haly!';
      return;
    }

    if (map.isObstacle(nextPosition)) {
      obstacleHits++;
      message = 'Pred robotom je prekážka.';
      return;
    }

    if (nextPosition == robotB.position && nextPosition != dockA) {
      message = 'Na tomto políčku je Robot B.';
      return;
    }

    robot.moveTo(nextPosition);

    visitCount[nextPosition] = (visitCount[nextPosition] ?? 0) + 1;

    if (aiModeEnabled) {
      aiMoves++;
    } else {
      manualMoves++;
    }

    _checkRobotAPosition();
  }


  void moveRobotBTo(Position nextPosition) {
    if (robotB.isBatteryEmpty) {
      message = 'Robot B je vybitý. Musí sa dobiť.';
      return;
    }

    if (!nextPosition.isInsideWarehouse) {
      message = 'Pozor, koniec haly!';
      return;
    }

    if (map.isObstacle(nextPosition)) {
      obstacleHits++;
      message = 'Pred Robotom B je prekážka.';
      return;
    }

    if (nextPosition == robot.position && nextPosition != dockB) {
      message = 'Na tomto políčku je Robot A.';
      return;
    }

    robotB.moveTo(nextPosition);

    visitCount[nextPosition] = (visitCount[nextPosition] ?? 0) + 1;
    manualMoves++;

    _checkRobotBPosition();
  }


  void _checkRobotAPosition() {
    if (robot.position == dockA) {
      robot.charge();
      chargingVisits++;

      if (!robot.hasLowBattery) {
        robot.moveTo(parkingA);
        message = 'Robot A sa dobil a uvoľnil dokovaciu stanicu.';
      } else {
        message = 'Robot A sa dobíja.';
      }

      return;
    }

    if (!robot.carryingPackage) {
      final package = packages.where(
            (p) =>
        !p.pickedUp &&
            !p.delivered &&
            p.position == robot.position,
      );

      if (package.isNotEmpty) {
        robotAPackage = package.first;
        robot.carryingPackage = true;
        robotAPackage!.pickedUp = true;
        message = 'Robot A vyzdvihol ${robotAPackage!.id}.';
        return;
      }
    }

    if (robot.carryingPackage && robot.position == map.counter) {
      robot.carryingPackage = false;

      if (pendingOrders.isNotEmpty) {
        delivered++;
        _completeNextOrder();
      }

      robotAPackage?.delivered = true;
      robotAPackage = null;


      if (aiModeEnabled) {
        aiDeliveries++;
      } else {
        manualDeliveries++;
      }

      _generateMissingPackage();

      message = 'Robot A doručil zásielku. AI pridelí ďalší balík.';
      return;
    }

    if (robot.hasLowBattery) {
      lowBatteryWarnings++;
      message = 'Robot A má nízku batériu! Ide do dokovacej stanice.';
      return;
    }

    message = robot.carryingPackage
        ? 'Robot A nesie zásielku na výdajný pult.'
        : 'Robot A ide po pridelený balík.';
  }

  void _checkRobotBPosition() {
    if (robotB.position == dockB) {
      robotB.charge();
      chargingVisits++;

      if (!robotB.hasLowBattery) {
        robotB.moveTo(parkingB);
      }

      return;
    }

    if (!robotB.carryingPackage) {
      final package = packages.where(
            (p) =>
        !p.pickedUp &&
            !p.delivered &&
            p.position == robotB.position,
      );

      if (package.isNotEmpty) {
        robotBPackage = package.first;
        robotB.carryingPackage = true;
        robotBPackage!.pickedUp = true;
        message = 'Robot B vyzdvihol ${robotBPackage!.id}.';
        return;
      }
    }

    if (robotB.carryingPackage && robotB.position == map.counter) {
      robotB.carryingPackage = false;

      if (pendingOrders.isNotEmpty) {
        delivered++;
        aiDeliveries++;
        _completeNextOrder();
      }

      robotBPackage?.delivered = true;
      robotBPackage = null;

      _generateMissingPackage();

      message = 'Robot B doručil zásielku.';

      return;
    }
  }

  void _completeNextOrder() {
    try {
      orders.firstWhere((order) => !order.completed).completed = true;
    } catch (_) {}
  }

  void _generateMissingPackage() {
    if (pendingOrders.isEmpty) {
      packages.removeWhere((package) => !package.delivered);
      robotAPackage = null;
      robotBPackage = null;
      return;
    }

    final activePackages = packages
        .where((package) => !package.delivered)
        .toList();

    final maxActivePackages =
    pendingOrders.length < 3 ? pendingOrders.length : 3;

    if (activePackages.length >= maxActivePackages) return;

    final newIndex = packages.length + 1;

    final newPackage = PackageItem(
      id: 'PKG-$newIndex',
      position: _generatePackagePosition(),
    );

    packages.add(newPackage);

    if (!robot.carryingPackage) {
      robotAPackage = null;
    }

    if (!robotB.carryingPackage) {
      robotBPackage = null;
    }
  }

  Position _generatePackagePosition() {
    final candidatePositions = [
      const Position(2, 8),
      const Position(7, 1),
      const Position(5, 10),
      const Position(9, 2),
      const Position(3, 4),
      const Position(8, 7),
    ];

    for (final position in candidatePositions) {
      final occupied = map.isObstacle(position) ||
          position == robot.position ||
          position == robotB.position ||
          position == map.counter ||
          position == dockA ||
          position == dockB ||
          position == parkingA ||
          position == parkingB ||
          packages.any(
                (package) => !package.delivered && package.position == position,
          );

      if (!occupied) {
        return position;
      }
    }

    return const Position(1, 1);
  }

  int get totalMoves => manualMoves + aiMoves;

  double get avgStepsPerDelivery {
    if (delivered == 0) return 0;
    return totalMoves / delivered;
  }

  double get manualMovesPerDelivery {
    if (manualDeliveries == 0) return 0;
    return manualMoves / manualDeliveries;
  }

  double get aiMovesPerDelivery {
    if (aiDeliveries == 0) return 0;
    return aiMoves / aiDeliveries;
  }

  String get activeOrderId {
    try {
      return orders.firstWhere((order) => !order.completed).id;
    } catch (_) {
      return 'Všetko doručené';
    }
  }

  List<Order> get completedOrders =>
      orders.where((order) => order.completed).toList();

  List<Order> get pendingOrders =>
      orders.where((order) => !order.completed).toList();

  String get nextAiAction {
    if (robot.hasLowBattery || robotB.hasLowBattery) {
      return 'Go To Charger';
    }

    if (robot.carryingPackage || robotB.carryingPackage) {
      return 'Deliver Order';
    }

    return 'Pickup Package';
  }

  String get aiGeneratedInsight {
    return '''
AI Decision
Fleet: Robot A + Robot B
Order: $activeOrderId
Robot A target: ${robotAPackage?.id ?? 'waiting'}
Robot B target: ${robotBPackage?.id ?? 'waiting'}
Action: $nextAiAction
''';
  }
}