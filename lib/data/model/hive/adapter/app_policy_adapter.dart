import 'package:hive/hive.dart';

part 'app_policy_adapter.g.dart';

@HiveType(typeId: 4)
class AppPolicy {
  @HiveField(0)
  String? nickName;

  @HiveField(1)
  bool? canUseNaverMap;

  @HiveField(2)
  String? firstofflineRegion;

  @HiveField(3)
  String? secondofflineRegion;

  AppPolicy(
      {this.nickName, this.canUseNaverMap, this.firstofflineRegion, this.secondofflineRegion});
}