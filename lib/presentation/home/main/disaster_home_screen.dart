import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/chip/secondary_chip.dart';
import '../../../data/model/response/home/disasters_history_response.dart';
import '../../const/const.dart';
import '../../const/utils.dart';
import '../../information/shelter/around_shelter_extra.dart';
import '../component/action_tip_item.dart';
import '../component/around_shelter_preview.dart';
import '../component/disaster_mesaage_history_preview.dart';
import '../component/not_location_permission_widget.dart';
import 'home_view_model.dart';

class DisasterHomeScreen extends ConsumerStatefulWidget {
  const DisasterHomeScreen({super.key});

  @override
  _DisasterHomeScreenState createState() => _DisasterHomeScreenState();
}

class _DisasterHomeScreenState extends ConsumerState<DisasterHomeScreen> with WidgetsBindingObserver{
  final PageController _aroundShelterPageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9
  );
  int selectedActionTipType = 0;
  int selectedDisasterType = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeStateNotifierProvider);

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: DaepiroColorStyle.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 20, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset('assets/icons/icon_logo_small.svg'),
                  GestureDetector(
                    onTap: () {
                      context.push('/notification');
                    },
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/icons/icon_alarm.svg',
                          colorFilter: const ColorFilter.mode(
                              DaepiroColorStyle.g_200, BlendMode.srcIn),
                        )
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (viewModel.disasterInfo != null)
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: DaepiroColorStyle.o_50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    findDisasterIconByName(name: viewModel.disasterInfo?.disasterType ?? ""),
                                    width: 26,
                                    height: 26,
                                    colorFilter: const ColorFilter.mode(DaepiroColorStyle.o_500, BlendMode.srcIn),
                                  )
                              ),
                              const SizedBox(height: 8),
                              getLargeHighlightText(title: viewModel.disasterInfo?.title?.replaceAll("기타", "기타 재난") ?? "", disaster: viewModel.disasterInfo?.disasterType ?? ""),
                              const SizedBox(height: 8),
                              Text(
                                viewModel.disasterInfo?.content ?? "",
                                style: DaepiroTextStyle.body_2_m.copyWith(
                                  color: DaepiroColorStyle.g_500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                formatDateToDateTime(viewModel.disasterInfo?.time ?? ""),
                                style: DaepiroTextStyle.caption.copyWith(
                                  color: DaepiroColorStyle.g_300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        color: DaepiroColorStyle.g_50,
                        height: 4,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "행동요령",
                              style: DaepiroTextStyle.h6.copyWith(
                                color: DaepiroColorStyle.g_900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                  color: DaepiroColorStyle.g_50,
                                ),
                              ),
                              child: Column(
                                children: [
                                  viewModel.disasterBehaviorTip != null && viewModel.disasterBehaviorTip!.tips!.isNotEmpty
                                      ? Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Row(
                                                children: [
                                                  for (int index = 0; index < viewModel.disasterBehaviorTip!.tips!.length; index++)
                                                    Row(
                                                      children: [
                                                        SecondaryChip(
                                                            isSelected: index == selectedActionTipType,
                                                            text: viewModel.disasterBehaviorTip!.tips![index].filter ?? "",
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedActionTipType = index;
                                                              });
                                                            }
                                                        ),
                                                        const SizedBox(width: 8)
                                                      ],
                                                    )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            for (int index = 0; index < viewModel.disasterBehaviorTip!.tips![selectedActionTipType].tips!.length; index++)
                                              Column(
                                                children: [
                                                  ActionTipItem(
                                                    text: viewModel.disasterBehaviorTip!.tips![selectedActionTipType].tips![index].$1,
                                                    isSelected: viewModel.disasterBehaviorTip!.tips![selectedActionTipType].tips![index].$2,
                                                    onClick: () {
                                                      ref.read(homeStateNotifierProvider.notifier)
                                                          .selectCheckListAtDisaster(selectedActionTipType, index);
                                                    },
                                                  ),
                                                ],
                                              )
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            const SizedBox(height: 16),
                                            SvgPicture.asset(
                                              'assets/icons/icon_warning_large.svg',
                                              width: 40,
                                              height: 40,
                                              colorFilter: const ColorFilter.mode(
                                                  DaepiroColorStyle.g_75,
                                                  BlendMode.srcIn),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                                "행동요령 준비중",
                                                style: DaepiroTextStyle.h6.copyWith(
                                                  color: DaepiroColorStyle.g_300,
                                                )
                                            ),
                                            Text(
                                                "더 많은 재난에 대처할 수 있도록\n행동요령을 준비해둘게요.",
                                                style: DaepiroTextStyle.body_2_m
                                                    .copyWith(
                                                  color: DaepiroColorStyle.g_300,
                                                ),
                                                textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16)
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "주변 대피소",
                                    style: DaepiroTextStyle.h6.copyWith(
                                      color: DaepiroColorStyle.g_900,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (viewModel.shelterList.isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        context.push(
                                            '/aroundShelter',
                                            extra: AroundShelterExtra(
                                                latitude: viewModel.latitude,
                                                longitude: viewModel.longitude,
                                                address: viewModel.shelterLocation,
                                                earthquakeShelterList: viewModel.earthquakeShelterList,
                                                tsunamiShelterList: viewModel.tsunamiShelterList,
                                                civilShelterList: viewModel.civilShelterList,
                                                temperatureShelterList: viewModel.temperatureShelterList,
                                            )
                                        );
                                      },
                                      child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "더보기",
                                              style: DaepiroTextStyle.body_2_m.copyWith(
                                                color: DaepiroColorStyle.o_400,
                                              ),
                                            ),
                                            SvgPicture.asset('assets/icons/icon_arrow_right.svg')
                                          ]
                                      ),
                                    )
                                ]
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                for (int index=0;index<Const.disasterTypeList.length;index++)
                                  Row(
                                    children: [
                                      SecondaryChip(
                                          isSelected: index == selectedDisasterType,
                                          text: Const.disasterTypeList[index],
                                          onPressed: () {
                                            ref.read(homeStateNotifierProvider.notifier).selectAroundShelterType(index);
                                            setState(() {
                                              selectedDisasterType = index;
                                            });
                                            _aroundShelterPageController.animateToPage(
                                                0,
                                                duration: const Duration(milliseconds: 1),
                                                curve: Curves.easeIn
                                            );
                                          }
                                      ),
                                      const SizedBox(width: 8)
                                    ],
                                  )
                              ],
                            ),
                          ),
                          if (viewModel.isLoadingShelters)
                            Container(
                                padding: const EdgeInsets.symmetric(vertical: 48),
                                child: const Center(child: CircularProgressIndicator())
                            )
                          else
                            if (viewModel.shelterList.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: ExpandablePageView.builder(
                                    controller: _aroundShelterPageController,
                                    scrollDirection: Axis.horizontal,
                                    padEnds: false,
                                    itemCount: 5,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                          padding: const EdgeInsets.only(top: 16, bottom: 20),
                                          margin: const EdgeInsets.only(right: 8),
                                          child: AroundShelterPreview(
                                              name: viewModel.shelterList[index].name ?? "",
                                              distinct: viewModel.shelterList[index].distance ?? 0,
                                              address: viewModel.shelterList[index].address ?? "",
                                              startLatitude: viewModel.latitude,
                                              startLongitude: viewModel.longitude,
                                              endLatitude: viewModel.shelterList[index].latitude ?? 0,
                                              endLongitude: viewModel.shelterList[index].longitude ?? 0
                                          )
                                      );
                                    }
                                ),
                              )
                            else
                              Container(
                                  padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
                                  child: const NotLocationPermissionWidget()
                              )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        child: Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "최근 재난문자 히스토리",
                                    style: DaepiroTextStyle.h6.copyWith(
                                      color: DaepiroColorStyle.g_900,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      context.push('/disastersHistory');
                                    },
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "더보기",
                                            style: DaepiroTextStyle.body_2_m.copyWith(
                                              color: DaepiroColorStyle.o_400,
                                            ),
                                          ),
                                          SvgPicture.asset('assets/icons/icon_arrow_right.svg')
                                        ]
                                    ),
                                  )
                                ]
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                  color: DaepiroColorStyle.g_50,
                                ),
                              ),
                              child: viewModel.isLoadingDisasterHistory
                                  ? Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: const Center(child: CircularProgressIndicator())
                                    )
                                  : viewModel.disasterHistoryList.isEmpty
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 60),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "최근 재난문자 내역이 없습니다.",
                                        style: DaepiroTextStyle.body_2_b.copyWith(
                                          color: DaepiroColorStyle.g_200,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: viewModel.disasterHistoryList
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  if (index != 0)
                                                    const SizedBox(height: 8),
                                                  GestureDetector(
                                                    onTap: () {
                                                      context.push(
                                                          '/disasterDetail',
                                                          extra: Disasters(
                                                            disasterType: viewModel.disasterHistoryList[index].disasterType,
                                                            disasterTypeId: viewModel.disasterHistoryList[index].disasterTypeId,
                                                            title: viewModel.disasterHistoryList[index].title?.replaceAll("기타", "기타 재난"),
                                                            content: viewModel.disasterHistoryList[index].content,
                                                            time: viewModel.disasterHistoryList[index].time,
                                                          )
                                                      );
                                                    },
                                                    child: DisasterHistoryPreview(
                                                        disasterType: viewModel.disasterHistoryList[index].disasterType ?? "",
                                                        title: viewModel.disasterHistoryList[index].title?.replaceAll("기타", "기타 재난") ?? "",
                                                        date: formatDateToDateTime(viewModel.disasterHistoryList[index].time ?? "")
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ),
          ],
        )
    );
  }
}