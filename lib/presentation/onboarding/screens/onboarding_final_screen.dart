import 'package:daepiro/presentation/onboarding/controller/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/button/primary_filled_button.dart';

class OnboardingFinalScreen extends ConsumerStatefulWidget {
  const OnboardingFinalScreen({super.key});

  @override
  _OnboardingFinalState createState() => _OnboardingFinalState();
}
class _OnboardingFinalState extends ConsumerState<OnboardingFinalScreen> {
  //late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    // controller = controller = VideoPlayerController.asset('assets/videos/outtro_video.mp4')..initialize();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.play();
    // });
  }

  @override
  void dispose() {
    super.dispose();
    //controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(onboardingStateNotifierProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      // child: AspectRatio(
                      //   aspectRatio: controller.value.aspectRatio,
                      //   child: VideoPlayer(controller),
                      // ),
                      child: Text('dkfj'),
                    ),
                  )
              ),
            )),
            Positioned(
              top: 48,
              left: 20,
              right: 20,
              child: Text(
                '이젠 대피로와 함께\n안전한 생활을 시작해보세요!',
                style: DaepiroTextStyle.h5.copyWith(color: DaepiroColorStyle.g_900),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: PrimaryFilledButton(
                    onPressed: () async {
                      await viewModel.sendUserInfo();
                      await viewModel.storeSecureStorage();
                      GoRouter.of(context).go('/home');
                    },
                    backgroundColor: DaepiroColorStyle.o_500,
                    pressedColor: DaepiroColorStyle.o_500,
                    borderRadius: 8,
                    verticalPadding: 12,
                    child: Text(
                      '대피로 시작하기',
                      style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.white),
                    )
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}