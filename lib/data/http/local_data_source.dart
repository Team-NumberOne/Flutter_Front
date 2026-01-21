import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cmm/logger.dart';
import '../model/hive/adapter/behavior_adapter.dart';
import '../model/hive/adapter/tip_item_adapter.dart';
import '../model/hive/adapter/tips_adapter.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

class LocalDataSource {
  final _logger = DaepiroLogger.instance;


  Future<Box<String>> _openBehaviorTipBox() async {
    return await Hive.openBox<String>('behaviorTipsBox');
  }
}
