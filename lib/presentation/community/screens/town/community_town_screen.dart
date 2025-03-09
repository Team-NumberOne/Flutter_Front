import 'package:daepiro/presentation/community/controller/community_town_view_model.dart';
import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../cmm/DaepiroTheme.dart';
import '../../../../data/model/response/community/community_dongnae_content_response.dart';

class CommunityTownScreen extends ConsumerStatefulWidget {
  @override
  CommunityTownState createState() => CommunityTownState();
}

//동네생활 화면
class CommunityTownState extends ConsumerState<CommunityTownScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(communityTownProvider);
    final viewModel = ref.read(communityTownProvider.notifier);

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (state.isDongNaeHasMore && !state.isDongNaeLoading) {
        viewModel.loadContent();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(communityTownProvider.notifier);
    final state = ref.watch(communityTownProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.reloadContent();
        },
        child: Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push('/community_rule');
                      },
                      child: ruleContainer()),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Expanded(child: typeRadioButton(state.townCategory, ref))),
                  state.contentList.length != 0 ? ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: state.contentList.length,
                      itemBuilder: (context, index) {
                        final content = state.contentList[index];
                        return listItemWidget(() async {
                          await viewModel.getContentDetail(content.id!);
                          GoRouter.of(context).push('/community_town_detail');
                        }, content, ref, state.townCategory);
                      })
                      : Center(child: noDataWidget()),
                  if (state.isDongNaeLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
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
                colorFilter:
                    ColorFilter.mode(DaepiroColorStyle.o_400, BlendMode.srcIn)),
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

  //글 유형 타입 radio button
  Widget typeRadioButton(String townCategory, WidgetRef ref) {
    return Container(
        height: 36,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              typeItem(townCategory == '전체', '전체', ref),
              typeItem(townCategory == '일상', '일상', ref),
              typeItem(townCategory == '교통', '교통', ref),
              typeItem(townCategory == '치안', '치안', ref),
              typeItem(townCategory == '기타', '기타', ref)
            ],
          ),
        ));
  }

  Widget typeItem(bool isSame, String realText, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () async {
          await ref.read(communityTownProvider.notifier).selectButton(realText);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: isSame ? DaepiroColorStyle.g_600 : DaepiroColorStyle.g_50),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: Text(
              realText,
              style: isSame
                  ? DaepiroTextStyle.body_1_m.copyWith(color: Colors.white)
                  : DaepiroTextStyle.body_1_m
                      .copyWith(color: DaepiroColorStyle.g_600),
            ),
          ),
        ),
      ),
    );
  }

  //리스트 아이템 위젯
  Widget listItemWidget(
      VoidCallback event, Content content, WidgetRef ref, String townCategory) {
    return InkWell(
      overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return DaepiroColorStyle.g_50;
            }
            return DaepiroColorStyle.white;
          }),
      onTap: event,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Visibility(
                          visible: townCategory == '전체',
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: typeChip(ContentCategory.getByValue(content.category!)),
                          )),
                      Visibility(
                        visible: content.address?.addressId != null,
                          child: addressChip('${content.address?.eupMyeonDong ?? '00동'}에서 작성한 글')
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content.title ?? '',
                              style: DaepiroTextStyle.body_1_b
                                  .copyWith(color: DaepiroColorStyle.g_900),
                            ),
                            SizedBox(height: 2),
                            Text(
                              content.body ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: DaepiroTextStyle.body_2_m
                                  .copyWith(color: DaepiroColorStyle.g_500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Visibility(
                        visible: content.previewImageUrl != null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: content.previewImageUrl != null
                              ? Image.network(
                                  width: 68,
                                  height: 68,
                                  content.previewImageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox.shrink(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        content.authorUser?.nickname ?? '',
                        style: DaepiroTextStyle.caption
                            .copyWith(color: DaepiroColorStyle.g_800),
                      ),
                      Visibility(
                        visible: content.authorUser?.isVerified ?? false,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                            content.lastModifiedAt == content.createdAt!
                                ? parseRegTime(content.createdAt!)
                                : parseRegTime(content.lastModifiedAt!),
                            style: DaepiroTextStyle.caption
                                .copyWith(color: DaepiroColorStyle.g_300)),
                      ),
                      Spacer(),
                      SvgPicture.asset('assets/icons/icon_good.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                              DaepiroColorStyle.g_200, BlendMode.srcIn)),
                      SizedBox(width: 2),
                      Text(content.likeCount.toString(),
                          style: DaepiroTextStyle.caption
                              .copyWith(color: DaepiroColorStyle.g_200)),
                      SizedBox(width: 4),
                      SvgPicture.asset('assets/icons/icon_community.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                              DaepiroColorStyle.g_200, BlendMode.srcIn)),
                      SizedBox(width: 2),
                      Text(content.commentCount.toString(),
                          style: DaepiroTextStyle.caption
                              .copyWith(color: DaepiroColorStyle.g_200)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget typeChip(String type) {
    return Container(
      decoration: BoxDecoration(
          color: DaepiroColorStyle.g_50,
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Text(
          type,
          style:
              DaepiroTextStyle.caption.copyWith(color: DaepiroColorStyle.g_500),
        ),
      ),
    );
  }

  Widget addressChip(String eupMyeonDong) {
    return Container(
      decoration: BoxDecoration(
          color: DaepiroColorStyle.o_50,
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Text(
          eupMyeonDong,
          style: DaepiroTextStyle.caption.copyWith(color: DaepiroColorStyle.o_500),
        ),
      ),
    );
  }

  Widget noDataWidget() {
    return Container(
      width: double.infinity,
        height: MediaQuery.of(context).size.height/2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/icon_community.svg',
                  width: 48,
                  height: 48,
                  colorFilter:
                  ColorFilter.mode(DaepiroColorStyle.g_75, BlendMode.srcIn)),
              SizedBox(height: 8,),
              Text(
                '아직 작성된 글이 없어요',
                style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_300),
              ),
              SizedBox(height: 4),
              Text(
                '글을 작성하고 이웃과 소통해보세요.',
                style: DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_300),
              )
            ],
          ),
        )
    );
  }
}
