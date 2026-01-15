import 'package:daepiro/presentation/onboarding/controller/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/button/primary_filled_button.dart';
import '../../../cmm/widget/button/secondary_filled_button.dart';
import '../../const/common_disaster_list.dart';
import '../../const/emergency_disaster_list.dart';

class OnboardingFourthScreen extends ConsumerStatefulWidget {
  const OnboardingFourthScreen({super.key});

  @override
  OnboardingFourthState createState() => OnboardingFourthState();
}

class OnboardingFourthState extends ConsumerState<OnboardingFourthScreen> {
  bool isInitialized = false;
  Set<int> selected = {};
  Set<int> selectedSub = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final state = ref.read(onboardingStateNotifierProvider);
      for(int i=0; i<EmergencyDisasterList.length; i++) {
        if(state.disasterTypes.contains(EmergencyDisasterList[i]['name']!)) {
          selected.add(i);
        }
      }
      for(int i=0; i<CommonDisasterList.length; i++) {
        if(state.disasterTypes.contains(CommonDisasterList[i]['name']!)) {
          selectedSub.add(i);
        }
      }
      setState(() {});
      isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(onboardingStateNotifierProvider.notifier);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerWidget(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          '위급/긴급 재난',
                          style: DaepiroTextStyle.h6
                              .copyWith(color: DaepiroColorStyle.g_900),
                        ),
                        const Spacer(),
                        primaryFilledButtonWidget(),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '국가적 위기상황이나 당장 대피가 필요할만큼\n생명에 위협이 되는 재난이에요.',
                      style: DaepiroTextStyle.body_2_m
                          .copyWith(color: DaepiroColorStyle.g_300),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(EmergencyDisasterList.length,
                                (index) {
                              bool isTapped = selected.contains(index);
                              return ElevatedButton(
                                  onPressed: () {
                                    setState(() {
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
                    const SizedBox(height: 24),
                    Text(
                      '일반 재난',
                      style: DaepiroTextStyle.h6
                          .copyWith(color: DaepiroColorStyle.g_900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '기상 특보와 같이 안전 주의를 요하는 재난입니다.',
                      style: DaepiroTextStyle.body_2_m
                          .copyWith(color: DaepiroColorStyle.g_300),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                      List.generate(CommonDisasterList.length, (index) {
                        bool isTapped = selectedSub.contains(index);
                        return ElevatedButton(
                            onPressed: () {
                              setState(() {
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
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            bottomWidget(context),
          ],
        )
      )),
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
                    const ColorFilter.mode(DaepiroColorStyle.o_500, BlendMode.srcIn)),
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

  Widget headerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: LinearPercentIndicator(
                padding: EdgeInsets.zero,
                percent: 1.0,
                lineHeight: 10,
                backgroundColor: DaepiroColorStyle.g_50,
                progressColor: DaepiroColorStyle.o_300,
                barRadius: const Radius.circular(10.0),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '3/3',
              style: DaepiroTextStyle.body_1_b
                  .copyWith(color: DaepiroColorStyle.g_100),
            ),
          ],
        ),
        const SizedBox(height: 24),
        RichText(
            text: TextSpan(
                text: '수신 받을 ',
                style: DaepiroTextStyle.h5
                    .copyWith(color: DaepiroColorStyle.black),
                children: [
              TextSpan(
                text: '재난 유형',
                style: DaepiroTextStyle.h5
                    .copyWith(color: DaepiroColorStyle.o_400),
              ),
              TextSpan(
                text: '을\n',
                style: DaepiroTextStyle.h5
                    .copyWith(color: DaepiroColorStyle.black),
              ),
              TextSpan(
                text: '선택해주세요.',
                style: DaepiroTextStyle.h5
                    .copyWith(color: DaepiroColorStyle.black),
              ),
            ])),
      ],
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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget bottomWidget(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: PrimaryFilledButton(
                        onPressed: GoRouter.of(context).pop,
                        backgroundColor: DaepiroColorStyle.g_50,
                        pressedColor: DaepiroColorStyle.g_75,
                        borderRadius: 8.0,
                        disabledColor: DaepiroColorStyle.g_50,
                        verticalPadding: 12,
                        child: Text(
                          '이전',
                          style: DaepiroTextStyle.body_1_b
                              .copyWith(color: DaepiroColorStyle.g_700),
                        ))),
                const SizedBox(width: 8),
                Expanded(
                    child: PrimaryFilledButton(
                        onPressed: () => GoRouter.of(context).push('/onboarding/fourth'),
                        backgroundColor: DaepiroColorStyle.o_500,
                        pressedColor: DaepiroColorStyle.o_600,
                        borderRadius: 8.0,
                        disabledColor: DaepiroColorStyle.o_500,
                        verticalPadding: 12,
                        child: Text(
                          '다음',
                          style: DaepiroTextStyle.body_1_b
                              .copyWith(color: DaepiroColorStyle.white),
                        ))),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextButton(
                  onPressed: () {
                    remindDialog(context);
                  },
                  child: Text(
                    '다음에 설정하기',
                    style: DaepiroTextStyle.body_2_m
                        .copyWith(color: DaepiroColorStyle.g_300),
                  )),
            ),
          ],
        ));
  }

  void remindDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: Colors.white,
            titlePadding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  '다음에 설정하고\n모든 재난 정보를 수신하시겠어요?',
                  style: DaepiroTextStyle.body_1_b
                      .copyWith(color: DaepiroColorStyle.g_900,),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '알림 설정은 마이페이지에서 변경할 수 있어요.',
                      style: DaepiroTextStyle.body_2_m
                          .copyWith(color: DaepiroColorStyle.g_500),
                    ),
                  ]),
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: SecondaryFilledButton(
                        verticalPadding: 12,
                        onPressed: GoRouter.of(context).pop,
                        radius: 8,
                        backgroundColor: DaepiroColorStyle.g_50,
                        pressedColor: DaepiroColorStyle.g_75,
                        child: Text(
                          textAlign: TextAlign.center,
                          '돌아가기',
                          style: DaepiroTextStyle.body_1_b
                              .copyWith(color: DaepiroColorStyle.g_700),
                        )),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: SecondaryFilledButton(
                        verticalPadding: 12,
                        onPressed: () {
                          ref.read(onboardingStateNotifierProvider.notifier).setDisasterAllType();
                          for(int i=0; i<EmergencyDisasterList.length; i++) {
                            selected.add(i);
                          }
                          for(int i=0; i<CommonDisasterList.length; i++) {
                            selectedSub.add(i);
                          }
                          GoRouter.of(context).pop();
                          GoRouter.of(context).push('/onboarding/fourth');
                        },
                        radius: 8,
                        backgroundColor: DaepiroColorStyle.g_700,
                        pressedColor: DaepiroColorStyle.g_400,
                        child: Text(
                          textAlign: TextAlign.center,
                          '다음에 하기',
                          style: DaepiroTextStyle.body_1_b
                              .copyWith(color: DaepiroColorStyle.white),
                        )),
                  )
                ],
              ),
            ],
          );
        });
  }
}
