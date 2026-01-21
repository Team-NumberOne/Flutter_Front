import 'package:daepiro/data/model/local_db/adapter/tip_item_adapter.dart';
import 'package:hive/hive.dart';

part 'tips_adapter.g.dart';

@HiveType(typeId: 2)
class Tips {
  @HiveField(0)
  String? filter;

  @HiveField(1)
  List<TipItem>? tips;

  Tips({this.filter, this.tips});
}