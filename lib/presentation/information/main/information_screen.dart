import 'package:daepiro/presentation/home/component/not_location_permission_widget.dart';
import 'package:daepiro/presentation/information/component/disaster_contents_main_item.dart';
import 'package:daepiro/presentation/information/main/information_view_model.dart';
import 'package:daepiro/presentation/information/shelter/around_shelter_extra.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/chip/secondary_chip.dart';
import '../../home/component/around_shelter_preview.dart';
import '../../const/const.dart';

class InformationScreen extends ConsumerWidget {
  InformationScreen({super.key});

  final PageController _disasterContentPageController = PageController(
    initialPage: 0,
    viewportFraction: 0.9
  );
  final PageController _aroundShelterPageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(informationStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: DaepiroColorStyle.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "재난 정보",
                      style: DaepiroTextStyle.h6.copyWith(
                        color: DaepiroColorStyle.g_800,
                      ),
                    )
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "재난 콘텐츠",
                                style: DaepiroTextStyle.h6.copyWith(
                                  color: DaepiroColorStyle.g_900,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  context.push('/disasterContents');
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
                        if (viewModel.isLoadingContents)
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 48),
                              child: const Center(child: CircularProgressIndicator())
                          )
                        else
                          if (viewModel.contentsList.isNotEmpty)
                            ExpandablePageView(
                              controller: _disasterContentPageController,
                              scrollDirection: Axis.horizontal,
                              padEnds: false,
                              children: [
                                for (int i=0;i<viewModel.contentsList.length;i++)
                                  Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            context.push('/news/${Uri.encodeComponent(viewModel.contentsList[i].bodyUrl ?? "")}');
                                          },
                                          child: DisasterContentsMainItem(
                                              type: "실시간 뉴스",
                                              title: viewModel.contentsList[i].title ?? "",
                                              source: viewModel.contentsList[i].source ?? "",
                                              date: viewModel.contentsList[i].publishedAt ?? "",
                                              thumbnailUrl: viewModel.contentsList[i].thumbnailUrl ?? "",
                                              bodyUrl: viewModel.contentsList[i].bodyUrl ?? ""
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                        const SizedBox(height: 12),
                        Center(
                          child: SmoothPageIndicator(
                            controller: _disasterContentPageController,
                            count: viewModel.contentsList.length,
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
                        const SizedBox(height: 32),
                        Column(
                          children: [
                            Row(
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
                                                address: viewModel.myLocation,
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
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                for (int index = 0; index < Const.disasterTypeList.length; index++)
                                  Row(
                                    children: [
                                      SecondaryChip(
                                          isSelected: index == viewModel.selectedAroundShelterType,
                                          text: Const.disasterTypeList[index],
                                          onPressed: () {
                                            ref.read(informationStateNotifierProvider.notifier).selectAroundShelterType(index);
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
                            if (viewModel.isLoadingShelters)
                              Container(
                                  padding: const EdgeInsets.symmetric(vertical: 48),
                                  child: const Center(child: CircularProgressIndicator())
                              )
                            else
                              if (viewModel.shelterList.isNotEmpty)
                                ExpandablePageView.builder(
                                    controller: _aroundShelterPageController,
                                    scrollDirection: Axis.horizontal,
                                    padEnds: false,
                                    itemCount: viewModel.shelterList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        padding: const EdgeInsets.only(top: 16),
                                        margin: const EdgeInsets.only(right: 8),
                                        child: AroundShelterPreview(
                                            name: viewModel.shelterList[index].name ?? "",
                                            distinct: viewModel.shelterList[index].distance ?? 0,
                                            address: viewModel.shelterList[index].address ?? "",
                                            startLatitude: viewModel.latitude,
                                            startLongitude: viewModel.longitude,
                                            endLatitude: viewModel.shelterList[index].latitude ?? 0,
                                            endLongitude: viewModel.shelterList[index].longitude ?? 0
                                        ),
                                      );
                                    }
                                )
                              else
                                Container(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: const NotLocationPermissionWidget()
                                )
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.push('/emergencyResponse');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: DaepiroColorStyle.g_50,
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "응급대처",
                                          style: DaepiroTextStyle.body_1_b.copyWith(
                                            color: DaepiroColorStyle.g_800,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "응급상황 발생시\n대처방법을 알아두세요.",
                                          style: DaepiroTextStyle.caption.copyWith(
                                            color: DaepiroColorStyle.g_400,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Image.asset('assets/icons/image_siren.png', width: double.infinity, height: 55, fit: BoxFit.cover)
                                      ]
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.push('/behaviorTips');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: DaepiroColorStyle.g_50,
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "행동요령",
                                          style: DaepiroTextStyle.body_1_b.copyWith(
                                            color: DaepiroColorStyle.g_800,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "재난 별 대처 행동요령을\n미리 알아두세요.",
                                          style: DaepiroTextStyle.caption.copyWith(
                                            color: DaepiroColorStyle.g_400,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Image.asset('assets/icons/image_warning.png', width: double.infinity, height: 55, fit: BoxFit.cover)
                                      ]
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}