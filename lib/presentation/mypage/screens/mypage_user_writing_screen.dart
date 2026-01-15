import 'package:daepiro/presentation/mypage/controller/mypage_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../data/model/response/mypage/get_mypage_articles_response.dart';
import '../../community/controller/community_town_view_model.dart';
import '../../const/utils.dart';
/// 내가 쓴글 페이지

class MyPageUserWritingScreen extends ConsumerStatefulWidget {
  @override
  MyPageUserWritingState createState() => MyPageUserWritingState();
}

class MyPageUserWritingState extends ConsumerState<MyPageUserWritingScreen> {
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
    final state = ref.read(myPageProvider);
    final viewModel = ref.read(myPageProvider.notifier);

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (state.isArticleHasMore && !state.isArticleLoading) {
        viewModel.getMyArticles();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPageProvider);
    final communityViewModel = ref.read(communityTownProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if(didPop) {
          ref.read(myPageProvider.notifier).initMyArticleState();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerWidget(),
              Expanded(
                  child: Scrollbar(
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            state.myArticles.length != 0 ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.myArticles.length,
                                itemBuilder: (context, index) {
                                  final content = state.myArticles[index];
                                  return listItemWidget(() async {
                                    //상세 기사정보 화면으로 이동
                                    await communityViewModel.getContentDetail(content.id!);
                                    GoRouter.of(context).push('/community_town_detail', extra: {'fromMyPage': true});
                                  }, content, ref);
                                }
                            ) : Center(child: noDataWidget()),
                            if (state.isArticleLoading)
                              Center(
                                child: CircularProgressIndicator(),
                              )
                          ],
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
        )
      ),
    );
  }

  //리스트 아이템 위젯
  Widget listItemWidget(VoidCallback event, UserArticle content, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: event,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    typeChip(ContentCategory.getByValue(content.category!)),
                    SizedBox(width: 8,),
                    Visibility(
                        visible: content.address?.addressId != null,
                        child: addressChip('${content.address?.eupMyeonDong ?? '00동'}에서 작성한 글')
                    ),
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
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (BuildContext context,
                              Object exception,
                              StackTrace? stackTrace) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
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
                    SizedBox(width: 2),
                    Visibility(
                      visible: content.authorUser?.isVerified ?? false,
                      child: SvgPicture.asset(
                          'assets/icons/icon_certification.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                              DaepiroColorStyle.o_300, BlendMode.srcIn)),
                    ),
                    SizedBox(width: 6),
                    Text(
                        content.lastModifiedAt == content.createdAt! ? parseRegTime(content.createdAt!) : parseRegTime(content.lastModifiedAt!),
                        style: DaepiroTextStyle.caption
                            .copyWith(color: DaepiroColorStyle.g_300)),
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

  Widget headerWidget() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                      DaepiroColorStyle.g_900, BlendMode.srcIn)),
            ),
            Expanded(
              child: Text(
                '내가 쓴 글',
                textAlign: TextAlign.center,
                style:
                DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800),
              ),
            ),
            SizedBox(width: 24)
          ],
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
                  colorFilter: ColorFilter.mode(
                      DaepiroColorStyle.g_75, BlendMode.srcIn)),
              SizedBox(
                height: 8,
              ),
              Text(
                '아직 작성된 글이 없어요',
                style: DaepiroTextStyle.h6
                    .copyWith(color: DaepiroColorStyle.g_300),
              ),
              SizedBox(height: 4),
              Text(
                textAlign: TextAlign.center,
                '커뮤니티에서 글을 작성하고 이웃과 소통해보세요.',
                style: DaepiroTextStyle.body_2_m
                    .copyWith(color: DaepiroColorStyle.g_300),
              )
            ],
          ),
        ));
  }

}