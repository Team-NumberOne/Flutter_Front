import 'package:hive/hive.dart';
import '../../../data/model/hive/adapter/behavior_adapter.dart';

class BehaviorRepository {
  final box = Hive.box<Behavior>('behaviorBox');

  bool hasData() => box.isNotEmpty;

  /// CREATE or UPDATE
  Future<void> saveAll(List<Behavior> list) async {
    for (var b in list) {
      await box.put(b.id, b);
    }
  }

  /// READ All
  List<Behavior> getAll() => box.values.toList();

  /// READ by ID
  Behavior? getById(int id) => box.get(id);

  /// DELETE
  Future<void> delete(int id) async {
    await box.delete(id);
  }

  /// INITIAL BULK INSERT
  Future<void> saveInitial(List<Behavior> data) async {
    for (var behavior in data) {
      await box.put(behavior.id, behavior);
    }
  }
}
