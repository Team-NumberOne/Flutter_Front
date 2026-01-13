abstract class BaseState {
  final bool isLoading;
  final String? errorMessage;

  const BaseState({
    this.isLoading = false,
    this.errorMessage,
  });
}
