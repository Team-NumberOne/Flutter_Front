import 'package:daepiro/presentation/onboarding/controller/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/button/primary_filled_button.dart';
import '../../../route/router.dart';

class OnboardingSecondScreen extends ConsumerStatefulWidget {
  const OnboardingSecondScreen({super.key});

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends ConsumerState<OnboardingSecondScreen> {
  final TextEditingController nicknameController = TextEditingController();
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    ref.read(onboardingStateNotifierProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final state = ref.read(onboardingStateNotifierProvider);

      nicknameController.text = state.userNickName;
      setState(() {});
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingStateNotifierProvider);
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return PopScope(
      canPop: false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              headerWidget(),
                              const SizedBox(height: 24),
                              Text(
                                '닉네임',
                                style: DaepiroTextStyle.h6
                                    .copyWith(color: DaepiroColorStyle.g_900),
                              ),
                              const SizedBox(height: 8),
                              nickNameTextField(
                                  nicknameController, state.nicknameState),
                              if (state.nicknameState != '')
                                nickNamestateText(state.nicknameState)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: keyboardHeight),
                        // 키보드 높이만큼 하단 패딩 추가
                        child: BottomWidget(
                            context,
                            ref
                                .read(onboardingStateNotifierProvider.notifier)
                                .getProceedState()),
                      ),
                      const SizedBox(height: 16)
                    ],
                  )))),
    );
  }

  Widget BottomWidget(BuildContext context, bool isAvailable) {
    return SizedBox(
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
                    verticalPadding: 12,
                    child: Text(
                      '이전',
                      style: DaepiroTextStyle.body_1_b
                          .copyWith(color: DaepiroColorStyle.g_700),
                    ))),
            const SizedBox(width: 8),
            Expanded(
                child: PrimaryFilledButton(
                    onPressed: isAvailable
                        ? () async => {
                              ref
                                  .read(
                                      onboardingStateNotifierProvider.notifier)
                                  .updateNickName(nicknameController.text),
                              GoRouter.of(context).push('/onboarding/second'),
                              storage.write(key: 'nickname', value: nicknameController.text)
                            }
                        : null,
                    backgroundColor: isAvailable
                        ? DaepiroColorStyle.o_500
                        : DaepiroColorStyle.o_100,
                    pressedColor: DaepiroColorStyle.o_600,
                    borderRadius: 8.0,
                    verticalPadding: 12,
                    child: Text('다음',
                        style: DaepiroTextStyle.body_1_b
                            .copyWith(color: DaepiroColorStyle.white)))),
          ],
        ));
  }

  Widget headerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearPercentIndicator(
                padding: EdgeInsets.zero,
                percent: 0.3,
                lineHeight: 10,
                backgroundColor: DaepiroColorStyle.g_50,
                progressColor: DaepiroColorStyle.o_300,
                barRadius: const Radius.circular(10.0),
              ),
            ),
            const SizedBox(width: 16),
            Text('1/3',
                style: DaepiroTextStyle.body_1_b
                    .copyWith(color: DaepiroColorStyle.g_100)),
          ],
        ),
        const SizedBox(height: 24),
        RichText(
          text: TextSpan(
              text: '닉네임',
              style:
                  DaepiroTextStyle.h5.copyWith(color: DaepiroColorStyle.o_400),
              children: [
                TextSpan(
                    text: '을 입력해주세요',
                    style: DaepiroTextStyle.h5
                        .copyWith(color: DaepiroColorStyle.black))
              ]),
        ),
        const SizedBox(height: 4),
        Text(
          '서비스에서 사용할 닉네임을 입력해주세요',
          style: DaepiroTextStyle.body_1_m
              .copyWith(color: DaepiroColorStyle.g_300),
        ),
      ],
    );
  }

  //이름 입력란
  // Widget NameTextField(
  //     TextEditingController controller, String nameState) {
  //   return Stack(
  //     children: [
  //       TextField(
  //         controller: controller,
  //         cursorColor: DaepiroColorStyle.g_900,
  //         onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
  //         style: DaepiroTextStyle.body_1_m
  //             .copyWith(color: DaepiroColorStyle.g_900, decorationThickness: 0),
  //         decoration: InputDecoration(
  //             filled: true,
  //             isDense: true,
  //             contentPadding: const EdgeInsets.all(16),
  //             fillColor: DaepiroColorStyle.g_50,
  //             hintText: '6자 이내의 한글',
  //             hintStyle: DaepiroTextStyle.body_1_m
  //                 .copyWith(color: DaepiroColorStyle.g_200),
  //             focusedBorder: OutlineInputBorder(
  //                 borderRadius: const BorderRadius.all(Radius.circular(4)),
  //                 borderSide: BorderSide(
  //                     width: 1.5,
  //                     color: nameState != ''
  //                         ? DaepiroColorStyle.r_300
  //                         : DaepiroColorStyle.g_100)),
  //             enabledBorder: const OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(4)),
  //                 borderSide:
  //                     BorderSide(width: 1, color: DaepiroColorStyle.g_50)),
  //             suffixIcon: Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  //               child: Text('${controller.text.length}/6',
  //                   style: DaepiroTextStyle.body_1_m.copyWith(
  //                       color: controller.text.length > 6
  //                           ? DaepiroColorStyle.r_300
  //                           : DaepiroColorStyle.g_200)),
  //             )),
  //         onChanged: (text) {
  //           ref
  //               .read(onboardingStateNotifierProvider.notifier)
  //               .setNameState(text);
  //           setState(() {});
  //         },
  //       ),
  //     ],
  //   );
  // }

  //닉네임 입력란
  Widget nickNameTextField(
      TextEditingController controller, String nickNameState) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          cursorColor: DaepiroColorStyle.g_900,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          style: DaepiroTextStyle.body_1_m
              .copyWith(color: DaepiroColorStyle.g_900, decorationThickness: 0),
          decoration: InputDecoration(
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.all(16),
              fillColor: DaepiroColorStyle.g_50,
              hintText: '10자 이내의 한글/영문/숫자',
              hintStyle: DaepiroTextStyle.body_1_m
                  .copyWith(color: DaepiroColorStyle.g_200),
              focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1.5, color: setBorderColor(nickNameState))),
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide:
                      BorderSide(width: 1, color: DaepiroColorStyle.g_50)),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text('${controller.text.length}/10',
                    style: DaepiroTextStyle.body_1_m.copyWith(
                        color: controller.text.length > 10
                            ? DaepiroColorStyle.r_300
                            : DaepiroColorStyle.g_200)),
              )),
          onChanged: (text) async {
            await ref
                .read(onboardingStateNotifierProvider.notifier)
                .setNickNameState(text);
          },
        ),
      ],
    );
  }

  Color setBorderColor(String nickNameState) {
    if (nickNameState == '') {
      return DaepiroColorStyle.g_100;
    } else if (nickNameState != '*사용 가능한 닉네임 입니다.') {
      return DaepiroColorStyle.r_300;
    } else {
      return DaepiroColorStyle.g_100;
    }
  }

  Widget nickNamestateText(String nickNameState) {
    return Container(
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Spacer(),
        Text(nickNameState,
            style: DaepiroTextStyle.body_2_m.copyWith(
                color: nickNameState == '*사용 가능한 닉네임 입니다.'
                    ? DaepiroColorStyle.gre_400
                    : DaepiroColorStyle.r_300)),
      ]),
    );
  }

  Widget namestateText(String nickNameState) {
    return Container(
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Spacer(),
        Text(nickNameState,
            style: DaepiroTextStyle.body_2_m
                .copyWith(color: DaepiroColorStyle.r_300)),
      ]),
    );
  }
}
