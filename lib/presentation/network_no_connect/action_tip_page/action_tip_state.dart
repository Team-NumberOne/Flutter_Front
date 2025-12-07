import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:daepiro/data/model/response/information/behavior_list_response.dart';
part 'action_tip_state.freezed.dart';

@freezed
sealed class ActionTipState with _$ActionTipState {
  factory ActionTipState({
    @Default(true) bool isLoading,
    @Default([]) List<Behavior> emergencyBehaviorList,
    @Default([]) List<Behavior> commonBehaviorList,
}) = _ActionTipState;
}