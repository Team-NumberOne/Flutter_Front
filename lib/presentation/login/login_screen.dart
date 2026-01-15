import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../cmm/theme/DaepiroTheme.dart';
import '../../cmm/widget/button/secondary_filled_button.dart';
import '../onboarding/screens/permission_screen.dart';
import 'login_state.dart';
import 'login_view_model.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(loginStateNotifierProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;

    ref.listen<LoginState>(loginStateNotifierProvider, (previous, next) async {
      if (next.isLoginSuccess && next.isCompletedOnboarding) {
        await viewModel.setFcmToken();
        await viewModel.storeUserAdresses();
        GoRouter.of(context).go('/home');
      } else if (next.isLoginSuccess && !next.isCompletedOnboarding) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          builder: (context) {
            return Wrap(
              children: [
                PermissionScreen(onPermissionCheck: () async {
                  GoRouter.of(context).pop();
                  var locationGrant = await ref
                      .read(loginStateNotifierProvider.notifier)
                      .checkLocationPermission();
                  if (!locationGrant) {
                    locationDialog(context, ref);
                  } else {
                    GoRouter.of(context).go('/onboarding');
                  }
                }),
              ],
            );
          },
        ).then((value) {
          GoRouter.of(context).go('/onboarding');
        });

      }
    });

    return Scaffold(
      body: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: screenHeight * 0.63,
              color: DaepiroColorStyle.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 75),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '안전으로 연결하는 통로',
                        style: DaepiroTextStyle.body_1_b
                            .copyWith(color: DaepiroColorStyle.o_500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                          child: SvgPicture.asset(
                        'assets/icons/icon_logo_small.svg',
                        height: 48,
                      ))
                    ],
                  ),
                ),
              )),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoginButton(
                    const Color(0xFFFAE300),
                    () async {
                      await ref
                          .read(loginStateNotifierProvider.notifier)
                          .kakaoLogin();
                    },
                    KakaoWidget(),
                  ),
                  const SizedBox(height: 8),
                  LoginButton(
                    const Color(0xFF03C75A),
                    () async {
                      await ref
                          .read(loginStateNotifierProvider.notifier)
                          .naverLogin();
                    },
                    NaverWidget(),
                  ),
                  const SizedBox(height: 8),
                  if (Platform.isIOS)
                    Column(
                      children: [
                        LoginButton(DaepiroColorStyle.black, () async {
                          await ref
                              .read(loginStateNotifierProvider.notifier)
                              .appleLogin();
                        }, AppleWidget()),
                        const SizedBox(height: 41)
                      ],
                    )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }

  Widget KakaoWidget() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/icon_kakao.svg',
            color: DaepiroColorStyle.black,
          ),
          const SizedBox(width: 8),
          Text(
            'Kakao로 로그인',
            style: DaepiroTextStyle.body_1_m
                .copyWith(color: DaepiroColorStyle.black),
          )
        ],
      ),
    );
  }

  Widget NaverWidget() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/icon_naver.svg'),
          const SizedBox(width: 8),
          Text(
            'Naver로 로그인',
            style: DaepiroTextStyle.body_1_m
                .copyWith(color: DaepiroColorStyle.white),
          )
        ],
      ),
    );
  }

  Widget AppleWidget() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/icon_apple_logo.svg',
          colorFilter:
          const ColorFilter.mode(DaepiroColorStyle.white, BlendMode.srcIn)),
          const SizedBox(width: 8),
          Text(
            'Apple로 로그인',
            style: DaepiroTextStyle.body_1_m
                .copyWith(color: DaepiroColorStyle.white),
          )
        ],
      ),
    );
  }

  Widget LoginButton(
      Color backgroundColor, VoidCallback onPressed, Widget child) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          overlayColor: DaepiroColorStyle.black.withOpacity(0.1),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: child);
  }

  void locationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: DaepiroColorStyle.white,
            titlePadding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '현재 위치를 기반으로 정보를 제공해요',
                  style: DaepiroTextStyle.body_1_b
                      .copyWith(color: DaepiroColorStyle.g_900),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '위치 권한을 허용하지 않으면\n거주지를 기준으로 재난문자가 발송돼요.',
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
                        onPressed: () {
                          GoRouter.of(context).pop();
                          GoRouter.of(context).go('/onboarding');
                        },
                        radius: 8,
                        backgroundColor: DaepiroColorStyle.g_50,
                        pressedColor: DaepiroColorStyle.g_75,
                        child: Text(
                          textAlign: TextAlign.center,
                          '위치 미허용',
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
                        onPressed: () async {
                          await ref
                              .read(loginStateNotifierProvider.notifier)
                              .requestLocationPermission();
                          GoRouter.of(context).pop();
                          GoRouter.of(context).go('/onboarding');
                        },
                        radius: 8,
                        backgroundColor: DaepiroColorStyle.g_700,
                        pressedColor: DaepiroColorStyle.g_400,
                        child: Text(
                          textAlign: TextAlign.center,
                          '위치 허용',
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
