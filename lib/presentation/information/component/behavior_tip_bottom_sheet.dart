import 'package:daepiro/data/model/response/information/behavior_list_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/chip/secondary_chip.dart';
import '../../home/component/action_tip_item.dart';
import '../behavior_tip/behavior_tips_view_model.dart';

class BehaviorTipBottomSheet extends ConsumerStatefulWidget {
  final Behavior behavior;

  const BehaviorTipBottomSheet({
    super.key,
    required this.behavior,
  });

  @override
  ConsumerState<BehaviorTipBottomSheet> createState() => _BehaviorTipBottomSheetState();
}

class _BehaviorTipBottomSheetState extends ConsumerState<BehaviorTipBottomSheet> {
  int selectedDisasterTypeIdx = 0;
  late BehaviorTipsViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ref.read(behaviorTipsStateNotifierProvider.notifier);
  }

  @override
  void dispose() {
    vm.onDispose(widget.behavior.name ?? "");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(behaviorTipsStateNotifierProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      child: Container(
        width: double.infinity,
        color: DaepiroColorStyle.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        widget.behavior.name ?? "",
                        style: DaepiroTextStyle.body_1_b.copyWith(
                          color: DaepiroColorStyle.g_900,
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/icon_close.svg',
                        colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1,color: DaepiroColorStyle.g_50),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: widget.behavior.tips!.isEmpty
                  ? Column(
                    children: [
                      const SizedBox(height: 16),
                      SvgPicture.asset(
                        'assets/icons/icon_warning_large.svg',
                        width: 40,
                        height: 40,
                        colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_75, BlendMode.srcIn),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "행동요령 준비중",
                        style: DaepiroTextStyle.h6.copyWith(
                          color: DaepiroColorStyle.g_300,
                        )
                      ),
                      Text(
                        "더 많은 재난에 대처할 수 있도록\n행동요령을 준비해둘게요.",
                        style: DaepiroTextStyle.body_2_m.copyWith(
                          color: DaepiroColorStyle.g_300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16)
                    ],
                  )
                  : Column(
                      children: [
                        Row(
                          children: [
                            for (int i=0;i<widget.behavior.tips!.length;i++)
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  SecondaryChip(
                                      isSelected: selectedDisasterTypeIdx == i,
                                      text: widget.behavior.tips![i].filter ?? "",
                                      onPressed: () {
                                        setState(() {
                                          selectedDisasterTypeIdx = i;
                                        });
                                      }
                                  ),
                                ],
                              )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.behavior.tips?[selectedDisasterTypeIdx].tips?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return ActionTipItem(
                                text: widget.behavior.tips?[selectedDisasterTypeIdx].tips?[index].$1 ?? "",
                                isSelected: (viewModel.emergencyBehaviorList + viewModel.commonBehaviorList)
                                    .firstWhere((b) => b.name == widget.behavior.name, orElse: () => Behavior())
                                    .tips?[selectedDisasterTypeIdx]
                                    .tips?[index].$2 ?? false,
                                onClick: () {
                                  ref.read(behaviorTipsStateNotifierProvider.notifier).selectCheckList(
                                      widget.behavior.name ?? "",
                                      widget.behavior.tips?[selectedDisasterTypeIdx].filter ?? "",
                                      widget.behavior.tips?[selectedDisasterTypeIdx].tips?[index].$1 ?? ""
                                  );
                                },
                              );
                            }
                          ),
                        )
                      ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

