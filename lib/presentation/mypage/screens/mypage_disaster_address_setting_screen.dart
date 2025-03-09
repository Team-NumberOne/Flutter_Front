import 'dart:ui';

import 'package:daepiro/presentation/mypage/controller/mypage_viewmodel.dart';
import 'package:daepiro/presentation/mypage/state/mypage_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/DaepiroTheme.dart';
import '../../../cmm/button/secondary_filled_button.dart';
import '../../onboarding/widget/location_chip.dart';

class MypageDisasterAddressSettingScreen extends ConsumerStatefulWidget {
  const MypageDisasterAddressSettingScreen({super.key});

  @override
  MyPageDisasterAddressState createState() => MyPageDisasterAddressState();
}

class MyPageDisasterAddressState extends ConsumerState<MypageDisasterAddressSettingScreen> {
  TextEditingController homeController = TextEditingController();
  TextEditingController jusoController1 = TextEditingController();
  TextEditingController jusoController2 = TextEditingController();
  TextEditingController jusoNickController1 = TextEditingController();
  TextEditingController jusoNickController2 = TextEditingController();
  FocusNode nickFocusNode1 = FocusNode();
  FocusNode nickFocusNode2 = FocusNode();
  final ValueNotifier<bool> isValueChangeNotifier = ValueNotifier(false);
  String firstJuso = '';
  String secondJuso = '';
  String homeJuso = '';

  @override
  void initState() {
    super.initState();
    // 검색 기록 초기화
    Future(() {
      ref.read(myPageProvider.notifier).initSearchHistory();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(myPageProvider.notifier).getAddressList();
      final state = ref.watch(myPageProvider);

      if (state.homeJuso != '') {
        homeController.text = state.homeJuso;
        homeJuso = state.homeJuso;
      }
      if (state.firstJuso != '') {
        jusoController1.text = state.firstJuso;
        jusoNickController1.text = state.firstJusoNick;
        firstJuso = state.firstJuso;
      }
      if (state.secondJuso != '') {
        jusoController2.text = state.secondJuso;
        jusoNickController2.text = state.secondJusoNick;
        secondJuso = state.secondJuso;
      }
    });
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
//pop하는 순간 상태 초기화 필요
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPageProvider);

    ref.listen<MyPageState>(myPageProvider, (previous, next) {
      if(previous?.homeJuso != next.homeJuso) {
        homeController.text = next.homeJuso;
      }
      if(previous?.firstJuso != next.firstJuso) {
        jusoController1.text = next.firstJuso;
      }
      if(previous?.secondJuso != next.secondJuso) {
        jusoController2.text = next.secondJuso;
      }
    });

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if(didPop) {
         ref.read(myPageProvider.notifier).initUserAddress();
         Future(() {
           ref.read(myPageProvider.notifier).initSearchHistory();
         });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                headerWidget(context, (state.homeJuso.isNotEmpty && homeJuso != state.homeJuso) || firstJuso != state.firstJuso || secondJuso != state.secondJuso),
                if(state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            InputHomeAddress(homeController, context, ref, state.homeJuso,
                                state.isJuso1Visible, state.isJuso2Visible, state.nickName),
                            if (state.isJuso1Visible)
                              InputLocationAddress1(jusoController1, jusoNickController1,
                                  ref, state.firstJusoState, state.nickName),
                            if (state.isJuso2Visible)
                              InputLocationAddress2(jusoController2, jusoNickController2,
                                  ref, state.secondJusoState, state.nickName),
                            if (!state.isJuso1Visible || !state.isJuso2Visible)
                              plusChipWidget(ref, homeController, jusoController1,
                                  jusoController2, state.isJuso1Visible , state.isJuso2Visible )
                          ],
                        ),
                      ))
              ],
            ),
          ),
        )
      ),
    );
  }

  //헤더 위젯
  Widget headerWidget(BuildContext context, bool isAvailable) {
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
        Text('재난 알림 지역 설정',
            style:
            DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800)),
        Spacer(),
        ValueListenableBuilder<bool>(
            valueListenable: isValueChangeNotifier,
            builder: (context, isChanged, builder) {
              return GestureDetector(
                onTap: () async {
                  if(isAvailable || isChanged) {
                    ref.read(myPageProvider.notifier).setJusoNick(jusoNickController1.text, jusoNickController2.text);
                    final isSuccess = await ref.read(myPageProvider.notifier).setAddressList();
                    showSnackbar(context, isSuccess);
                  }
                },
                child: Text('저장',
                    style: DaepiroTextStyle.body_1_m
                        .copyWith(color: isAvailable || isChanged ? DaepiroColorStyle.o_500 : DaepiroColorStyle.g_100)),
              );
            })
      ],
    );
  }

  /// 집 주소 관련 위젯

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

  //홈칩 + 주소 입력창
  Widget InputHomeAddress(
      TextEditingController homecontroller,
      BuildContext context,
      WidgetRef ref,
      String homeJuso,
      bool juso1Visible,
      bool juso2Visible,
      String userName) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          homeChipWidget(),
          SizedBox(height: 10),
          TextField(
            onTap: () {
              if(!isValueChangeNotifier.value) {
                isValueChangeNotifier.value = true;
              }
              GoRouter.of(context).push(
                '/onboarding/juso/집/0/${userName}',
                extra: {
                  'fromMyPage': true,
                },
              );
            },
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
                            myPageProvider.notifier)
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
      String userName,
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
                  .read(myPageProvider.notifier)
                  .checklocationControllerState(jusoNickController1, 1);
              setState(() {});
            },
            ref: ref,
            focusNode: nickFocusNode1,
            index: 1,
            onTapOutside: () {
              if(jusoNickController1.text.isEmpty) {
                ref.read(myPageProvider.notifier).controlJusoState(1);
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
              if (firstJusoState == 'Possible') {
                if(!isValueChangeNotifier.value) {
                  isValueChangeNotifier.value = true;
                }
                GoRouter.of(context)
                    .push(
                    '/onboarding/juso/${jusoNickController1.text}/1/${userName}',
                  extra: {
                    'fromMyPage': true,
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
                          .read(myPageProvider.notifier)
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
      String userName
      ) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationChip(
            controller: jusoNickController2,
            onChanged: (text) => ref.read(myPageProvider.notifier).checklocationControllerState(jusoNickController2, 2),
            ref: ref,
            focusNode: nickFocusNode2,
            index: 2,
            onTapOutside: () {
              if(jusoNickController2.text.isEmpty) {
                ref.read(myPageProvider.notifier).controlJusoState(2);
              }
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            style: DaepiroTextStyle.body_1_m.copyWith(color: DaepiroColorStyle.g_900),
            onTap: () {
              if (secondJusoState == 'Possible') {
                if(!isValueChangeNotifier.value) {
                  isValueChangeNotifier.value = true;
                }
                GoRouter.of(context)
                    .push(
                    '/onboarding/juso/${jusoNickController2.text}/2/${userName}',
                  extra: {
                    'fromMyPage': true,
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
                          .read(myPageProvider.notifier)
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
                  '*별명 설정은 필수입니다.',
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

  //지역 추가 칩
  Widget plusChipWidget(
      WidgetRef ref,
      TextEditingController homecontroller,
      TextEditingController jusoController1,
      TextEditingController jusoController2,
      bool juso1visible,
      bool juso2visible) {
    bool isButtonDisabled = ref
        .watch(myPageProvider.notifier)
        .checkPlusChipState(homecontroller.text, jusoController1.text, jusoController2.text,
        juso1visible, juso2visible);
    return SecondaryFilledButton(
      onPressed: () {
        if (!isButtonDisabled) {
          null;
        } else {
          if ((!juso1visible && !juso2visible) ||
              (!juso1visible && juso2visible)) {
            ref
                .read(myPageProvider.notifier)
                .setVisibleState(1, true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(nickFocusNode1);
            });
          } else if (juso1visible && !juso2visible) {
            ref
                .read(myPageProvider.notifier)
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

  /// 화면에서 쓰이는 다이얼로그

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