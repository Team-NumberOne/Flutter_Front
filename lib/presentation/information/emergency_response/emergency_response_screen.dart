import 'package:daepiro/presentation/const/const.dart';
import 'package:daepiro/presentation/information/component/item_emergency_response.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

class EmergencyResponseScreen extends ConsumerStatefulWidget {
  const EmergencyResponseScreen({super.key});

  @override
  ConsumerState<EmergencyResponseScreen> createState() => _EmergencyResponseScreen();
}

class _EmergencyResponseScreen extends ConsumerState<EmergencyResponseScreen> with SingleTickerProviderStateMixin {
  final PageController _responsePageController = PageController(initialPage: 0);
  var selectedTabIndex = 0;

  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedTabIndex = _tabController.index;
          _responsePageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 1),
              curve: Curves.easeIn
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: DaepiroColorStyle.white,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/icon_arrow_left.svg',
                        alignment: Alignment.centerLeft,
                        colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '응급대처',
                        style: DaepiroTextStyle.h6.copyWith(
                          color: DaepiroColorStyle.g_800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: DaepiroColorStyle.g_800,
                      labelStyle: DaepiroTextStyle.body_1_m,
                      labelPadding: const EdgeInsets.symmetric(vertical: 12),
                      unselectedLabelColor: DaepiroColorStyle.g_300,
                      unselectedLabelStyle: DaepiroTextStyle.body_1_m,
                      indicatorColor: DaepiroColorStyle.g_800,
                      dividerColor: DaepiroColorStyle.white,
                      dividerHeight: 3,
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(child: Text("심폐소생술")),
                        Tab(child: Text("응급처치")),
                        Tab(child: Text("소화기")),
                        Tab(child: Text("하임리히"))
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: Container(
                      height: 3,
                      color: DaepiroColorStyle.black.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ExpandablePageView(
                    controller: _responsePageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i=0;i<Const.emergencyResponseList[selectedTabIndex].length;i++)
                        ItemEmergencyResponse(
                            tabIndex: selectedTabIndex,
                            pageIndex: i
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: SmoothPageIndicator(
                  controller: _responsePageController,
                  count: Const.emergencyResponseList[selectedTabIndex].length,
                  effect: const ExpandingDotsEffect(
                      dotColor: DaepiroColorStyle.g_75,
                      activeDotColor: DaepiroColorStyle.g_300,
                      dotHeight: 6,
                      dotWidth: 6,
                      spacing: 6,
                      expansionFactor: 2.5
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _responsePageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: DaepiroColorStyle.g_50,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                  '이전',
                                  style: DaepiroTextStyle.body_1_b.copyWith(
                                    color: DaepiroColorStyle.g_700,
                                  )
                              ),
                            ),
                          ),
                        )
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _responsePageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: DaepiroColorStyle.o_500,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                  '다음',
                                  style: DaepiroTextStyle.body_1_b.copyWith(
                                    color: DaepiroColorStyle.white,
                                  )
                              ),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

