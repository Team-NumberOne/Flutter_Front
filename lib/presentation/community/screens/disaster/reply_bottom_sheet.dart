import 'package:daepiro/presentation/community/controller/community_disaster_view_model.dart';
import 'package:daepiro/presentation/community/screens/reply_menu_screen.dart';
import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../cmm/theme/DaepiroTheme.dart';
import '../../../../data/model/response/community/disaster_reply_response.dart';

class ReplyBottomSheet extends ConsumerStatefulWidget {
  final int? situationId;

  ReplyBottomSheet({super.key, this.situationId});

  @override
  ReplyBottomSheetState createState() => ReplyBottomSheetState();
}

class ReplyBottomSheetState extends ConsumerState<ReplyBottomSheet> {
  final TextEditingController replyController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityDisasterProvider);

    if (state.isEditState) {
      //일반 댓글 편집 상태임
      focusNode.requestFocus();
    } else if (state.editChildCommentId != 0) {
      focusNode.requestFocus();
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            )),
        child: Column(
          children: [
            headerWidget(),
            Expanded(
              child: state.disasterReplyList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        noReplyWidget(),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            if (state.isLoading)
                              Center(
                                child: CircularProgressIndicator(),
                              )
                            else
                              replyListWidget(
                                ref,
                                state.disasterReplyList,
                                widget.situationId ?? 0,
                                state.isEditState,
                                state.editCommentId,
                                state.isChildCommentState,
                                state.isEditChildCommentState,
                                state.editChildCommentId,
                              )
                          ],
                        ),
                      ),
                    ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: footerWidget(
                  replyController,
                  widget.situationId ?? 0,
                  state.isEditState,
                  focusNode,
                  state.parentCommentId,
                  state.isChildCommentState,
                  state.isEditChildCommentState,
                ))
          ],
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
                    '댓글',
                    textAlign: TextAlign.center,
                    style: DaepiroTextStyle.body_1_b
                        .copyWith(color: DaepiroColorStyle.g_900),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    ref.read(communityDisasterProvider.notifier).setReplyId(0);
                    ref
                        .read(communityDisasterProvider.notifier)
                        .setEditState(false);
                    ref
                        .read(communityDisasterProvider.notifier)
                        .clearDisasterReplyData();
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/icon_close.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                              DaepiroColorStyle.g_900, BlendMode.srcIn)),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
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

  Widget replyListWidget(
    WidgetRef ref,
    List<Reply> list,
    int situationId,
    bool isEditState,
    int editCommentId,
    bool isChildCommentState,
    bool isEditChildCommentState,
    int editChildCommentId,
  ) {
    return Container(
        width: double.infinity,
        child: Column(
          children: List.generate(list.length, (index) {
            return replyWidget(
              ref,
              context,
              list[index],
              situationId,
              isEditState,
              editCommentId,
              isChildCommentState,
              isEditChildCommentState,
              editChildCommentId,
            );
          }),
        ));
  }

  //댓글 위젯
  Widget replyWidget(
    WidgetRef ref,
    BuildContext context,
    Reply reply,
    int situationId,
    bool isEditState,
    int editCommentId,
    bool isChildCommentState,
    bool isEditChildCommentState,
    int editChildCommentId,
  ) {
    if(editCommentId == reply.id) {
      replyController.text = reply.content!;
      setState(() {});
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: isEditState && editCommentId == reply.id
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
                        reply.name ?? '탈퇴한 사용자',
                        style: DaepiroTextStyle.caption
                            .copyWith(color: DaepiroColorStyle.g_800),
                      ),
                      Visibility(
                          visible: reply.isVerified ?? false,
                          child: Row(
                            children: [
                              SizedBox(width: 2),
                              SvgPicture.asset( 'assets/icons/icon_town_certificate.svg',
                                  width: 16,
                                  height: 16,
                                  colorFilter: ColorFilter.mode(
                                      DaepiroColorStyle.o_300, BlendMode.srcIn)),
                            ],
                          )),
                      SizedBox(width: 6),
                      Visibility(
                        visible: reply.isModified ?? false,
                        child: Text(
                          '수정됨 · ',
                          style: DaepiroTextStyle.caption
                              .copyWith(color: DaepiroColorStyle.g_300),
                        ),
                      ),
                      Text(
                        parseRegTime(reply.time!),
                        style: DaepiroTextStyle.caption
                            .copyWith(color: DaepiroColorStyle.g_300),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          goToAdditional(context, reply.isMine!, reply.id!, ref,
                              isChildCommentState);
                        },
                        child: Visibility(
                          visible: reply.isDeleted == false,
                          child: SvgPicture.asset('assets/icons/icon_moreinfo.svg',
                              colorFilter: ColorFilter.mode(
                                  DaepiroColorStyle.g_200, BlendMode.srcIn)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  reply.isDeleted == false
                      ? Text(
                    reply.content!,
                    style: DaepiroTextStyle.body_2_m
                        .copyWith(color: DaepiroColorStyle.g_900),
                  ) : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: SvgPicture.asset('assets/icons/icon_warning.svg',
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                                DaepiroColorStyle.g_300, BlendMode.srcIn)),
                      ),
                      Text(
                        reply.content!,
                        style: DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_300),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            await ref
                                .read(communityDisasterProvider.notifier)
                                .replyLike(reply.id!);
                          },
                          child: likeButton(reply.isLiked!, reply.likeCount!)),
                      SizedBox(width: 8),
                      GestureDetector(
                          onTap: () {
                            ref
                                .read(communityDisasterProvider.notifier)
                                .setChildCommentState(true);
                            ref
                                .read(communityDisasterProvider.notifier)
                                .setParentCommentId(reply.id!);
                            focusNode.requestFocus();
                          },
                          child: replyWriteButton())
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          if (reply.childComments != [])
            IntrinsicHeight(
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(color: DaepiroColorStyle.g_75),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: reReplyListWidget(
                        reply.childComments!,
                        context,
                        situationId,
                        isChildCommentState,
                        isEditChildCommentState,
                        editChildCommentId),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget reReplyListWidget(
    List<ChildComments> list,
    BuildContext context,
    int situationId,
    bool isChildCommentState,
    bool isEditChildCommentState,
    int editChildCommentId,
  ) {
    return Container(
      width: double.infinity,
      child: Column(
        children: List.generate(list.length, (index) {
          return Column(
            children: [
              reReplyWidget(context, list[index], situationId, isChildCommentState, isEditChildCommentState, editChildCommentId),
              SizedBox(height: 8)
            ],
          );
        }),
      ),
    );
  }

  Widget reReplyWidget(
      BuildContext context,
      ChildComments childComments,
      int situationId,
      bool isChildCommentState,
      bool isEditChildCommentState,
      int editChildCommentId) {
    if(editChildCommentId == childComments.id) {
      replyController.text = childComments.content!;
      setState(() {});
    }
    return Container(
      decoration: BoxDecoration(
        color: isEditChildCommentState && editChildCommentId == childComments.id
            ? DaepiroColorStyle.g_50
            : DaepiroColorStyle.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  childComments.name ?? '탈퇴한 사용자',
                  style: DaepiroTextStyle.caption
                      .copyWith(color: DaepiroColorStyle.g_800),
                ),
                Visibility(
                    visible: childComments.isVerified ?? false,
                    child: Row(
                      children: [
                        SizedBox(width: 2),
                        SvgPicture.asset(
                            'assets/icons/icon_town_certificate.svg',
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                                DaepiroColorStyle.o_300,
                                BlendMode.srcIn)),
                      ],
                    )),
                SizedBox(width: 6),
                Visibility(
                  visible: childComments.isModified ?? false,
                  child: Text(
                    '수정됨 · ',
                    style: DaepiroTextStyle.caption
                        .copyWith(color: DaepiroColorStyle.g_300),
                  ),
                ),
                Text(
                  parseRegTime(childComments.time!),
                  style: DaepiroTextStyle.caption
                      .copyWith(color: DaepiroColorStyle.g_300),
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      ref
                          .read(communityDisasterProvider.notifier)
                          .setChildCommentState(true);
                      goToAdditional(
                          context,
                          childComments.isMine!,
                          childComments.id!,
                          ref,
                          isChildCommentState);
                    },
                    child: SvgPicture.asset(
                        'assets/icons/icon_moreinfo.svg',
                        colorFilter: ColorFilter.mode(
                            DaepiroColorStyle.g_200,
                            BlendMode.srcIn))
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              childComments.content!,
              style: DaepiroTextStyle.body_2_m
                  .copyWith(color: DaepiroColorStyle.g_900),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      await ref
                          .read(communityDisasterProvider.notifier)
                          .replyLike(childComments.id!);
                    },
                    child: likeButton(childComments.isLiked!,
                        childComments.likeCount ?? 0)),
                Spacer()
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget footerWidget(
      TextEditingController controller,
      int articleId,
      bool isEditState,
      FocusNode replyFocusNode,
      int parentCommentId,
      bool isChildCommentState,
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
                      focusNode: replyFocusNode,
                      controller: controller,
                      cursorColor: DaepiroColorStyle.g_900,
                      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
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
                    ),
                  ),
                  SizedBox(width: 12),
                  TextButton(
                    onPressed: () async {
                      if (isEditState) {
                        //수정하기 상태
                        ref
                            .read(communityDisasterProvider.notifier)
                            .setEditState(false);
                        await ref
                            .read(communityDisasterProvider.notifier)
                            .editReply(controller.text);
                        ref
                            .read(communityDisasterProvider.notifier)
                            .setReplyId(0);
                      } else if (isChildCommentState) {
                        //대댓글을 수정, 작성 하려는 상태
                        if (parentCommentId != 0) {
                          //대댓글을 작성 상태(답글쓰기)
                          ref
                              .read(communityDisasterProvider.notifier)
                              .setParentCommentId(0);
                          await ref
                              .read(communityDisasterProvider.notifier)
                              .setReplyComment(
                                  controller.text, parentCommentId);
                        } else if (isEditChildCommentState) {
                          //대댓글을 수정하려는 상태
                          ref
                              .read(communityDisasterProvider.notifier)
                              .setEditState(false);
                          await ref
                              .read(communityDisasterProvider.notifier)
                              .editReply(controller.text);
                          ref
                              .read(communityDisasterProvider.notifier)
                              .setReplyId(0);
                        }
                        ref
                            .read(communityDisasterProvider.notifier)
                            .setChildCommentState(false);
                      } else {
                        //일반 댓글 작성의 경우
                        await ref
                            .read(communityDisasterProvider.notifier)
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
                  )
                ],
              ),
            )),
            SizedBox(width: 20)
          ],
        ),
      ),
    );
  }

  Widget likeButton(bool isLiked, int likeNum) {
    return Container(
      decoration: BoxDecoration(
          color: isLiked ? DaepiroColorStyle.o_50 : DaepiroColorStyle.g_50,
          borderRadius: BorderRadius.circular(99)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/icon_good.svg',
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                    isLiked ? DaepiroColorStyle.o_400 : DaepiroColorStyle.g_300,
                    BlendMode.srcIn)),
            SizedBox(width: 2),
            Text(
              '좋아요',
              style: DaepiroTextStyle.caption.copyWith(
                  color: isLiked
                      ? DaepiroColorStyle.o_400
                      : DaepiroColorStyle.g_300),
            ),
            SizedBox(width: 2),
            Visibility(
              visible: likeNum > 0,
              child: Text(
                '${likeNum}',
                style: DaepiroTextStyle.caption.copyWith(
                    color: isLiked
                        ? DaepiroColorStyle.o_400
                        : DaepiroColorStyle.g_300),
              ),
            )
          ],
        ),
      ),
    );
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

  Widget noReplyWidget() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '아직 작성된 댓글이 없어요',
            style: DaepiroTextStyle.h5.copyWith(color: DaepiroColorStyle.g_300),
          ),
          SizedBox(height: 8),
          Text(
            '가장 먼저 정보를 이웃에게 공유해주세요',
            style: DaepiroTextStyle.body_1_m
                .copyWith(color: DaepiroColorStyle.g_300),
          ),
        ],
      ),
    );
  }


  void goToAdditional(BuildContext context, bool isUser, int commentId,
      WidgetRef ref, bool isChildCommentState) {
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
                        .read(communityDisasterProvider.notifier)
                        .setChildCommentState(false);
                  }
                }
              },
              child: ReplyMenuScreen(
                  isUser: isUser,
                  id: commentId,
                  deleteComment: () async {
                    await ref
                        .read(communityDisasterProvider.notifier)
                        .deleteReply(commentId);
                  },
                  isChildCommentState: isChildCommentState,
                  isArticle: false));
        });
  }
}
