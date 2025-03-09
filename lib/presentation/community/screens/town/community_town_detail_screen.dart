import 'dart:ui';

import 'package:daepiro/cmm/dialog/basic_dialog.dart';
import 'package:daepiro/presentation/mypage/controller/mypage_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../cmm/DaepiroTheme.dart';
import '../../../../cmm/button/secondary_filled_button.dart';
import '../../../../data/model/response/community/community_dongnae_content_detail_response.dart';
import '../../../const/utils.dart';
import '../../controller/community_town_view_model.dart';
import '../reply_menu_screen.dart';

class CommunityTownDetailScreen extends ConsumerStatefulWidget {
  final bool? fromMyPage;

  const CommunityTownDetailScreen({super.key, this.fromMyPage});

  @override
  CommunityTownDetailState createState() => CommunityTownDetailState();
}

class CommunityTownDetailState
    extends ConsumerState<CommunityTownDetailScreen> {
  TextEditingController replyController = TextEditingController();
  final scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    replyController.dispose();
    focusNode.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityTownProvider);

    if (state.isEditState) {
      focusNode.requestFocus();
    } else if (state.editChildCommentId != 0) {
      focusNode.requestFocus();
    }

    if (state.deleteArticle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        deleteDialog(context);
      });
    }

    return PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            FocusManager.instance.primaryFocus?.unfocus();
            ref.read(communityTownProvider.notifier).needToClearContent();
            if (widget.fromMyPage == null || !widget.fromMyPage!) {
              // 커뮤니티로부터 진입함
              ref.read(communityTownProvider.notifier).reloadContent();
            } else {
              //마이페이지로부터 진입함
              ref.read(myPageProvider.notifier).reloadMyArticles();
            }
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              behavior: HitTestBehavior.opaque,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: (state.contentDetail == ContentDetail() &&
                                  state.townReplyList == [] ||
                              state.selectContentId == null)
                          ? Text('데이터 로드중 오류가 발생했어요! 다시 시도해주세요.')
                          : Scrollbar(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          headerWidget(
                                              ContentCategory.getByValue(
                                                  state.contentDetail.category),
                                              context),
                                          SizedBox(height: 8),
                                          subHeaderWidget(
                                              state.contentDetail, ref),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Visibility(
                                              visible:
                                                  state.contentDetail.address !=
                                                      '',
                                              child: addressChip(
                                                  state.contentDetail.address)),
                                          const SizedBox(height: 8),
                                          contentWidget(state.contentDetail),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () async {
                                                await ref
                                                    .read(communityTownProvider
                                                        .notifier)
                                                    .setArticleLike();
                                              },
                                              child: likeButton(
                                                  state.contentDetail.isLiked,
                                                  state.contentDetail
                                                      .likeCount)),
                                          //Spacer()
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: DaepiroColorStyle.g_50),
                                      width: double.infinity,
                                      height: 4,
                                    ),
                                    if (state.isDongNaeLoading)
                                      Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 0),
                                        child: replyListWidget(
                                            state.townReplyList,
                                            state.isEditState,
                                            state.editCommentId,
                                            state.isChildCommentState,
                                            state.editChildCommentId,
                                            state.isEditChildCommentState),
                                      )
                                  ],
                                ),
                              ),
                            ),
                    ),
                    footerWidget(
                        replyController,
                        focusNode,
                        context,
                        state.isEditState,
                        state.isChildCommentState,
                        state.parentCommentId,
                        state.isEditChildCommentState)
                  ],
                ),
              ),
            )));
  }

  //헤더 위젯
  Widget headerWidget(String category, BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: GestureDetector(
            onTap: () async {
              GoRouter.of(context).pop();
            },
            child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)),
          ),
        ),
        Expanded(
            child: Center(
          child: Text(
            category,
            style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800),
          ),
        )),
        SizedBox(
          width: 24,
        )
      ],
    );
  }

  Widget subHeaderWidget(ContentDetail content, WidgetRef ref) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DaepiroColorStyle.g_50,
              border: Border.all(width: 1, color:DaepiroColorStyle.g_50)
            ),
            child: ClipOval(
              child: Image.network(
                content.authorUser.profileImageUrl,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(content.authorUser.nickname,
                    style: DaepiroTextStyle.body_2_b
                        .copyWith(color: DaepiroColorStyle.g_800)),
                Visibility(
                  visible: content.authorUser.isVerified,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: SvgPicture.asset(
                        'assets/icons/icon_town_certificate.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                            DaepiroColorStyle.o_300, BlendMode.srcIn)),
                  ),
                ),
              ]),
              const SizedBox(height: 2),
              Row(
                children: [
                  Visibility(
                      visible: content.lastModifiedAt != content.createdAt!,
                      child: Text(
                        '수정됨 · ',
                        style: DaepiroTextStyle.caption
                            .copyWith(color: DaepiroColorStyle.g_300),
                      )),
                  Text(
                      content.lastModifiedAt == content.createdAt
                          ? parseRegTime(content.createdAt)
                          : parseRegTime(content.lastModifiedAt),
                      style: DaepiroTextStyle.caption
                          .copyWith(color: DaepiroColorStyle.g_300))
                ],
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () =>
                articleGoToAdditional(context, content.isMine, content.id),
            child: SvgPicture.asset('assets/icons/icon_more.svg',
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(DaepiroColorStyle.g_200, BlendMode.srcIn)),
          ),
        ],
      ),
    );
  }

  //게시글 수정삭제를 위한 메소드
  void articleGoToAdditional(BuildContext context, bool isUser, int id) {
    showDialog(
        useSafeArea: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (context) {
          return ReplyMenuScreen(
              isUser: isUser,
              id: id,
              deleteComment: () async {},
              isChildCommentState: false,
              isArticle: true,
              deleteArticle: () => ref
                  .read(communityTownProvider.notifier)
                  .setArticleDeleteState(true),
              fromMyPage: widget.fromMyPage);
        });
  }

  //댓글 수정 삭제를 위한 blur 화면 띄우는 메소드
  void goToAdditional(
      BuildContext context, bool isUser, int id, bool isChildCommentState) {
    showDialog(
        useSafeArea: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (context) {
          return PopScope(
              onPopInvoked: (bool didPop) {
                if (didPop) {
                  if (isChildCommentState) {
                    ref
                        .read(communityTownProvider.notifier)
                        .setChildCommentState(false);
                  }
                }
              },
              child: ReplyMenuScreen(
                isUser: isUser,
                id: id,
                deleteComment: () async {
                  await ref
                      .read(communityTownProvider.notifier)
                      .deleteReply(id);
                },
                isChildCommentState: isChildCommentState,
                isArticle: false,
                fromMyPage: widget.fromMyPage,
              ));
        });
  }

  void deleteDialog(BuildContext context) {
    BasicDialog.show(
      context,
      titleWidget: Text('게시물을 삭제하시겠어요?',
          style: DaepiroTextStyle.body_1_b
              .copyWith(color: DaepiroColorStyle.g_900)),
      contentWidget: Container(),
      doneWidget: SecondaryFilledButton(
          verticalPadding: 12,
          onPressed: () {
            GoRouter.of(context).pop();
            ref
                .read(communityTownProvider.notifier)
                .setArticleDeleteState(false);
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
      actionWidget: SecondaryFilledButton(
          verticalPadding: 12,
          onPressed: () async {
            GoRouter.of(context).pop();
            ref
                .read(communityTownProvider.notifier)
                .setArticleDeleteState(false);
            final isSuccess =
                await ref.read(communityTownProvider.notifier).deleteArticle();
            showSnackbar(context, isSuccess);
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
    );
  }

  Widget contentWidget(ContentDetail content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content.title ?? '',
          style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_900),
        ),
        const SizedBox(height: 8),
        Text(
          content.body ?? '',
          style: DaepiroTextStyle.body_2_m
              .copyWith(color: DaepiroColorStyle.g_400),
        ),
        content.files.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 118,
                  child: ListView.builder(
                      itemCount: content.files.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push(
                                '/community_photo_screen',
                              extra: content.files
                            );
                          },
                          child: Container(
                            width: 118,
                            margin: EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                content.files[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget likeButton(bool isClick, int likeNum) {
    return Container(
      decoration: BoxDecoration(
          color: isClick ? DaepiroColorStyle.o_50 : DaepiroColorStyle.g_50,
          borderRadius: BorderRadius.circular(99)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/icon_good.svg',
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                    isClick ? DaepiroColorStyle.o_400 : DaepiroColorStyle.g_300,
                    BlendMode.srcIn)),
            SizedBox(width: 2),
            Text(
              '좋아요',
              style: DaepiroTextStyle.caption.copyWith(
                  color: isClick
                      ? DaepiroColorStyle.o_400
                      : DaepiroColorStyle.g_300),
            ),
            SizedBox(width: 2),
            Visibility(
              visible: likeNum > 0,
              child: Text(
                '${likeNum}',
                style: DaepiroTextStyle.caption.copyWith(
                    color: isClick
                        ? DaepiroColorStyle.o_400
                        : DaepiroColorStyle.g_300),
              ),
            )
          ],
        ),
      ),
    );
  }

  //댓글 리스트 위젯
  Widget replyListWidget(
      List<CommentData> list,
      bool isTownEditState,
      int editTownCommentId,
      bool isTownChildCommentState,
      int editTownChildCommentId,
      bool isEditChildCommentState) {
    return Container(
        width: double.infinity,
        child: Column(
          children: List.generate(list.length, (index) {
            return replyWidget(
                list[index],
                isTownEditState,
                editTownCommentId,
                isTownChildCommentState,
                editTownChildCommentId,
                isEditChildCommentState);
          }),
        ));
  }

  //대댓글 리스트 위젯들
  Widget reReplyListWidget(bool isEditChildCommentState, int editChildCommentId,
      List<Children> list, bool isChildCommentState) {
    return Container(
      width: double.infinity,
      child: Column(
        children: List.generate(list.length, (index) {
          return Column(
            children: [
              reReplyWidget(isEditChildCommentState, editChildCommentId,
                  list[index], isChildCommentState),
              SizedBox(height: 8)
            ],
          );
        }),
      ),
    );
  }

  //댓글 아이템 위젯
  Widget replyWidget(
      CommentData comment,
      bool isEditState,
      int editCommentId,
      bool isChildCommentState,
      int editChildCommentId,
      bool isEditChildCommentState) {
    if(editCommentId == comment.id) {
      replyController.text = comment.body!;
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: isEditState && editCommentId == comment.id
              ? DaepiroColorStyle.g_50
              : DaepiroColorStyle.white,
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  comment.author?.nickname ?? '탈퇴한 사용자',
                  style: DaepiroTextStyle.caption
                      .copyWith(color: DaepiroColorStyle.g_800),
                ),
                Visibility(
                    visible: comment.author?.isVerified ?? false,
                    child: Row(
                      children: [
                        SizedBox(width: 2),
                        SvgPicture.asset(
                            'assets/icons/icon_town_certificate.svg',
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                                DaepiroColorStyle.o_300, BlendMode.srcIn)),
                      ],
                    )),
                SizedBox(width: 6),
                Visibility(
                  visible: comment.createdAt != comment.lastModifiedAt,
                  child: Text(
                    '수정됨 · ',
                    style: DaepiroTextStyle.caption
                        .copyWith(color: DaepiroColorStyle.g_300),
                  ),
                ),
                Text(
                  parseRegTime(comment.lastModifiedAt!),
                  style: DaepiroTextStyle.caption
                      .copyWith(color: DaepiroColorStyle.g_300),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    goToAdditional(context, comment.isMine ?? false,
                        comment.id!, isChildCommentState);
                  },
                  child: Visibility(
                    visible: comment.deletedAt == null,
                    child: SvgPicture.asset('assets/icons/icon_moreinfo.svg',
                        colorFilter: ColorFilter.mode(
                            DaepiroColorStyle.g_200, BlendMode.srcIn)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              //editCommentId == comment.id ? '수정중' : comment.body!,
              comment.body!,
              style: DaepiroTextStyle.body_2_m
                  .copyWith(color: DaepiroColorStyle.g_900),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      await ref
                          .read(communityTownProvider.notifier)
                          .replyLike(comment.id!);
                    },
                    child: likeButton(
                        comment.isLiked ?? false, comment.likeCount!)),
                SizedBox(width: 8),
                GestureDetector(
                    onTap: () {
                      ref
                          .read(communityTownProvider.notifier)
                          .setChildCommentState(true);
                      ref
                          .read(communityTownProvider.notifier)
                          .setParentCommentId(comment.id!);
                      focusNode.requestFocus();
                    },
                    child: replyWriteButton())
              ],
            ),
            SizedBox(height: 8),
            if (comment.children != [])
              IntrinsicHeight(
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 4,
                        decoration:
                            BoxDecoration(color: DaepiroColorStyle.g_75),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: reReplyListWidget(
                        isEditChildCommentState,
                        editChildCommentId,
                        comment.children!,
                        isChildCommentState,
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  //대댓글 아이템 위젯
  Widget reReplyWidget(
    bool isTownEditChildCommentState,
    int editTownChildCommentId,
    Children childComment,
    bool isChildCommentState,
  ) {
    if(editTownChildCommentId == childComment.id) {
      replyController.text = childComment.body!;
    }
    return Container(
        decoration: BoxDecoration(
          color: isTownEditChildCommentState &&
                  editTownChildCommentId == childComment.id
              ? DaepiroColorStyle.g_50
              : DaepiroColorStyle.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    childComment.author?.nickname ?? '탈퇴한 사용자',
                    style: DaepiroTextStyle.caption
                        .copyWith(color: DaepiroColorStyle.g_800),
                  ),
                  Visibility(
                      visible: childComment.author?.isVerified ?? false,
                      child: Row(
                        children: [
                          SizedBox(width: 2),
                          SvgPicture.asset(
                              'assets/icons/icon_town_certificate.svg',
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                  DaepiroColorStyle.o_300, BlendMode.srcIn)),
                        ],
                      )),
                  SizedBox(width: 6),
                  Visibility(
                    visible: childComment.createdAt != childComment.lastModifiedAt,
                    child: Text(
                      '수정됨 · ',
                      style: DaepiroTextStyle.caption
                          .copyWith(color: DaepiroColorStyle.g_300),
                    ),
                  ),
                  Text(
                    parseRegTime(childComment.lastModifiedAt!),
                    style: DaepiroTextStyle.caption
                        .copyWith(color: DaepiroColorStyle.g_300),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        ref
                            .read(communityTownProvider.notifier)
                            .setChildCommentState(true);
                        goToAdditional(context, childComment.isMine ?? false,
                            childComment.id!, isChildCommentState);
                      },
                      child: SvgPicture.asset('assets/icons/icon_moreinfo.svg',
                          colorFilter: ColorFilter.mode(
                              DaepiroColorStyle.g_200, BlendMode.srcIn))),
                ],
              ),
              SizedBox(height: 4),
              Text(
                childComment.body!,
                style: DaepiroTextStyle.body_2_m
                    .copyWith(color: DaepiroColorStyle.g_900),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        await ref
                            .read(communityTownProvider.notifier)
                            .replyLike(childComment.id!);
                      },
                      child: likeButton(childComment.isLiked ?? false,
                          childComment.likeCount ?? 0)),
                  Spacer()
                ],
              ),
            ],
          ),
        ));
  }

  Widget replyWriteButton() {
    return Container(
      decoration: BoxDecoration(
          color: DaepiroColorStyle.g_50,
          borderRadius: BorderRadius.circular(99)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/icon_community.svg',
                width: 16,
                height: 16,
                colorFilter:
                    ColorFilter.mode(DaepiroColorStyle.g_300, BlendMode.srcIn)),
            SizedBox(width: 2),
            Text(
              '답글쓰기',
              style: DaepiroTextStyle.caption
                  .copyWith(color: DaepiroColorStyle.g_300),
            )
          ],
        ),
      ),
    );
  }

  Widget footerWidget(
      TextEditingController controller,
      FocusNode focusNode,
      BuildContext context,
      bool isEditState,
      bool isChildCommentState,
      int parentCommentId,
      bool isEditChildCommentState) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: DaepiroColorStyle.g_50))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            SizedBox(width: 20),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: DaepiroColorStyle.g_50),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    maxLength: 1000,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    focusNode: focusNode,
                    controller: controller,
                    cursorColor: DaepiroColorStyle.g_900,
                    style: DaepiroTextStyle.body_2_m
                        .copyWith(color: DaepiroColorStyle.g_900),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      isDense: true,
                      hintText: '댓글을 작성해주세요.',
                      fillColor: DaepiroColorStyle.g_50,
                      hintStyle: DaepiroTextStyle.body_2_m
                          .copyWith(color: DaepiroColorStyle.g_200),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  )),
                  SizedBox(width: 12),
                  TextButton(
                    onPressed: () async {
                      if (isEditState) {
                        //수정하기 상태
                        ref
                            .read(communityTownProvider.notifier)
                            .setEditState(false);
                        await ref
                            .read(communityTownProvider.notifier)
                            .editReply(controller.text);
                        ref.read(communityTownProvider.notifier).setReplyId(0);
                      } else if (isChildCommentState) {
                        //대댓글을 수정, 작성 하려는 상태
                        if (parentCommentId != 0) {
                          //대댓글을 작성 상태(답글쓰기)
                          ref
                              .read(communityTownProvider.notifier)
                              .setParentCommentId(0);
                          await ref
                              .read(communityTownProvider.notifier)
                              .setReplyComment(
                                  controller.text, parentCommentId);
                        } else if (isEditChildCommentState) {
                          //대댓글을 수정하려는 상태
                          ref
                              .read(communityTownProvider.notifier)
                              .setEditState(false);
                          await ref
                              .read(communityTownProvider.notifier)
                              .editReply(controller.text);
                          ref
                              .read(communityTownProvider.notifier)
                              .setReplyId(0);
                        }
                        ref
                            .read(communityTownProvider.notifier)
                            .setChildCommentState(false);
                      } else {
                        //일반 댓글 작성의 경우
                        await ref
                            .read(communityTownProvider.notifier)
                            .setComment(controller.text);
                      }
                      controller.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1)),
                        overlayColor: Colors.transparent),
                    child: Text('등록',
                        style: DaepiroTextStyle.body_2_m
                            .copyWith(color: DaepiroColorStyle.g_600)),
                  ),
                ],
              ),
            )),
            SizedBox(width: 20)
          ],
        ),
      ),
    );
  }

  Widget addressChip(String address) {
    return Container(
      decoration: BoxDecoration(
          color: DaepiroColorStyle.o_50,
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Text(
          '${address}에서 작성한 글',
          style:
              DaepiroTextStyle.caption.copyWith(color: DaepiroColorStyle.o_500),
        ),
      ),
    );
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
                        isSuccess ? '게시글이 삭제되었어요.' : '다시 시도해주세요.',
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
