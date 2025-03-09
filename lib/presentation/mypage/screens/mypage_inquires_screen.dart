import 'package:daepiro/presentation/mypage/controller/mypage_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../cmm/DaepiroTheme.dart';
import '../../../cmm/button/primary_filled_button.dart';
import '../../../cmm/button/secondary_filled_button.dart';
import '../../const/utils.dart';

class MyPageInquiresScreen extends ConsumerStatefulWidget {
  @override
  MyPageInquiresState createState() => MyPageInquiresState();
}

class MyPageInquiresState extends ConsumerState<MyPageInquiresScreen> {
  final TextEditingController contentEditingController = TextEditingController();
  final TextEditingController mailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPageProvider);

    return PopScope(
      canPop: true,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            ref.read(myPageProvider.notifier).setInquireType('');
          }
        },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerWidget(),
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            '어떤 점이 궁금하신가요?',
                            style: DaepiroTextStyle.h6
                                .copyWith(color: DaepiroColorStyle.g_900),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    enableDrag: false,
                                    isDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [inquireTypeBottomSheet(state.inquireTypeList)],
                                      );
                                    });
                              },
                              child: inquireTypeWidget(state.inquireType)),
                          SizedBox(height: 16),
                          contentWriteWidget(),
                          SizedBox(height: 16),
                          Text(
                            '연락받을 메일 주소',
                            style: DaepiroTextStyle.body_1_m
                                .copyWith(color: DaepiroColorStyle.g_900),
                          ),
                          SizedBox(height: 8),
                          mailWriteWidget(),
                          SizedBox(height: 20)
                        ],
                      ),
                    )
                ),
                footerWidget(state.inquireType)
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget headerWidget() {
    return Container(
      width: double.infinity,
      child: Row(
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
              '문의하기',
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
    );
  }

  Widget inquireTypeWidget(String inquireType) {
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
            inquireType == ''
                ? Text(
              '문의 유형을 선택해주세요. (필수)',
              style: DaepiroTextStyle.body_1_m
                  .copyWith(color: DaepiroColorStyle.g_300),
            )
                : Text(
              inquireType,
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

  //문의유형 선택 bottomsheet 화면
  Widget inquireTypeBottomSheet(List<String> inquireTypeList) {
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
          inquireBoottmHeaderWidget(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    itemCount: inquireTypeList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SecondaryFilledButton(
                            verticalPadding: 16,
                            onPressed: () {
                              GoRouter.of(context).pop();
                              ref.read(myPageProvider.notifier).setInquireType(inquireTypeList[index]);
                            },
                            radius: 8,
                            backgroundColor: DaepiroColorStyle.white,
                            pressedColor: DaepiroColorStyle.g_50,
                            child: Row(
                              children: [
                                SizedBox(width: 16),
                                Text(
                                  textAlign: TextAlign.start,
                                  inquireTypeList[index],
                                  style: DaepiroTextStyle.body_1_m
                                      .copyWith(color: DaepiroColorStyle.g_900),
                                ),
                              ],
                            )),
                      );
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget inquireBoottmHeaderWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        child: Column(
          children: [
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
                    '문의 유형',
                    textAlign: TextAlign.center,
                    style: DaepiroTextStyle.body_1_b
                        .copyWith(color: DaepiroColorStyle.g_900),
                  ),
                ),
                GestureDetector(
                  onTap: () => GoRouter.of(context).pop(),
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
      ),
    );
  }

  Widget contentWriteWidget() {
    return Container(
        height: 341,
        child: Stack(
          children: [
            TextField(
              expands: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: 1000,
              style: DaepiroTextStyle.body_1_m
                  .copyWith(color: DaepiroColorStyle.g_900),
              cursorColor: DaepiroColorStyle.g_900,
              textAlignVertical: TextAlignVertical(y: -1),
              controller: contentEditingController,
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (text) {
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 16, left: 16, right: 16,bottom: 40),
                counterText: '',
                filled: true,
                isDense: true,
                fillColor: DaepiroColorStyle.g_50,
                hintText: '궁금한 사항을 구체적으로 작성해주세요.',
                hintStyle: DaepiroTextStyle.body_1_m
                    .copyWith(color: DaepiroColorStyle.g_200),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: DaepiroColorStyle.g_75,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
            Positioned(
                bottom: 16,
                right: 16,
                child: Text(
                  '${contentEditingController.text.length}/1000',
                  style: DaepiroTextStyle.body_1_m
                      .copyWith(color: DaepiroColorStyle.g_200),
                ))
          ],
        ));
  }

  Widget mailWriteWidget() {
    return Container(
      width: double.infinity,
      child: TextField(
        style:
        DaepiroTextStyle.body_1_m.copyWith(color: DaepiroColorStyle.g_900),
        keyboardType: TextInputType.emailAddress,
        cursorColor: DaepiroColorStyle.g_900,
        controller: mailEditingController,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          filled: true,
          fillColor: DaepiroColorStyle.g_50,
          hintText: 'example@domain.com',
          hintStyle: DaepiroTextStyle.body_1_m
              .copyWith(color: DaepiroColorStyle.g_200),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: DaepiroColorStyle.g_75,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }

  Widget footerWidget(String inquireType) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Container(
        width: double.infinity,
        child: PrimaryFilledButton(
            backgroundColor: mailEditingController.text.length > 0 &&
                contentEditingController.text.length > 0 && isEmailValid(mailEditingController.text) && inquireType != ''
                ? DaepiroColorStyle.g_700
                : DaepiroColorStyle.g_200,
            onPressed: () async {
              if (mailEditingController.text.length > 0 &&
                  contentEditingController.text.length > 0 &&
                  isEmailValid(mailEditingController.text) && inquireType != ''
              ) {
                await ref.read(myPageProvider.notifier).setInquires(contentEditingController.text, mailEditingController.text);
              } else {
                null;
              }
              GoRouter.of(context).pop();
            },
            pressedColor: DaepiroColorStyle.g_600,
            borderRadius: 8,
            child: Text(
              '접수하기',
              style: DaepiroTextStyle.body_1_b
                  .copyWith(color: DaepiroColorStyle.white),
            ),
            verticalPadding: 12),
      ),
    );
  }
}