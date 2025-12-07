import 'package:hive/hive.dart';
import 'tips_adapter.dart';
part 'behavior_adapter.g.dart';

@HiveType(typeId: 3)
class Behavior {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  List<Tips>? tips;

  Behavior({this.id, this.name, this.tips});
}