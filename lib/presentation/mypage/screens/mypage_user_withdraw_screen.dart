import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/button/primary_filled_button.dart';
import '../../../cmm/widget/button/secondary_filled_button.dart';
import '../controller/mypage_viewmodel.dart';

class MyPageUserWithDrawScreen extends ConsumerWidget {
  const MyPageUserWithDrawScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myPageProvider);
    final viewModel = ref.read(myPageProvider.notifier);

    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          viewModel.setLeaveType('');
        }
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: backgroundWidget(context)
                  ),
                  Positioned(
                      top: MediaQuery.of(context).padding.top,
                      right: 20,
                      left: 20,
                      child: Column(
                        children: [
                          IntrinsicHeight(child: headerWidget(context, state.nickName)),
                        ],
                      )
                  ),
                  Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Image.asset('assets/icons/icon_withdraw.png', height: 182, width: 182,)
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32),
                        Text('탈퇴 전, 확인해주세요.', style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_900)),
                        SizedBox(height: 16),
                        checkWidget(),
                        SizedBox(height: 32),
                        Text('대피로를 떠나는 이유가 궁금해요.', style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_900)),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                enableDrag: false,
                                isDismissible: true,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Wrap(
                                      children: [leaveTypeBottomSheet(state.leaveTypeList, context, ref)]
                                  );
                                });
                          },
                          child: leaveTypeWidget(state.leaveType),
                        ),
                        SizedBox(height: 35),
                      ],
                    ),
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: bottomWidget(context, ref),
            )
          ],
        ),
      ),
    );
  }

  Widget backgroundWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
           Color(0xfffff0ea),
            Color(0xffffd7c6),
          ]
        )
      ),
    );
  }

  Widget headerWidget(BuildContext context, String userNickName) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: GestureDetector(
                  onTap: () => GoRouter.of(context).pop(),
                  child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                          DaepiroColorStyle.g_900, BlendMode.srcIn)),
                ),
              ),
              Expanded(
                child: Text(
                  '회원탈퇴',
                  textAlign: TextAlign.center,
                  style:
                  DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800),
                ),
              ),
              Container(
                width: 24,
                height: 24,
              )
            ],
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 57),
              child: Text(
                '${userNickName}님,\n정말 대피로를 떠나시나요? 너무 아쉬워요..',
                textAlign: TextAlign.center,
                style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_900),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget checkWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: DaepiroColorStyle.g_50,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/icons/icon_certification.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                    DaepiroColorStyle.o_400, BlendMode.srcIn)),
            SizedBox(width: 10),
            Expanded(child: Text('모든 회원 정보와 활동내역이 사라질 수 있어요!', style: DaepiroTextStyle.body_2_b.copyWith(color: DaepiroColorStyle.g_900))),
          ],
        ),
      ),
    );
  }

  Widget leaveTypeWidget(String leaveType) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: DaepiroColorStyle.g_50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            leaveType == ''
                ? Text(
              '선택해주세요.',
              style: DaepiroTextStyle.body_1_m
                  .copyWith(color: DaepiroColorStyle.g_300),
            )
                : Text(
              leaveType,
              style: DaepiroTextStyle.body_1_m
                  .copyWith(color: DaepiroColorStyle.g_900),
            ),
            Spacer(),
            SvgPicture.asset('assets/icons/icon_arrow_down.svg',
                colorFilter:
                ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)),
          ],
        ),
      ),
    );
  }

  Widget leaveBoottmHeaderWidget(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              SizedBox(width: 16),
              Opacity(
                opacity: 0.0,
                child: SvgPicture.asset(
                  'assets/icons/icon_close.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              Expanded(
                child: Text(
                  '탈퇴 이유',
                  textAlign: TextAlign.center,
                  style: DaepiroTextStyle.body_1_b
                      .copyWith(color: DaepiroColorStyle.g_900),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset('assets/icons/icon_close.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                        DaepiroColorStyle.g_900, BlendMode.srcIn)),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: DaepiroColorStyle.g_50),
            width: double.infinity,
            height: 1,
          )
        ],
      ),
    );
  }

  Widget leaveTypeBottomSheet(List<String> leaveTypeList, BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leaveBoottmHeaderWidget(context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                  itemCount: leaveTypeList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SecondaryFilledButton(
                          verticalPadding: 16,
                          onPressed: () {
                            ref.read(myPageProvider.notifier).setLeaveType(leaveTypeList[index]);
                            GoRouter.of(context).pop();
                          },
                          radius: 8,
                          backgroundColor: DaepiroColorStyle.white,
                          pressedColor: DaepiroColorStyle.g_50,
                          child: Row(
                            children: [
                              SizedBox(width: 16),
                              Text(
                                textAlign: TextAlign.start,
                                leaveTypeList[index],
                                style: DaepiroTextStyle.body_1_m
                                    .copyWith(color: DaepiroColorStyle.g_900),
                              ),
                            ],
                          )),
                    );
                  })
            ],
          )
        ],
      ),
    );
  }

  Widget bottomWidget(BuildContext context, WidgetRef ref) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                  child: PrimaryFilledButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    backgroundColor: DaepiroColorStyle.o_500,
                    pressedColor: DaepiroColorStyle.o_600,
                    borderRadius: 8,
                    child: Text(
                      '돌아가기',
                      style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.white),
                    ),
                    verticalPadding: 12,
                  ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PrimaryFilledButton(
                    onPressed: () async {
                      await ref.read(myPageProvider.notifier).deleteUserAccount();
                      withDrawDialog(context);
                    },
                    backgroundColor: DaepiroColorStyle.g_50,
                    pressedColor: DaepiroColorStyle.g_75,
                    borderRadius: 8.0,
                    disabledColor: DaepiroColorStyle.g_50,
                    child: Text(
                      '탈퇴하기',
                      style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_700),
                    ),
                    verticalPadding: 12
                ),
              ),
            ],
          ),
        )
    );
  }

  void withDrawDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: DaepiroColorStyle.white,
            titlePadding: EdgeInsets.fromLTRB(20, 24, 20, 24),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '탈퇴가 완료되었어요',
                  style: DaepiroTextStyle.body_1_b
                      .copyWith(color: DaepiroColorStyle.g_900),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: PrimaryFilledButton(
                        verticalPadding: 12,
                        onPressed: () {
                          if(Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else {
                            exit(0);
                          }
                        },
                        backgroundColor: DaepiroColorStyle.g_700,
                        pressedColor: DaepiroColorStyle.g_600,
                        borderRadius: 8,
                        child: Text(
                          textAlign: TextAlign.center,
                          '종료하기',
                          style: DaepiroTextStyle.body_1_b
                              .copyWith(color: DaepiroColorStyle.white),
                        )),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

}