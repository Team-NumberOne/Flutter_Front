import 'dart:async';
import 'dart:ffi';

import 'package:daepiro/presentation/sponsor/component/item_cheer_keyword.dart';
import 'package:daepiro/presentation/sponsor/component/item_sponsor_preview.dart';
import 'package:daepiro/presentation/sponsor/sponsor_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../cmm/theme/DaepiroTheme.dart';
import '../const/utils.dart';

class SponsorScreen extends ConsumerStatefulWidget {
  const SponsorScreen({super.key});

  @override
  ConsumerState<SponsorScreen> createState() => _SponsorScreenState();
}

const scrollSpeed = 50.0; // 스크롤 속도 (픽셀/초)
class _SponsorScreenState extends ConsumerState<SponsorScreen> {
  late ScrollController _scrollController1;
  late ScrollController _scrollController2;
  Timer? _scrollTimer1;
  Timer? _scrollTimer2;

  @override
  void initState() {
    super.initState();
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();
    _startAutoScroll1();
    _startAutoScroll2();
  }

  void _startAutoScroll1() {
    _scrollTimer1 = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (_scrollController1.hasClients) {
        final maxScroll = _scrollController1.position.maxScrollExtent;
        final currentScroll = _scrollController1.offset;
        if (currentScroll >= maxScroll) {
          // 끝까지 스크롤되면 처음으로 돌아가기
          _scrollController1.jumpTo(0);
        } else {
          // 오른쪽으로 스크롤
          _scrollController1.jumpTo(currentScroll + scrollSpeed * 0.016);
        }
      }
    });
  }

  void _startAutoScroll2() {
    _scrollTimer2 = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (_scrollController2.hasClients) {
        final maxScroll = _scrollController2.position.maxScrollExtent;
        final currentScroll = _scrollController2.offset;
        if (currentScroll >= maxScroll) {
          // 끝까지 스크롤되면 처음으로 돌아가기
          _scrollController2.jumpTo(0);
        } else {
          // 오른쪽으로 스크롤
          _scrollController2.jumpTo(currentScroll + scrollSpeed * 0.016);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(sponsorStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                child: Text(
                  "후원",
                  style: DaepiroTextStyle.h6.copyWith(
                    color: DaepiroColorStyle.g_800,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push('/cheer');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          color: DaepiroColorStyle.o_50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "대피로",
                                      style: DaepiroTextStyle.h6.copyWith(
                                        color: DaepiroColorStyle.o_500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "와 함께\n응원의 한마디를 남겨보세요!",
                                      style: DaepiroTextStyle.h6.copyWith(
                                        color: DaepiroColorStyle.g_900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController1,
                                child: Row(
                                    children: [
                                      for (int i=0;i<viewModel.scrollCommentList1.length;i++)
                                        Row(
                                          children: [
                                            ItemCheerKeyword(
                                                text: viewModel.scrollCommentList1[i]
                                            ),
                                            const SizedBox(width: 8)
                                          ],
                                        ),
                                    ]
                                ),
                              ),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController2,
                                child: Row(
                                    children: [
                                      for (int i=0;i<viewModel.scrollCommentList2.length;i++)
                                        Row(
                                          children: [
                                            ItemCheerKeyword(
                                                text: viewModel.scrollCommentList2[i]
                                            ),
                                            const SizedBox(width: 8)
                                          ],
                                        ),
                                    ]
                                ),
                              ),
                              const SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "응원하기",
                                        style: DaepiroTextStyle.body_2_m.copyWith(
                                          color: DaepiroColorStyle.o_400,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      SvgPicture.asset('assets/icons/icon_arrow_right.svg')
                                    ]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      viewModel.isLoading
                          ? Container(
                              padding: const EdgeInsets.only(top: 60),
                              child: const Center(child: CircularProgressIndicator()))
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              child: ListView.builder(
                                  itemCount: viewModel.sponsorList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context.push(
                                                '/sponsorDetail',
                                                extra: viewModel.sponsorList[index]
                                            );
                                          },
                                          child: ItemSponsorPreview(
                                            disasterType: viewModel.sponsorList[index].disasterType ?? "",
                                            date: calculateDaysDiff(viewModel.sponsorList[index].deadline ?? ""),
                                            from: viewModel.sponsorList[index].sponsorName ?? "",
                                            title: viewModel.sponsorList[index].title ?? "",
                                            imagePath: viewModel.sponsorList[index].thumbnail ?? "",
                                          ),
                                        ),
                                        const SizedBox(height: 12)
                                      ],
                                    );
                                  }
                              ),
                          )
                    ],
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollTimer1?.cancel();
    _scrollTimer2?.cancel();
    _scrollController1.dispose();
    _scrollController2.dispose();
    super.dispose();
  }
}