import 'dart:ui';

import 'package:daepiro/presentation/mypage/controller/mypage_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../cmm/DaepiroTheme.dart';
import '../../const/common_disaster_list.dart';
import '../../const/emergency_disaster_list.dart';

class MypageDisasterTypeSettingScreen extends ConsumerStatefulWidget {
  @override
  MypageDisasterTypeSettingState createState() => MypageDisasterTypeSettingState();
}

class MypageDisasterTypeSettingState extends ConsumerState<MypageDisasterTypeSettingScreen> {
  Set<int> selected = Set();
  Set<int> selectedSub = Set();
  final ValueNotifier<bool> isValueChangeNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    selected.clear();
    selectedSub.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(myPageProvider.notifier).getDisasterType();
      final state = ref.watch(myPageProvider);
      for(int i=0; i<EmergencyDisasterList.length; i++) {
        if(state.disasterTypeList.contains(EmergencyDisasterList[i]['name'])) {
          setState(() {
            selected.add(i);
          });
        }
      }
      for(int i=0; i<CommonDisasterList.length; i++) {
        if(state.disasterTypeList.contains(CommonDisasterList[i]['name'])) {
         setState(() {
           selectedSub.add(i);
         });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPageProvider);
    final viewModel = ref.read(myPageProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerWidget(context, ref),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            '위급/긴급 재난',
                            style: DaepiroTextStyle.body_1_b
                                .copyWith(color: DaepiroColorStyle.g_900),
                          ),
                          Spacer(),
                          primaryFilledButtonWidget(),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '국가적 위기상황이나 당장 대피가 필요할만큼\n생명에 위협이 되는 재난이에요.',
                        style: DaepiroTextStyle.body_2_m
                            .copyWith(color: DaepiroColorStyle.g_300),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(EmergencyDisasterList.length,
                                  (index) {
                                bool isTapped = selected.contains(index);
                                    return ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if(!isValueChangeNotifier.value) {
                                              isValueChangeNotifier.value = true;
                                            }
                                            if(isTapped) {
                                              selected.remove(index);
                                              viewModel.removeDisasterType(EmergencyDisasterList[index]['name']!);
                                            } else {
                                              selected.add(index);
                                              viewModel.addDisasterType(EmergencyDisasterList[index]['name']!);
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            overlayColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: isTapped ? DaepiroColorStyle.g_100 : DaepiroColorStyle.g_50,
                                                  width: 1
                                              ),
                                            ),
                                            padding: EdgeInsets.zero,
                                            elevation: 0.0,
                                            shadowColor: Colors.transparent
                                        ).copyWith(
                                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                if (states.contains(MaterialState.pressed)) {
                                                  return DaepiroColorStyle.g_50;
                                                } else if(isTapped) {
                                                  return DaepiroColorStyle.g_75;
                                                }
                                                return DaepiroColorStyle.white;
                                              }),
                                        ),
                                        child: disasterItem(EmergencyDisasterList[index]['name']!, EmergencyDisasterList[index]['icon']!)
                                    );
                              })),
                      SizedBox(height: 24),
                      Text(
                        '일반 재난',
                        style: DaepiroTextStyle.body_1_b
                            .copyWith(color: DaepiroColorStyle.g_900),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '기상 특보와 같이 안전 주의를 요하는 재난이에요.',
                        style: DaepiroTextStyle.caption
                            .copyWith(color: DaepiroColorStyle.g_300),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                        List.generate(CommonDisasterList.length, (index) {
                          bool isTapped = selectedSub.contains(index);
                          return ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if(!isValueChangeNotifier.value) {
                                    isValueChangeNotifier.value = true;
                                  }
                                  if(isTapped) {
                                    selectedSub.remove(index);
                                    viewModel.removeDisasterType(CommonDisasterList[index]['name']!);
                                  } else {
                                    selectedSub.add(index);
                                    viewModel.addDisasterType(CommonDisasterList[index]['name']!);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  overlayColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                        color: isTapped ? DaepiroColorStyle.g_100 : DaepiroColorStyle.g_50,
                                        width: 1
                                    ),
                                  ),
                                  padding: EdgeInsets.zero,
                                  elevation: 0.0,
                                  shadowColor: Colors.transparent
                              ).copyWith(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return DaepiroColorStyle.g_50;
                                      } else if(isTapped) {
                                        return DaepiroColorStyle.g_75;
                                      }
                                      return DaepiroColorStyle.white;
                                    }),
                              ),
                              child: disasterItem(CommonDisasterList[index]['name']!,  CommonDisasterList[index]['icon']!)
                          );
                        }),
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerWidget(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: GestureDetector(
            onTap: () => GoRouter.of(context).pop(),
            child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                width: 24,
                height: 24,
                colorFilter:
                ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)),
          ),
        ),
        Spacer(),
        Text('재난 유형 설정',
            style:
            DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800)),
        Spacer(),
        // GestureDetector(
        //   onTap: () async {
        //     final isSuccess = await ref.read(myPageProvider.notifier).setDisasterType();
        //     showSnackbar(context, isSuccess);
        //   },
        //   child: Text('저장',
        //       style: DaepiroTextStyle.body_1_m
        //           .copyWith(color: DaepiroColorStyle.o_500)),
        // )
        ValueListenableBuilder<bool>(
            valueListenable: isValueChangeNotifier,
            builder: (context, isChanged, child) {
              return GestureDetector(
                onTap: () async {
                  if(isChanged) {
                    final isSuccess = await ref.read(myPageProvider.notifier).setDisasterType();
                    showSnackbar(context, isSuccess);
                  }
                },
                child: Text('저장',
                    style: DaepiroTextStyle.body_1_m
                        .copyWith(color: isChanged ? DaepiroColorStyle.o_500 : DaepiroColorStyle.g_100)),
              );
            }
        )
      ],
    );
  }

  Widget primaryFilledButtonWidget() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: DaepiroColorStyle.o_50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/icon_alarm.svg',
                width: 16,
                height: 16,
                colorFilter:
                ColorFilter.mode(DaepiroColorStyle.o_500, BlendMode.srcIn)),
            Text(
              '수신권장',
              style: DaepiroTextStyle.caption
                  .copyWith(color: DaepiroColorStyle.o_500),
            )
          ],
        ),
      ),
    );
  }

  Widget disasterItem(String name, String icon) {
    return Container(
      width: (MediaQuery.of(context).size.width / 3) - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: DaepiroColorStyle.g_50,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(icon,
                  width: 36,
                  height: 36,
                  colorFilter: const ColorFilter.mode(
                      DaepiroColorStyle.g_500, BlendMode.srcIn)),
            ),
          ),
          const SizedBox(height: 4,),
          Text(
            name,
            style: DaepiroTextStyle.body_2_m
                .copyWith(color: DaepiroColorStyle.g_500),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void showSnackbar(BuildContext context, bool isSuccess) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 20.0,
        right: 20.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        isSuccess ? '저장되었어요.' : '다시 시도해주세요.',
                        style: DaepiroTextStyle.body_2_m
                            .copyWith(color: DaepiroColorStyle.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}