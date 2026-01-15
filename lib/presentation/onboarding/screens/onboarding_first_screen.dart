import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/button/primary_filled_button.dart';

class OnboardingFirstScreen extends StatefulWidget {
  const OnboardingFirstScreen({super.key});

  @override
  _OnboardingFirstState createState() => _OnboardingFirstState();
}

class _OnboardingFirstState extends State<OnboardingFirstScreen> {
 // late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    // controller = controller = VideoPlayerController.asset('assets/videos/intro_video.mp4')..initialize();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.play();
    // });
  }

  @override
  void dispose() {
    super.dispose();
   // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 80,
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        // child: AspectRatio(
                        //   aspectRatio: controller.value.aspectRatio,
                        //   child: VideoPlayer(controller),
                        // ),
                        child: Text('dfsd'),
                      ),
                    )
                ),
              ),
            ),
            Positioned(
                top: 48,
                right: 20,
                left: 20,
                child: headerWidget()
            ),
            Positioned(
                bottom: 16,
                right: 20,
                left: 20,
                child: footerWidget(context, double.infinity)
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
        Text(
          '반복되는 수신과 불명확한 재난문자로\n불편함을 겪으셨나요?',
          style: DaepiroTextStyle.body_1_m
              .copyWith(color: DaepiroColorStyle.g_500),
        ),
        const SizedBox(height: 8),
        Text(
          '대피로가 해결해드릴게요.',
          style: DaepiroTextStyle.h5.copyWith(color: DaepiroColorStyle.g_900),
        ),
      ],
    );
  }

  Widget footerWidget(BuildContext context, double width) {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        width: width,
        child: PrimaryFilledButton(
            onPressed: () {
              GoRouter.of(context).push('/onboarding/first');
            },
            backgroundColor: const Color(0xFFFF6929),
            pressedColor: const Color(0xFFFF6929),
            verticalPadding: 12,
            borderRadius: 8,
            child: Text(
              '다음',
              style: DaepiroTextStyle.body_1_b
                  .copyWith(color: DaepiroColorStyle.white),
            )),
      ),
    );
  }

}
