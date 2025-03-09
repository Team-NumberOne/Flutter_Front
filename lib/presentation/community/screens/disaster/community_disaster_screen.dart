import 'package:daepiro/data/model/response/community/disaster_response.dart';
import 'package:daepiro/presentation/community/controller/community_disaster_view_model.dart';
import 'package:daepiro/presentation/community/screens/disaster/reply_bottom_sheet.dart';
import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../cmm/DaepiroTheme.dart';
import '../../../../cmm/button/secondary_filled_button.dart';
import '../../../../data/model/response/home/disasters_history_response.dart';
import '../../../const/common_disaster_list.dart';
import '../../../const/emergency_disaster_list.dart';

//재난상황 화면
class CommunityDisasterScreen extends ConsumerWidget {
  List<Map<String, String>> totalList = [
    ...CommonDisasterList,
    ...EmergencyDisasterList
  ];
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(communityDisasterProvider.notifier);
    final state = ref.watch(communityDisasterProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.getDisasterSituaions();
      },
      child: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push('/community_rule');
                  },
                  child: ruleContainer(),
                ),
                twoButtonContainer(ref, state.disasterCommunityType),
                if (state.isLoading)
                  Center(child: CircularProgressIndicator())
                else if (state.disasterCommunityType == 'all' &&
                    state.allDisasterResponse.length == 0)
                  Center(child: Text('재난상황이 아직 없습니다.'))
                else if (state.disasterCommunityType != 'all' &&
                    state.receivedDisasterResponse.length == 0)
                  Center(child: Text('재난상황이 아직 없습니다.'))
                else
                  ...List.generate(
                    state.disasterCommunityType == 'all'
                        ? state.allDisasterResponse.length
                        : state.receivedDisasterResponse.length,
                    (index) {
                      final content = state.disasterCommunityType == 'all'
                          ? (index < state.allDisasterResponse.length
                              ? state.allDisasterResponse[index]
                              : null)
                          : (index < state.receivedDisasterResponse.length
                              ? state.receivedDisasterResponse[index]
                              : null);
                      if (content == null)
                        return SizedBox.shrink(); // 유효하지 않은 데이터 무시
                      return contentItem(content, context, ref);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ruleContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: DaepiroColorStyle.o_50),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(width: 12),
            SvgPicture.asset('assets/icons/icon_noti.svg',
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(DaepiroColorStyle.o_400, BlendMode.srcIn)),
            SizedBox(width: 6),
            Text('대피로 커뮤니티 이용수칙',
                style: DaepiroTextStyle.body_2_m
                    .copyWith(color: DaepiroColorStyle.g_900)),
            Spacer(),
            SvgPicture.asset('assets/icons/icon_arrow_right.svg',
                width: 16,
                height: 16,
                colorFilter:
                    ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)),
            SizedBox(width: 12)
          ],
        ),
      ),
    );
  }

  Widget twoButtonContainer(WidgetRef ref, String type) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            SecondaryFilledButton(
              onPressed: () async {
                ref
                    .read(communityDisasterProvider.notifier)
                    .setLoadingState(true);
                await ref
                    .read(communityDisasterProvider.notifier)
                    .selectButton('all');
                ref
                    .read(communityDisasterProvider.notifier)
                    .setLoadingState(false);
              },
              radius: 99,
              child: Text(
                '전체',
                style: DaepiroTextStyle.body_1_m.copyWith(
                    color: type == 'all'
                        ? DaepiroColorStyle.white
                        : DaepiroColorStyle.g_600),
              ),
              backgroundColor: type == 'all'
                  ? DaepiroColorStyle.g_600
                  : DaepiroColorStyle.g_50,
              horizontalPadding: 12,
              verticalPadding: 4,
            ),
            SizedBox(width: 8),
            SecondaryFilledButton(
              onPressed: () async {
                ref
                    .read(communityDisasterProvider.notifier)
                    .setLoadingState(true);
                await ref
                    .read(communityDisasterProvider.notifier)
                    .selectButton('received');
                ref
                    .read(communityDisasterProvider.notifier)
                    .setLoadingState(false);
              },
              radius: 99,
              child: Text(
                '수신',
                style: DaepiroTextStyle.body_1_m.copyWith(
                    color: type == 'received'
                        ? DaepiroColorStyle.white
                        : DaepiroColorStyle.g_600),
              ),
              backgroundColor: type == 'received'
                  ? DaepiroColorStyle.g_600
                  : DaepiroColorStyle.g_50,
              horizontalPadding: 12,
              verticalPadding: 4,
            )
          ],
        ),
      ),
    );
  }

  Widget contentItem(Disaster content, BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: DaepiroColorStyle.o_50,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                          CommonDisasterList.firstWhere(
                                (item) => item['name'] == content.type,
                                orElse: () => {}, // 값이 없을 때 빈 Map 반환
                              )['icon'] ??
                              "assets/icons/icon_emergency_02.svg",
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                              DaepiroColorStyle.o_500, BlendMode.srcIn)),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        content.type ?? '미입력',
                        style: DaepiroTextStyle.caption
                            .copyWith(color: DaepiroColorStyle.o_500),
                      )
                    ],
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(
                      '/disasterDetail',
                    extra: Disasters(
                      disasterType: content.type,
                      disasterTypeId: content.typeId,
                      title: content.title,
                      content: content.content,
                      time: content.time
                    )
                  );
                },
                child: Row(
                  children: [
                    Text(
                      '행동요령',
                      style: DaepiroTextStyle.caption
                          .copyWith(color: DaepiroColorStyle.g_300),
                    ),
                    SvgPicture.asset(
                      'assets/icons/icon_arrow_right.svg',
                      colorFilter: ColorFilter.mode(
                          DaepiroColorStyle.g_300, BlendMode.srcIn),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 12),
          RichText(
            text: TextSpan(
                text: ref
                    .read(communityDisasterProvider.notifier)
                    .parseTitle(content.title!, content.type!),
                style: DaepiroTextStyle.h6
                    .copyWith(color: DaepiroColorStyle.g_900),
                children: [
                  TextSpan(
                    text: '${content.type} ',
                    style: DaepiroTextStyle.h6
                        .copyWith(color: DaepiroColorStyle.o_500),
                  ),
                  TextSpan(
                    text: '발생',
                    style: DaepiroTextStyle.h6
                        .copyWith(color: DaepiroColorStyle.g_900),
                  ),
                ]),
          ),
          SizedBox(height: 4),
          Text(
            content.content ?? '',
            style: DaepiroTextStyle.body_2_m
                .copyWith(color: DaepiroColorStyle.g_600),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/icon_location_24.svg',
                colorFilter:
                    ColorFilter.mode(DaepiroColorStyle.g_400, BlendMode.srcIn),
              ),
              SizedBox(width: 4),
              Text(
                '${content.location} ∙ ${parseDateTime(content.time ?? '')}',
                style: DaepiroTextStyle.caption
                    .copyWith(color: DaepiroColorStyle.g_400),
              ),
              Spacer(),
              if (content.commentCount! > 0)
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/icon_community.svg',
                      colorFilter: ColorFilter.mode(
                          DaepiroColorStyle.g_200, BlendMode.srcIn),
                    ),
                    SizedBox(width: 2),
                    Text(
                      '${content.commentCount}',
                      style: DaepiroTextStyle.caption
                          .copyWith(color: DaepiroColorStyle.g_200),
                    )
                  ],
                )
            ],
          ),
          SizedBox(height: 20),
          content.comments?.length != 0
              ? replyContainer(
                  context, content.comments ?? [], ref, content.id!)
              : noneReplyContainer(ref, context, content.id!),
          SizedBox(height: 36)
        ],
      ),
    );
  }

  Widget replyContainer(
    BuildContext context,
    List<Comments> comment,
    WidgetRef ref,
    int situationId,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: DaepiroColorStyle.g_50,
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            ...List.generate(
                comment.length,
                (index) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: replyWidget(
                          comment[index].content ?? '',
                          parseRegTime(comment[index].time!),
                          comment[index].likeCount ?? 0),
                    )),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                await ref
                    .read(communityDisasterProvider.notifier)
                    .getReplyData(situationId);
                showReplyBottomSheet(context, situationId);
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        '더보기',
                        style: DaepiroTextStyle.caption
                            .copyWith(color: DaepiroColorStyle.g_600),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget replyWidget(String content, String timeText, int likeNum) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: DaepiroColorStyle.white,
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: DaepiroTextStyle.body_2_m
                  .copyWith(color: DaepiroColorStyle.g_900),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  timeText,
                  style: DaepiroTextStyle.caption
                      .copyWith(color: DaepiroColorStyle.g_300),
                ),
                Spacer(),
                Visibility(
                    visible: likeNum != 0,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/icon_good.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                              DaepiroColorStyle.g_200, BlendMode.srcIn),
                        ),
                        SizedBox(width: 2),
                        Text(
                          '${likeNum}',
                          style: DaepiroTextStyle.caption
                              .copyWith(color: DaepiroColorStyle.g_500),
                        )
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  //댓글 존재하지 않을때 댓글창
  Widget noneReplyContainer(WidgetRef ref, BuildContext context, int id) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: DaepiroColorStyle.g_50),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('아직 재난 상황에 대한 댓글이 없어요',
                style: DaepiroTextStyle.body_2_b
                    .copyWith(color: DaepiroColorStyle.g_600)),
            SizedBox(height: 2),
            Text('재난 상황에 대한 정보를 이웃에게 공유해주세요',
                style: DaepiroTextStyle.caption
                    .copyWith(color: DaepiroColorStyle.g_600)),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                ref
                    .read(communityDisasterProvider.notifier)
                    .setSelectSituationId(id);
                showReplyBottomSheet(context, id);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: DaepiroColorStyle.g_500,
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: Text(
                    '댓글 달기',
                    style: DaepiroTextStyle.caption
                        .copyWith(color: DaepiroColorStyle.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showReplyBottomSheet(BuildContext context, int situationId) {
    showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              final height = MediaQuery.of(context).size.height * 0.8;
              return Container(
                height: height,
                child: ReplyBottomSheet(situationId: situationId),
              );
            },
            isScrollControlled: true,
            enableDrag: false,
            isDismissible: false)
        .then((value) {

    });
  }
}
