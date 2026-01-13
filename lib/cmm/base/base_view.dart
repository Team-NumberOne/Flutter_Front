import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseView<VM, S> extends ConsumerWidget {
  const BaseView({super.key});

  /// 각 View에서 반드시 제공
  StateNotifierProvider<VM, S> get provider;

  /// 실제 UI 구현부
  Widget buildView(
      BuildContext context,
      WidgetRef ref,
      S state,
      VM viewModel,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    return buildView(context, ref, state, viewModel);
  }
}
