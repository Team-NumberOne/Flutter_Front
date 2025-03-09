import 'dart:ui';
import 'package:daepiro/presentation/community/controller/community_disaster_view_model.dart';
import 'package:daepiro/presentation/community/controller/community_town_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/DaepiroTheme.dart';
import '../../../cmm/button/secondary_filled_button.dart';

//수정하기 & 삭제하기
class ReplyMenuScreen extends ConsumerWidget {
  final bool isUser;
  final int id;
  final Future<void> Function() deleteComment;
  final bool isChildCommentState;
  final bool isArticle;
  final void Function()? deleteArticle;
  final bool? fromMyPage;

  const ReplyMenuScreen({
    super.key,
    required this.isUser,
    required this.id,
    required this.deleteComment,
    required this.isChildCommentState,
    required this.isArticle,
    this.deleteArticle,
    this.fromMyPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityDisasterProvider);
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: isUser
                ? editMenu(context, ref, id, isChildCommentState,
                    state.isDisasterScreen, isArticle, fromMyPage)
                : reportMenu(context, ref, id, isArticle)),
      ],
    );
  }

  Widget editMenu(
    BuildContext context,
    WidgetRef ref,
    int commentId,
    bool isChildCommentState,
    bool isDisasterScreen,
    bool isArticle,
    bool? fromMyPage,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if(fromMyPage == true || !isDisasterScreen) {
              if (isArticle) {
                GoRouter.of(context).push(
                  '/community_town_writing',
                  extra: {
                    'isEdit': true,
                    'contentDetail':
                    ref.read(communityTownProvider).contentDetail,
                  },
                );
              } else {
                //게시글 수정을 위한 화면으로 가야함
                ref.read(communityTownProvider.notifier).setEditState(true);
                ref.read(communityTownProvider.notifier).setReplyId(commentId);
              }
            } else if(isDisasterScreen) {
              ref.read(communityDisasterProvider.notifier).setEditState(true);
              ref
                  .read(communityDisasterProvider.notifier)
                  .setReplyId(commentId);
            }
            GoRouter.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: DaepiroColorStyle.g_50,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: DefaultTextStyle(
                  style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_700),
                  child: Text(
                    '수정하기',
                    textAlign: TextAlign.center
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        GestureDetector(
            onTap: () {
              if (isArticle && deleteArticle != null) {
                GoRouter.of(context).pop();
                deleteArticle!();
              } else {
                GoRouter.of(context).pop();
                deleteDialog(context, deleteComment, isArticle);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: DaepiroColorStyle.g_50,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: DefaultTextStyle(
                    style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_700),
                    child: Text(
                      '삭제하기',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget reportMenu(
      BuildContext context, WidgetRef ref, int commentId, bool isArticle) {
    return GestureDetector(
        onTap: () {
          GoRouter.of(context)
              .push('/community_report_screen/$commentId/$isArticle');
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: DaepiroColorStyle.g_50,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: DefaultTextStyle(
                  style:DaepiroTextStyle.body_1_b
                    .copyWith(color: DaepiroColorStyle.g_700),
                  child: Text(
                    '신고하기',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // ),
            )));
  }

  void deleteDialog(BuildContext context, Future<void> Function() deleteComment,
      bool isArticle) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: Colors.white,
            titlePadding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '댓글을 삭제하시겠어요?',
                  style: DaepiroTextStyle.body_1_b
                      .copyWith(color: DaepiroColorStyle.g_900),
                )
              ],
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: SecondaryFilledButton(
                        verticalPadding: 12,
                        onPressed: () {
                          Navigator.pop(context);
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
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: SecondaryFilledButton(
                        verticalPadding: 12,
                        onPressed: () async {
                          GoRouter.of(context).pop();
                          showDeleteSnackbar(context);
                          if (isArticle) {
                          } else {
                            await deleteComment();
                          }
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

  void showDeleteSnackbar(BuildContext context) {
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
                        '댓글이 삭제되었어요.',
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
