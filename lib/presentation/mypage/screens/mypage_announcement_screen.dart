import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:daepiro/presentation/const/utils.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../data/model/response/mypage/get_mypage_announcements_list_response.dart';
import '../controller/mypage_viewmodel.dart';

class MypageAnnouncementScreen extends ConsumerWidget {
  MypageAnnouncementScreen({super.key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(myPageProvider.notifier);
    final state = ref.watch(myPageProvider);


    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerWidget(context),
            if(state.isLoading)
              Center(child: CircularProgressIndicator()),
            state.announcementList.isNotEmpty || state.announcementList.length>0 ?
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
                            ListView.builder(
                              shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.announcementList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await viewModel.getAnnouncementDetail(state.announcementList[index].id.toString());
                                      GoRouter.of(context).push('/mypage_announcement_detail/${state.announcementList[index].id}');
                                    },
                                      child: listWidget(state.announcementList[index])
                                  );
                                }
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              ) : Center(
              child: Text('데이터가 없습니다.'),
            )
          ],
        ),
      )
    );
  }

  //헤더 위젯
  Widget headerWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => GoRouter.of(context).pop(),
            child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                width: 24,
                height: 24,
                colorFilter:
                ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)),
          ),
          Spacer(),
          Text('공지사항',
              style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800)),
          Spacer(),
          Opacity(
            opacity: 0.0,
            child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget listWidget(Announcements announcement) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(
                  announcement.title ?? '',
                  style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_900),
                ))
              ],
            ),
            SizedBox(height: 6,),
            Row(
              children: [
                Expanded(child: Text(
                  formatDateToDot(announcement.createdAt ?? ''),
                  style: DaepiroTextStyle.caption.copyWith(color: DaepiroColorStyle.g_400),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

}
