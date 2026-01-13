import 'base_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseViewModel<S extends BaseState> extends StateNotifier<S> {
  final Ref ref;

  BaseViewModel(this.ref, S initialState) : super(initialState);

  void setLoading(bool value) {
    state = copyState(isLoading: value);
  }

  void setError(String message) {
    state = copyState(errorMessage: message);
  }

  /// 각 ViewModel에서 구현
  S copyState({
    bool? isLoading,
    String? errorMessage,
  });

  /// 공통 async 실행 헬퍼
  Future<void> run(
      Future<void> Function() action,
      ) async {
    try {
      setLoading(true);
      await action();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
