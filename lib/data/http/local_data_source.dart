import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cmm/logger.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

class LocalDataSource {
  final _logger = DaepiroLogger.instance;


  Future<Box<String>> _openBehaviorTipBox() async {
    return await Hive.openBox<String>('behaviorTipsBox');
  }

  Future<Box<String>> _openAppPolicyBix() async {
    return await Hive.openBox<String>('policy');
  }
}
