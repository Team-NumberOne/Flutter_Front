import 'package:daepiro/cmm/theme/DaepiroTheme.dart';
import 'package:daepiro/presentation/mypage/controller/mypage_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MyPageFixUserinfoScreen extends ConsumerStatefulWidget {
  const MyPageFixUserinfoScreen({super.key});

  @override
  MyPageFixUserinfoState createState() => MyPageFixUserinfoState();
}

class MyPageFixUserinfoState extends ConsumerState<MyPageFixUserinfoScreen> {
  final TextEditingController nicknameController = new TextEditingController();
  final ValueNotifier<bool> isValueChangeNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(myPageProvider);
      nicknameController.text = state.nickName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPageProvider);
    final viewModel = ref.read(myPageProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if(didPop) {
          viewModel.clearState();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerWidget(context, ref, state.completeSetNickName),
                SizedBox(height: 8),
                Text('닉네임', style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_900)),
                SizedBox(height: 8),
                nickNameTextField(nicknameController, state.nicknameState),
                if (state.nicknameState != '')
                  nickNamestateText(state.nicknameState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //헤더 위젯
  Widget headerWidget(BuildContext context, WidgetRef ref, bool isAvailable) {
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
        Text('프로필 수정',
            style:
                DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800)),
        Spacer(),
        ValueListenableBuilder<bool>(
            valueListenable: isValueChangeNotifier,
            builder: (context, isChanged, child) {
              return GestureDetector(
                onTap: () async {
                  if(isChanged && isAvailable) {
                    await ref.read(myPageProvider.notifier).setMyProfiles('홍길동', nicknameController.text);
                    ref.read(myPageProvider.notifier).getMyProfiles();
                    GoRouter.of(context).pop();
                  }
                },
                child: Text('저장',
                    style: DaepiroTextStyle.body_1_m
                        .copyWith(color: isChanged && isAvailable ? DaepiroColorStyle.o_500 : DaepiroColorStyle.g_100)),
              );
            }
        )
      ],
    );
  }

  //이름 입력란
  // Widget nameTextField(TextEditingController controller, String nameState) {
  //   return Stack(
  //     children: [
  //       TextField(
  //           controller: controller,
  //           onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
  //           onChanged: (text) {
  //             ref.read(myPageProvider.notifier).setNameState(text);
  //             setState(() {});
  //             if(!isValueChangeNotifier.value) {
  //               isValueChangeNotifier.value = true;
  //             }
  //           },
  //           style: DaepiroTextStyle.body_1_m.copyWith(
  //               color: DaepiroColorStyle.g_900, decorationThickness: 0),
  //           decoration: InputDecoration(
  //             filled: true,
  //             isDense: true,
  //             contentPadding: EdgeInsets.all(16),
  //             fillColor: DaepiroColorStyle.g_50,
  //             focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(4)),
  //                 borderSide:
  //                     BorderSide(
  //                         width: 1.5,
  //                         color: nameState != '' ? DaepiroColorStyle.r_300 : DaepiroColorStyle.g_75)),
  //             enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(4)),
  //                 borderSide:
  //                     BorderSide(width: 1, color: DaepiroColorStyle.g_50)),
  //             suffixIcon: Padding(
  //               padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  //               child: SvgPicture.asset('assets/icons/icon_edit.svg',
  //                   width: 24,
  //                   height: 24,
  //                   colorFilter: ColorFilter.mode(
  //                       DaepiroColorStyle.g_200, BlendMode.srcIn)),
  //             ),
  //           ))
  //     ],
  //   );
  // }

  //닉네임 입력란
  Widget nickNameTextField(TextEditingController controller, String nickNameState) {
    return Stack(
      children: [
        TextField(
            controller: controller,
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            onChanged: (text) async {
              if(!isValueChangeNotifier.value) {
                isValueChangeNotifier.value = true;
              }
              await ref.read(myPageProvider.notifier).setNickNameState(text);
              setState(() {});
            },
            style: DaepiroTextStyle.body_1_m.copyWith(
                color: DaepiroColorStyle.g_900, decorationThickness: 0),
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(16),
              fillColor: DaepiroColorStyle.g_50,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide:
                  BorderSide(
                      width: 1.5,
                      color: setBorderColor(nickNameState))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide:
                  BorderSide(width: 1, color: DaepiroColorStyle.g_50)),
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: SvgPicture.asset('assets/icons/icon_edit.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                        DaepiroColorStyle.g_200, BlendMode.srcIn)),
              ),
            ))
      ],
    );
  }

  //이메일 입력란
  // Widget emailTextField(String platform) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       color: DaepiroColorStyle.g_50
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Text(PlatformCategory.getCategoryByKeyword(platform), style: DaepiroTextStyle.body_1_m.copyWith(color: DaepiroColorStyle.g_200)),
  //         ],
  //       ),
  //     )
  //   );
  // }

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

  Color setBorderColor(String nickNameState) {
    if (nickNameState == '') {
      return DaepiroColorStyle.g_75;
    } else if (nickNameState != '*사용 가능한 닉네임 입니다.') {
      return DaepiroColorStyle.r_300;
    } else {
      return DaepiroColorStyle.g_75;
    }
  }
}
