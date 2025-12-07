import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repository/local/behavior_repository.dart';
import 'action_tip_state.dart';
import 'package:daepiro/data/model/local_db/behavior_tip/behavior_adapter.dart' as hive;
import 'package:daepiro/data/model/response/information/behavior_list_response.dart' as api;


final actionTipStateNotifierProvider = StateNotifierProvider<ActionTipViewModel, ActionTipState>((ref) {
  return ActionTipViewModel(ref);
});

class ActionTipViewModel extends StateNotifier<ActionTipState> {
  final StateNotifierProviderRef<ActionTipViewModel, ActionTipState> ref;
  ActionTipViewModel(this.ref) : super(ActionTipState()) {
    _loadBehaviorListFromLocalDB();
  }

  Future<void> _loadBehaviorListFromLocalDB() async {
    state = state.copyWith(isLoading: true);

    try {
      final repo = BehaviorRepository();
      final list = repo.getAll();

      final emergencyList = list.where((e) => e.name == "emergency").toList();
      final commonList = list.where((e) => e.name == "common").toList();

      state = state.copyWith(
        emergencyBehaviorList: _convertHiveListToApiList(emergencyList),
        commonBehaviorList: _convertHiveListToApiList(commonList),
        isLoading: false,
      );
    } catch (e) {
      print("Hive DB 불러오기 실패: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  List<api.Behavior> _convertHiveListToApiList(List<hive.Behavior> hiveList) {
    return hiveList.map((hiveBehavior) {
      return api.Behavior(
        id: hiveBehavior.id,
        name: hiveBehavior.name,
        tips: hiveBehavior.tips?.map((hiveTips) {
          return api.Tips(
            filter: hiveTips.filter,
            tips: hiveTips.tips
                ?.map((item) => (item.text, item.checked)) // TipItem → tuple
                .toList(),
          );
        }).toList(),
      );
    }).toList();
  }

}