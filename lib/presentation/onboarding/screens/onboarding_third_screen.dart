import 'package:daepiro/presentation/onboarding/widget/location_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../cmm/DaepiroTheme.dart';
import '../../../cmm/button/primary_filled_button.dart';
import '../../../cmm/button/secondary_filled_button.dart';
import '../controller/onboarding_view_model.dart';

class OnboardingThirdScreen extends ConsumerStatefulWidget {
  const OnboardingThirdScreen({super.key});

  @override
  OnboardingThirdState createState() => OnboardingThirdState();
}

class OnboardingThirdState extends ConsumerState<OnboardingThirdScreen> {
  TextEditingController homeController = TextEditingController();
  TextEditingController jusoController1 = TextEditingController();
  TextEditingController jusoController2 = TextEditingController();
  TextEditingController jusoNickController1 = TextEditingController();
  TextEditingController jusoNickController2 = TextEditingController();
  FocusNode nickFocusNode1 = FocusNode();
  FocusNode nickFocusNode2 = FocusNode();
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    // 검색 기록 초기화
    Future(() {
      ref.read(onboardingStateNotifierProvider.notifier).initSearchHistory();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final state = ref.read(onboardingStateNotifierProvider);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(state.isJuso1Visible && state.firstJusoNick == '') {
          ref.read(onboardingStateNotifierProvider.notifier).setVisibleState(1, false);
        }
        if(state.isJuso2Visible && state.secondJusoNick == '') {
          ref.read(onboardingStateNotifierProvider.notifier).setVisibleState(2, false);
        }
      });
      if(state.firstJusoNick != '') {
        jusoNickController1.text = state.firstJusoNick;
      }
      if(state.secondJusoNick != '') {
        jusoNickController2.text = state.secondJusoNick;
      }
      setState(() {});
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    homeController.dispose();
    jusoController1.dispose();
    jusoController2.dispose();
    jusoNickController1.dispose();
    jusoNickController2.dispose();
    nickFocusNode1.dispose();
    nickFocusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingStateNotifierProvider);

    bool isAvailable() {
      if(state.isJuso1Visible && !state.isJuso2Visible) {
        return state.homeJuso.isNotEmpty && state.firstJuso.isNotEmpty && state.firstJusoNick.isNotEmpty;
      } else if(state.isJuso1Visible && state.isJuso2Visible) {
        return state.homeJuso.isNotEmpty && state.firstJuso.isNotEmpty && state.firstJusoNick.isNotEmpty && state.secondJuso.isNotEmpty && state.secondJusoNick.isNotEmpty;
      } else if(!state.isJuso1Visible && state.isJuso2Visible) {
        return state.homeJuso.isNotEmpty && state.secondJuso.isNotEmpty && state.secondJusoNick.isNotEmpty;
      } else { //홈주소만 보여지는 상태
        return state.homeJuso.isNotEmpty;
      }
    }

    if (state.homeJuso != '') {
      homeController.text = state.homeJuso;
    }
    if (state.firstJuso != '') {
      jusoController1.text = state.firstJuso;
    }
    if (state.secondJuso != '') {
      jusoController2.text = state.secondJuso;
    }

    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(),
          SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state.isJuso2Visible)
                    InputLocationAddress2(jusoController2, jusoNickController2,
                        ref, state.secondJusoState, state.userNickName),
                  if (state.isJuso1Visible)
                    InputLocationAddress1(jusoController1, jusoNickController1,
                        ref, state.firstJusoState, state.userNickName),
                  InputHomeAddress(homeController, context, ref, state.homeJuso,
                      state.isJuso1Visible, state.isJuso2Visible, state.userNickName)
                ],
              ),
            ),
          ),
          bottomWidget(context, state.homeJuso, isAvailable()),
          SizedBox(height: 16),
        ],
      ),
    )));
  }

  //화면의 최상단 영역
  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: LinearPercentIndicator(
                padding: EdgeInsets.zero,
                percent: 0.6,
                lineHeight: 10,
                backgroundColor: DaepiroColorStyle.g_50,
                progressColor: DaepiroColorStyle.o_300,
                barRadius: Radius.circular(10.0),
              ),
            ),
            SizedBox(width: 16),
            Text(
              '2/3',
              style: DaepiroTextStyle.body_1_b
                  .copyWith(color: DaepiroColorStyle.g_100),
            ),
          ],
        ),
        SizedBox(height: 24),
        RichText(
            text: TextSpan(
                text: '재난 정보를 받을\n',
                style: DaepiroTextStyle.h5
                    .copyWith(color: DaepiroColorStyle.black),
                children: [
              TextSpan(
                text: '지역',
                style: DaepiroTextStyle.h5
                    .copyWith(color: DaepiroColorStyle.o_400),
              ),
              TextSpan(
                text: '을 ',
                style: DaepiroTextStyle.h5
                    .copyWith(color: DaepiroColorStyle.black),
              ),
              TextSpan(
                text: '설정해주세요',
                style: DaepiroTextStyle.h5
                    .copyWith(color: DaepiroColorStyle.black),
              ),
            ])),
        SizedBox(height: 4),
        Text(
          '지역은 최소 1개, 최대 3개까지 추가할 수 있어요.',
          style: DaepiroTextStyle.body_1_m
              .copyWith(color: DaepiroColorStyle.g_300),
        ),
      ],
    );
  }

  //홈칩 + 주소입력창
  Widget InputHomeAddress(
      TextEditingController homecontroller,
      BuildContext context,
      WidgetRef ref,
      String homeJuso,
      bool juso1Visible,
      bool juso2Visible,
      String userNickName,) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          homeChipWidget(),
          SizedBox(height: 10),
          TextField(
            onTap: () => GoRouter.of(context).push(
                '/onboarding/juso/집/0/${userNickName}',
              extra: {
                'fromMyPage': false,
              },
            ),
            enabled: true,
            readOnly: true,
            style: DaepiroTextStyle.body_1_m
                .copyWith(color: DaepiroColorStyle.g_900),
            focusNode: FocusNode(canRequestFocus: false),
            controller: homecontroller,
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(16),
              fillColor: DaepiroColorStyle.g_50,
              hintText: '동/읍/면/리',
              hintStyle: DaepiroTextStyle.body_1_m
                  .copyWith(color: DaepiroColorStyle.g_200),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: homecontroller.text.isEmpty
                    ? SvgPicture.asset('assets/icons/icon_search.svg',
                        colorFilter: ColorFilter.mode(
                            DaepiroColorStyle.g_200, BlendMode.srcIn))
                    : GestureDetector(
                        onTap: () {
                          deleteDialog(
                              context,
                              ref,
                              '집',
                              homecontroller,
                              null,
                              () => ref
                                  .read(
                                      onboardingStateNotifierProvider.notifier)
                                  .deleteHomeJuso(),
                              MediaQuery.of(context).size.width * 0.8);
                        },
                        child: SvgPicture.asset('assets/icons/icon_delete.svg',
                            colorFilter: ColorFilter.mode(
                                DaepiroColorStyle.g_400, BlendMode.srcIn)),
                      ),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: (homeJuso == '' && (juso1Visible || juso2Visible))
                          ? DaepiroColorStyle.r_300
                          : DaepiroColorStyle.g_50)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: (homeJuso == '' && (juso1Visible || juso2Visible))
                          ? DaepiroColorStyle.r_300
                          : DaepiroColorStyle.g_50)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: (homeJuso == '' && (juso1Visible || juso2Visible))
                          ? DaepiroColorStyle.r_300
                          : DaepiroColorStyle.g_50)),
            ),
          ),
          SizedBox(height: 6),
          if (homeJuso == '' && (juso1Visible || juso2Visible))
            Row(
              children: [
                Spacer(),
                Text(
                  '*집 주소를 필수로 입력해주세요',
                  style: DaepiroTextStyle.body_2_m
                      .copyWith(color: DaepiroColorStyle.r_300),
                ),
              ],
            ),
          SizedBox(height: 24),
          if (!juso1Visible || !juso2Visible)
            plusChipWidget(ref, homecontroller, jusoController1,
                jusoController2, juso1Visible, juso2Visible)
        ],
      ),
    );
  }

  //특정 지역 칩 + 텍스트필드 지역 1
  Widget InputLocationAddress1(
    TextEditingController juso1controller,
    TextEditingController jusoNickController1,
    WidgetRef ref,
    String firstJusoState,
      String userNickName,

  ) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationChip(
            controller: jusoNickController1,
            onChanged: (text) {
              ref
                  .read(onboardingStateNotifierProvider.notifier)
                  .checklocationControllerState(jusoNickController1, 1);
              setState(() {});
            },
            ref: ref,
            focusNode: nickFocusNode1,
            index: 1,
            onTapOutside: () {
              if(jusoNickController1.text.isEmpty) {
                ref.read(onboardingStateNotifierProvider.notifier).controlJusoState(1);
              }
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            style: DaepiroTextStyle.body_1_m
                .copyWith(color: DaepiroColorStyle.g_900),
            onTap: () {
              if (jusoNickController1.text.isNotEmpty) {
                GoRouter.of(context).push(
                    '/onboarding/juso/${jusoNickController1.text}/1/${userNickName}',
                  extra: {
                    'fromMyPage': false,
                  },
                );
              }
            },
            enabled: true,
            readOnly: true,
            focusNode: FocusNode(canRequestFocus: false),
            controller: juso1controller,
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(16),
              fillColor: DaepiroColorStyle.g_50,
              hintText: '동/읍/면/리',
              hintStyle: DaepiroTextStyle.body_1_m
                  .copyWith(color: DaepiroColorStyle.g_200),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(16),
                child: juso1controller.text.isEmpty
                    ? SvgPicture.asset('assets/icons/icon_search.svg',
                        colorFilter: ColorFilter.mode(
                            DaepiroColorStyle.g_200, BlendMode.srcIn))
                    : GestureDetector(
                        onTap: () => deleteDialog(
                            context,
                            ref,
                            jusoNickController1.text,
                            juso1controller,
                            jusoNickController1,
                            () => ref
                                .read(onboardingStateNotifierProvider.notifier)
                                .deleteFirstJuso(),
                            MediaQuery.of(context).size.width * 0.8),
                        child: SvgPicture.asset('assets/icons/icon_delete.svg',
                            colorFilter: ColorFilter.mode(
                                DaepiroColorStyle.g_400, BlendMode.srcIn)),
                      ),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: firstJusoState != 'Possible'
                          ? DaepiroColorStyle.r_300
                          : DaepiroColorStyle.g_50)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: firstJusoState != 'Possible'
                          ? DaepiroColorStyle.r_300
                          : DaepiroColorStyle.g_50)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: firstJusoState != 'Possible'
                          ? DaepiroColorStyle.r_300
                          : DaepiroColorStyle.g_50)),
            ),
          ),
          SizedBox(height: 6),
          if (firstJusoState != 'Possible')
            Row(
              children: [
                Spacer(),
                Text(
                  firstJusoState,
                  style: DaepiroTextStyle.body_2_m
                      .copyWith(color: DaepiroColorStyle.r_300),
                ),
              ],
            ),
          SizedBox(height: 24)
        ],
      ),
    );
  }

  //특정 지역 칩 + 텍스트필드 지역 2
  Widget InputLocationAddress2(
    TextEditingController juso2controller,
    TextEditingController jusoNickController2,
    WidgetRef ref,
    String secondJusoState,
      String userNickName
  ) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationChip(
            controller: jusoNickController2,
            onChanged: (text) {
              ref
                  .read(onboardingStateNotifierProvider.notifier)
                  .checklocationControllerState(jusoNickController2, 2);
            },
            ref: ref,
            focusNode: nickFocusNode2,
            index: 2,
            onTapOutside: () {
              if(jusoNickController2.text.isEmpty) {
                ref.read(onboardingStateNotifierProvider.notifier).controlJusoState(2);
              }
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            style: DaepiroTextStyle.body_1_m
                .copyWith(color: DaepiroColorStyle.g_900),
            onTap: () {
              if (jusoNickController2.text.isNotEmpty) {
                GoRouter.of(context).push(
                    '/onboarding/juso/${jusoNickController2.text}/2/${userNickName}',
                  extra: {
                    'fromMyPage': false,
                  },
                );
              }
            },
            enabled: true,
            readOnly: true,
            focusNode: FocusNode(canRequestFocus: false),
            controller: juso2controller,
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(16),
              fillColor: DaepiroColorStyle.g_50,
              hintText: '동/읍/면/리',
              hintStyle: DaepiroTextStyle.body_1_m
                  .copyWith(color: DaepiroColorStyle.g_200),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(16),
                child: juso2controller.text.isEmpty
                    ? SvgPicture.asset('assets/icons/icon_search.svg',
                        colorFilter: ColorFilter.mode(
                            DaepiroColorStyle.g_200, BlendMode.srcIn))
                    : GestureDetector(
                        onTap: () => deleteDialog(
                            context,
                            ref,
                            jusoNickController2.text,
                            juso2controller,
                            jusoNickController2,
                            () => ref
                                .read(onboardingStateNotifierProvider.notifier)
                                .deleteSecondJuso(),
                            MediaQuery.of(context).size.width * 0.8),
                        child: SvgPicture.asset('assets/icons/icon_delete.svg',
                            colorFilter: ColorFilter.mode(
                                DaepiroColorStyle.g_400, BlendMode.srcIn)),
                      ),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: secondJusoState != 'Possible'
                          ? DaepiroColorStyle.r_300
                          : DaepiroColorStyle.g_50)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: secondJusoState != 'Possible'
                          ? DaepiroColorStyle.r_300
                          : DaepiroColorStyle.g_50)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: secondJusoState != 'Possible'
                          ? DaepiroColorStyle.r_300
                          : DaepiroColorStyle.g_50)),
            ),
          ),
          SizedBox(height: 6),
          if (secondJusoState != 'Possible')
            Row(
              children: [
                Spacer(),
                Text(
                  '*별명은 필수로 입력해주세요.',
                  style: DaepiroTextStyle.body_2_m
                      .copyWith(color: DaepiroColorStyle.r_300),
                ),
              ],
            ),
          SizedBox(height: 24)
        ],
      ),
    );
  }

  //화면에 사용되는 칩들 정의
  //홈칩
  Widget homeChipWidget() {
    return SecondaryFilledButton(
      onPressed: null,
      radius: 99,
      backgroundColor: DaepiroColorStyle.g_600,
      pressedColor: DaepiroColorStyle.g_600,
      verticalPadding: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/icon_home.svg',
                colorFilter:
                    ColorFilter.mode(DaepiroColorStyle.white, BlendMode.srcIn)),
            SizedBox(
              width: 2,
            ),
            Text(
              '집',
              style: DaepiroTextStyle.body_2_b
                  .copyWith(color: DaepiroColorStyle.white),
            ),
          ],
        ),
      ),
    );
  }

  //지역 추가 칩
  Widget plusChipWidget(
      WidgetRef ref,
      TextEditingController homecontroller,
      TextEditingController jusoController1,
      TextEditingController jusoController2,
      bool juso1visible,
      bool juso2visible) {
    bool isButtonDisabled = ref
        .watch(onboardingStateNotifierProvider.notifier)
        .checkPlusChipState(homecontroller, jusoController1, jusoController2, juso1visible, juso2visible);
    return SecondaryFilledButton(
      onPressed: () {
        if (!isButtonDisabled) {
          null;
        } else {
          if ((!juso1visible && !juso2visible) ||
              (!juso1visible && juso2visible)) {
            ref
                .read(onboardingStateNotifierProvider.notifier)
                .setVisibleState(1, true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(nickFocusNode1);
            });
          } else if (juso1visible && !juso2visible) {
            ref
                .read(onboardingStateNotifierProvider.notifier)
                .setVisibleState(2, true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(nickFocusNode2);
            });
          }
        }
      },
      radius: 99,
      horizontalPadding: 16,
      verticalPadding: 8,
      backgroundColor: DaepiroColorStyle.g_50,
      disableColor: DaepiroColorStyle.g_50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/icon_plus.svg',
            colorFilter: ColorFilter.mode(
                isButtonDisabled
                    ? DaepiroColorStyle.g_600
                    : DaepiroColorStyle.g_100,
                BlendMode.srcIn),
            width: 16,
            height: 16,
          ),
          Text(
            '지역추가',
            style: DaepiroTextStyle.body_2_b.copyWith(
                color: isButtonDisabled
                    ? DaepiroColorStyle.g_600
                    : DaepiroColorStyle.g_100),
          ),
        ],
      ),
    );
  }

  //삭제시 안내 다이얼로그
  void deleteDialog(
      BuildContext context,
      WidgetRef ref,
      String locationNickName,
      TextEditingController controller,
      TextEditingController? nickController,
      VoidCallback onDelete,
      double width) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.only(top: 24),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SecondaryFilledButton(
                  radius: 99,
                  horizontalPadding: 16,
                  verticalPadding: 8,
                  backgroundColor: DaepiroColorStyle.g_600,
                  disableColor: DaepiroColorStyle.g_600,
                  onPressed: null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/icon_location.svg',
                        colorFilter: ColorFilter.mode(
                            DaepiroColorStyle.white, BlendMode.srcIn),
                        width: 16,
                        height: 16,
                      ),
                      Text(
                        locationNickName,
                        style: DaepiroTextStyle.body_2_b
                            .copyWith(color: DaepiroColorStyle.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 8, 20, 24),
            content: Container(
              width: width,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '지역을 삭제하시겠어요?',
                      style: DaepiroTextStyle.body_1_m
                          .copyWith(color: DaepiroColorStyle.g_900),
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
                        },
                        radius: 8,
                        backgroundColor: DaepiroColorStyle.g_50,
                        pressedColor: DaepiroColorStyle.g_75,
                        child: Text(
                          textAlign: TextAlign.center,
                          '취소하기',
                          style: DaepiroTextStyle.body_1_b
                              .copyWith(color: DaepiroColorStyle.g_700),
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: SecondaryFilledButton(
                        verticalPadding: 12,
                        onPressed: () async {
                          onDelete();
                          nickController?.clear();
                          controller.clear();
                          GoRouter.of(context).pop();
                        },
                        radius: 8,
                        backgroundColor: DaepiroColorStyle.g_700,
                        pressedColor: DaepiroColorStyle.g_400,
                        child: Text(
                          textAlign: TextAlign.center,
                          '삭제하기',
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

  Widget bottomWidget(BuildContext context, String homeJuso, bool isAvailable) {
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
                    child: Text(
                      '이전',
                      style: DaepiroTextStyle.body_1_b
                          .copyWith(color: DaepiroColorStyle.g_700),
                    ),
                    verticalPadding: 12)),
            SizedBox(width: 8),
            Expanded(
                child: PrimaryFilledButton(
                    onPressed: isAvailable
                        ? () async => {
                              ref
                                  .read(
                                      onboardingStateNotifierProvider.notifier)
                                  .setJusoNick(jusoNickController1.text,
                                      jusoNickController2.text),
                              GoRouter.of(context).push('/onboarding/third')
                            }
                        : null,
                    backgroundColor: isAvailable
                        ? DaepiroColorStyle.o_500
                        : DaepiroColorStyle.o_100,
                    pressedColor: DaepiroColorStyle.o_600,
                    borderRadius: 8.0,
                    child: Text(
                      '다음',
                      style: DaepiroTextStyle.body_1_b
                          .copyWith(color: DaepiroColorStyle.white),
                    ),
                    verticalPadding: 12)),
          ],
        ));
  }
}
