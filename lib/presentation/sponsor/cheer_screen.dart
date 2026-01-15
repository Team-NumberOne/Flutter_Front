import 'package:daepiro/presentation/sponsor/component/cheer_comment_menu.dart';
import 'package:daepiro/presentation/sponsor/component/item_cheer_comment.dart';
import 'package:daepiro/presentation/sponsor/sponsor_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../cmm/theme/DaepiroTheme.dart';

class CheerScreen extends ConsumerStatefulWidget {
  const CheerScreen({super.key});

  @override
  _CheerScreenState createState() => _CheerScreenState();
}

class _CheerScreenState extends ConsumerState<CheerScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isFocused = false;

  // @override
  // void initState() {
  //   super.initState();
  //   focusNode.addListener(() {
  //     setState(() {
  //       isFocused = focusNode.hasFocus;
  //     });
  //   });
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    focusNode.removeListener(() {
      setState(() {
        isFocused = false;
      });
    });
    textEditingController.removeListener(() {});
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(sponsorStateNotifierProvider);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFC7B4), // 연한 핑크색
                Colors.white, // 흰색
              ],
              stops: [0, 0.3], // 30%에서 색이 변경됨
            ),
          ),
          child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(top: 4, bottom: 4, left: 12),
                        child: SvgPicture.asset('assets/icons/icon_arrow_left.svg'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      child: Text(
                        "응원의 한마디",
                        style: DaepiroTextStyle.h6.copyWith(
                          color: DaepiroColorStyle.g_800,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/sponsor_heart.gif',
                      width: 178,
                      height: 178,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 4),
                    Text(
                        "응원이 필요한 이웃에게\n따뜻한 한마디를 전달해보세요",
                        style: DaepiroTextStyle.h6.copyWith(
                          color: DaepiroColorStyle.g_900,
                        ),
                        textAlign: TextAlign.center
                    ),
                    const SizedBox(height: 6),
                    Text(
                        "메시지는 후원 페이지 상단 배너에 노출돼요.",
                        style: DaepiroTextStyle.body_2_m.copyWith(
                          color: DaepiroColorStyle.g_400,
                        ),
                        textAlign: TextAlign.center
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: viewModel.cheerCommentList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            if (index == 0)
                              const SizedBox(height: 12),
                            ItemCheerComment(
                                key: ValueKey(viewModel.cheerCommentList[index].id),
                                name: viewModel.cheerCommentList[index].author ?? "",
                                date: viewModel.cheerCommentList[index].time ?? "",
                                contents: viewModel.cheerCommentList[index].content ?? "",
                                onClickMenu: () {
                                  showCommentMenu(
                                      context,
                                      ref,
                                      viewModel.cheerCommentList[index].isMine ?? false,
                                      viewModel.cheerCommentList[index].id ?? 0
                                  );

                                  isFocused = false;
                                  FocusScope.of(context).unfocus();
                                },
                                isMine: viewModel.cheerCommentList[index].isMine ?? false
                            ),
                          ],
                        );
                      }
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: DaepiroColorStyle.g_50,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: DaepiroColorStyle.g_50,
                        borderRadius: BorderRadius.circular(12),
                        border: isFocused
                            ? Border.all(color: DaepiroColorStyle.g_75, width: 1.5)
                            : Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              maxLength: 10,
                              style: DaepiroTextStyle.body_2_m.copyWith(
                                color: DaepiroColorStyle.g_900,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: DaepiroColorStyle.g_50,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                hintText: "여러분의 메시지를 전해보세요.(최대 10자)",
                                hintStyle: DaepiroTextStyle.body_2_m.copyWith(
                                  color: DaepiroColorStyle.g_200,
                                ),
                                counterText: "",
                              ),
                              onChanged: (text) {
                                // textEditingController.text = text;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                ref.read(sponsorStateNotifierProvider.notifier).writeCheerMessage(textEditingController.text);
                                textEditingController.clear();
                                isFocused = false;
                                FocusScope.of(context).unfocus();
                              }

                              _scrollController.animateTo(
                                0.0, // 최상단
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                "등록",
                                style: DaepiroTextStyle.body_2_m.copyWith(
                                  color: DaepiroColorStyle.g_600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ]
          ),
        ),
      ),
    );
  }

  void showCommentMenu(
      BuildContext context,
      WidgetRef ref,
      bool isMine,
      int id
    ) {
    showDialog(
        useSafeArea: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (context) {
          return CheerCommentMenu(
            isMine: isMine,
            id: id,
            onClickDelete: () {
              ref.read(sponsorStateNotifierProvider.notifier)
                  .deleteCheerMessage(id: id.toString());
              // ref.read(sponsorStateNotifierProvider.notifier)
              //     .setDeleteState(id)
            },
          );
        }
    );
  }
}