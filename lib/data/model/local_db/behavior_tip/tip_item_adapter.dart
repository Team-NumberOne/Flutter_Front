import 'package:hive/hive.dart';

part 'tip_item_adapter.g.dart';

@HiveType(typeId: 1)
class TipItem {
  @HiveField(0)
  String text;

  @HiveField(1)
  bool checked;

  TipItem(this.text, this.checked);
}