import 'package:daepiro/presentation/onboarding/controller/onboarding_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/button/primary_filled_button.dart';

class OnboardingFifthScreen extends ConsumerStatefulWidget {
  @override
  OnboardingFifthState createState() => OnboardingFifthState();
}

class OnboardingFifthState extends ConsumerState<OnboardingFifthScreen> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingStateNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 48,),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: headerWidget()),
                      SizedBox(height: 36),
                      allAgreeWidget(state.isAllAppPermissionGrant, ref),
                      SizedBox(height: 16),
                      privateInfoWidget(state.termList[0], 0, state.isAppPermissionCheckboxState, ref, null),
                      privateInfoWidget(state.termList[1], 1, state.isAppPermissionCheckboxState, ref, 0),
                      privateInfoWidget(state.termList[2], 2, state.isAppPermissionCheckboxState, ref, 1),
                      privateInfoWidget(state.termList[3], 3, state.isAppPermissionCheckboxState, ref, 2),
                    ],
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: bottomWidget(state.isAllAppPermissionGrant)),
            SizedBox(height: 28)
          ],
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이제 거의 다 왔어요!',
          style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.o_400),
        ),
        SizedBox(height: 8,),
        Text(
          '대피로 서비스 이용을 위해\n이용 약관에 동의해 주세요',
          style: DaepiroTextStyle.h5.copyWith(color: DaepiroColorStyle.g_900),
        ),
      ],
    );
  }

  Widget bottomWidget(bool isAllAppPermissionGrant) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
              child: PrimaryFilledButton(
                  onPressed: GoRouter.of(context).pop,
                  backgroundColor: DaepiroColorStyle.g_50,
                  pressedColor: DaepiroColorStyle.g_75,
                  borderRadius: 8.0,
                  disabledColor: DaepiroColorStyle.g_50,
                  child: Text(
                    '이전',
                    style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_700),
                  ),
                  verticalPadding: 12
              )
          ),
          SizedBox(width: 8),
          Expanded(
            child: PrimaryFilledButton(
              onPressed: isAllAppPermissionGrant ? () {
                GoRouter.of(context).push('/onboarding/final');
              } : null,
              backgroundColor: DaepiroColorStyle.o_500,
              pressedColor: DaepiroColorStyle.o_600,
              disabledColor: DaepiroColorStyle.o_100,
              borderRadius: 8,
              child: Text(
                '다음',
                style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.white),
              ),
              verticalPadding: 12,
            ),
          ),
        ],
      )
    );
  }

  //전체 권한 동의 위젯
  Widget allAgreeWidget(bool isAllPermissionGrant, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: ref.read(onboardingStateNotifierProvider.notifier).updateAllAgreeState,
        style: ElevatedButton.styleFrom(
            backgroundColor: DaepiroColorStyle.g_50,
            overlayColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(8),
            shadowColor: Colors.transparent,
            elevation: 0.0
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return DaepiroColorStyle.g_75;
            }
            return DaepiroColorStyle.g_50;
          }),
        ),
        child: Row(
          children: [
            Checkbox(
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: Colors.transparent),
                activeColor: DaepiroColorStyle.g_500,
                checkColor: DaepiroColorStyle.white,
                fillColor: MaterialStateProperty.resolveWith((state) {
                  if(!state.contains(MaterialState.selected)) {
                    return DaepiroColorStyle.g_100;
                  }
                  return null;
                }),
                value: isAllPermissionGrant,
                onChanged: (value) {
                  ref.read(onboardingStateNotifierProvider.notifier).updateAllAgreeState();
                }),
            SizedBox(width: 8,),
            Text(
              '전체 동의',
              style: DaepiroTextStyle.body_1_m.copyWith(color: DaepiroColorStyle.g_800),
            )
          ],
        ),
      ),
    );
  }

  //개별 권한 동의 위젯
  Widget privateInfoWidget(String term, int index, List<bool> isPermissionCheckboxState, WidgetRef ref, int? termValue) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () {
          if(termValue != null) {
            GoRouter.of(context).push('/onboarding_terms/${termValue}');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: DaepiroColorStyle.white,
            overlayColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(8),
            shadowColor: Colors.transparent,
            elevation: 0.0
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return DaepiroColorStyle.g_50;
            }
            return DaepiroColorStyle.white;
          }),
        ),
        child: Row(
          children: [
            Checkbox(
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: Colors.transparent),
                activeColor: DaepiroColorStyle.g_500,
                checkColor: DaepiroColorStyle.white,
                fillColor: MaterialStateProperty.resolveWith((state) {
                  if(!state.contains(MaterialState.selected)) {
                    return DaepiroColorStyle.g_100;
                  }
                  return null;
                }),
                value:isPermissionCheckboxState[index],
                onChanged: (value) {
                 ref.read(onboardingStateNotifierProvider.notifier).updateEachPermissionState(index);
                }),
            SizedBox(width: 8,),
            Expanded(
              child: Text(
                term,
                style: DaepiroTextStyle.body_1_m.copyWith(color: DaepiroColorStyle.g_800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Visibility(
                visible: index != 0,
                child: SvgPicture.asset(
                    'assets/icons/icon_arrow_right.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_100, BlendMode.srcIn)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}