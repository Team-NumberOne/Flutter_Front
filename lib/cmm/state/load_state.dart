import 'package:freezed_annotation/freezed_annotation.dart';

part 'load_state.freezed.dart';

@freezed
class LoadState with _$LoadState {
  const factory LoadState({
    @Default(false) bool isLoading,
    String? errorMessage,
    String? completeMessage,
  }) = _LoadState;

  const LoadState._();
}