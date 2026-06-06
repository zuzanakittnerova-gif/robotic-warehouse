import '../core/config/game_config.dart';

class Position {
  final int row;
  final int col;

  const Position(this.row, this.col);

  Position move(int dRow, int dCol) => Position(row + dRow, col + dCol);

  bool get isInsideWarehouse =>
      row >= 0 && row < GameConfig.rows && col >= 0 && col < GameConfig.cols;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Position && row == other.row && col == other.col;

  @override
  int get hashCode => Object.hash(row, col);
}