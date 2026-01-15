import 'package:daepiro/presentation/mypage/controller/mypage_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/button/secondary_light_button.dart';

class MyPageAlarmSettingScreen extends ConsumerStatefulWidget {
  const MyPageAlarmSettingScreen({super.key});

  @override
  MyPageAlarmSettingScreenState createState() => MyPageAlarmSettingScreenState();
}

class MyPageAlarmSettingScreenState extends ConsumerState<MyPageAlarmSettingScreen> with WidgetsBindingObserver {
  bool isGrant = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final viewModel = ref.read(myPageProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        isGrant = await viewModel.checknotificationPermission();
        if(isGrant) {
          await viewModel.getAlarmSettingType();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPageProvider);
    final viewModel = ref.read(myPageProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerWidget(context, ref),
            alarmSettingListItem(
                '커뮤니티 알림',
                '재난 상황과 동네생활 커뮤니케이션에 대한\n댓글, 좋아요 등의 정보를 전달하는 알림이에요.',
                state.communityAlarmState,
                () => viewModel.setNotificationType('community', isGrant)
            ),
            Container(
              width: double.infinity,
              height: 1,
              decoration: BoxDecoration(
                color: DaepiroColorStyle.g_50
              ),
            ),
            alarmSettingListItem(
                '재난 알림',
                '재난 문자 및 정보를 전달하는 알림이에요.',
                state.disasterAlarmState,
                    () => viewModel.setNotificationType('disaster', isGrant)
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SecondaryLightButton(
                  onPressed: () {
                    GoRouter.of(context).push('/mypage_setting_address');
                    viewModel.setLoadingState();
                  },
                  radius: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '재난 알림 지역 설정',
                          style: DaepiroTextStyle.body_1_m.copyWith(color: Colors.black),
                        ),
                        SvgPicture.asset('assets/icons/icon_arrow_right.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(DaepiroColorStyle.g_400, BlendMode.srcIn)
                        ),
                      ],
                    ),
                  ),
                  padding: 16
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SecondaryLightButton(
                  onPressed: () => GoRouter.of(context).push('/mypage_setting_disaster_type'),
                  radius: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '재난 유형 설정',
                          style: DaepiroTextStyle.body_1_m.copyWith(color: Colors.black),
                        ),
                        SvgPicture.asset('assets/icons/icon_arrow_right.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(DaepiroColorStyle.g_400, BlendMode.srcIn)
                        ),
                      ],
                    ),
                  ),
                  padding: 16),
            ),
          ],
        ),
      ),
    );
  }

  //헤더 위젯
  Widget headerWidget(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => GoRouter.of(context).pop(),
            child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                width: 24,
                height: 24,
                colorFilter:
                ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)),
          ),
          Spacer(),
          Text('알림 설정',
              style:
              DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800)),
          Spacer(),
          SizedBox(width: 24)
        ],
      ),
    );
  }

  Widget alarmSettingListItem(String title, String content, bool value, Function onChanged) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: DaepiroTextStyle.body_1_m.copyWith(color: Colors.black)),
                  SizedBox(height: 4),
                  Text(content,  style: DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_300)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                width: 38,
                height: 22,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: CupertinoSwitch(
                      value: value,
                      onChanged: (bool value) {
                        onChanged();
                      },
                    activeColor: DaepiroColorStyle.o_500,
                    thumbColor: Colors.white,
                    trackColor: DaepiroColorStyle.g_100,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}