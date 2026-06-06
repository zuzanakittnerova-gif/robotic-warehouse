import 'position.dart';

class WarehouseMap {
  final Position counter = const Position(0, 11);
  final Position dock = const Position(11, 11);

  final Set<Position> obstacles = {
    Position(1, 2),
    Position(1, 3),
    Position(2, 3),

    Position(3, 6),
    Position(4, 6),
    Position(5, 6),

    Position(6, 2),
    Position(6, 3),

    Position(7, 8),
    Position(8, 8),

    Position(9, 4),
    Position(10, 4),
  };

  bool isObstacle(Position position) => obstacles.contains(position);
}