import 'package:daepiro/data/model/response/sponsor/sponsor_list_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cmm/theme/DaepiroTheme.dart';
import '../const/utils.dart';

class SponsorDetailScreen extends ConsumerStatefulWidget {
  final Sponsor extra;

  const SponsorDetailScreen({
    super.key,
    required this.extra
  });

  @override
  ConsumerState<SponsorDetailScreen> createState() => _SponsorDetailScreenState();
}

class _SponsorDetailScreenState extends ConsumerState<SponsorDetailScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: DaepiroColorStyle.white,
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
                        "후원정보",
                        style: DaepiroTextStyle.h6.copyWith(
                          color: DaepiroColorStyle.g_800,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: DaepiroColorStyle.o_50
                            ),
                            padding: const EdgeInsets.fromLTRB(6,7,10,7),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  findDisasterIconByName(name: widget.extra.disasterType ?? ""),
                                  width: 16,
                                  height: 16,
                                  colorFilter: const ColorFilter.mode(DaepiroColorStyle.o_500, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.extra.disasterType ?? "",
                                  style: DaepiroTextStyle.caption.copyWith(
                                    color: DaepiroColorStyle.o_500,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: DaepiroColorStyle.g_50
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: Text(
                              calculateDaysDiff(widget.extra.deadline ?? ""),
                              style: DaepiroTextStyle.body_2_m.copyWith(
                                color: DaepiroColorStyle.g_600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.extra.sponsorName ?? "",
                        style: DaepiroTextStyle.body_2_m.copyWith(
                          color: DaepiroColorStyle.g_600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.extra.title ?? "",
                        style: DaepiroTextStyle.h6.copyWith(
                          color: DaepiroColorStyle.g_900,
                        ),
                      ),
                      if (widget.extra.deadline != null)
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              formatDateToDot(widget.extra.deadline ?? ""),
                              style: DaepiroTextStyle.caption.copyWith(
                                color: DaepiroColorStyle.g_400,
                              ),
                            )
                          ],
                        ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          widget.extra.thumbnail ?? "",
                          width: double.infinity,
                          height: 187,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TabBar(
                        controller: _tabController,
                        labelColor: DaepiroColorStyle.g_800,
                        labelStyle: DaepiroTextStyle.body_1_m,
                        unselectedLabelColor: DaepiroColorStyle.g_300,
                        unselectedLabelStyle: DaepiroTextStyle.body_1_m,
                        indicatorColor: DaepiroColorStyle.g_800,
                        indicatorWeight: 2,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(
                            child: Text("내용소개"),
                          ),
                          Tab(
                            child: Text("후원사"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                      controller: _tabController,
                      children: [
                        Column(
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              color: DaepiroColorStyle.g_50,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '후원 정보 요약',
                                                  style: DaepiroTextStyle.body_1_b.copyWith(
                                                    color: DaepiroColorStyle.g_900,
                                                  )
                                              ),
                                              const SizedBox(height: 10),
                                              for (int i=0;i<widget.extra.summary!.length;i++)
                                                Column(
                                                  children: [
                                                    if (i !=0)
                                                      const SizedBox(height: 2),
                                                    Text(
                                                        "- ${widget.extra.summary?[i]}",
                                                        style: DaepiroTextStyle.body_2_m.copyWith(
                                                          color: DaepiroColorStyle.g_800,
                                                        )
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                            widget.extra.subtitle ?? "",
                                            style: DaepiroTextStyle.body_2_m.copyWith(
                                              color: DaepiroColorStyle.g_800,
                                            )
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                            widget.extra.body ?? "",
                                            style: DaepiroTextStyle.body_2_m.copyWith(
                                              color: DaepiroColorStyle.g_800,
                                            )
                                        ),
                                        const SizedBox(height: 12)
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              color: DaepiroColorStyle.g_50,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                  "기관/단체",
                                                  style: DaepiroTextStyle.body_2_b.copyWith(
                                                    color: DaepiroColorStyle.o_500,
                                                  )
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (await canLaunchUrl(Uri.parse(widget.extra.sponsorUrl ?? ""))) {
                                                     launchUrl(Uri.parse(widget.extra.sponsorUrl ?? ""));
                                                  }
                                                },
                                                child: Text(
                                                  widget.extra.sponsorName ?? "",
                                                  style: DaepiroTextStyle.body_2_m.copyWith(
                                                    color: DaepiroColorStyle.g_800,
                                                    decoration: TextDecoration.underline,
                                                    decorationColor: DaepiroColorStyle.g_800,
                                                    decorationThickness: 1,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                            widget.extra.sponsorDescription ?? "",
                                            style: DaepiroTextStyle.body_2_m.copyWith(
                                              color: DaepiroColorStyle.g_800,
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: DaepiroColorStyle.g_50,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(widget.extra.sponsorPostUrl ?? ""))) {
                              launchUrl(Uri.parse(widget.extra.sponsorPostUrl ?? ""), mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: DaepiroColorStyle.o_500
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "후원하기",
                              style: DaepiroTextStyle.body_1_b.copyWith(
                                color: DaepiroColorStyle.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Share.share(widget.extra.sponsorUrl ?? "");
                        },
                        child: SvgPicture.asset(
                          'assets/icons/icon_share.svg',
                          width: 28,
                          height: 28,
                          colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_400, BlendMode.srcIn),
                        ),
                      )
                    ],
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
}