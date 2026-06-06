import 'position.dart';

class PackageItem {
  final String id;
  Position position;
  bool pickedUp;
  bool delivered;

  PackageItem({
    required this.id,
    required this.position,
    this.pickedUp = false,
    this.delivered = false,
  });
}