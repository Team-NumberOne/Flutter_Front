import 'package:daepiro/data/model/response/home/disasters_history_response.dart';
import 'package:daepiro/presentation/const/const.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/chip/secondary_chip.dart';
import '../../const/utils.dart';
import '../../information/shelter/around_shelter_extra.dart';
import '../component/action_tip_item.dart';
import '../component/around_shelter_preview.dart';
import '../component/not_location_permission_widget.dart';
import '../main/home_view_model.dart';

class DisasterDetailScreen extends ConsumerStatefulWidget {
  final Disasters extra;

  const DisasterDetailScreen({
    super.key,
    required this.extra
  });

  @override
  _DisasterDetailScreenState createState() => _DisasterDetailScreenState();
}

class _DisasterDetailScreenState extends ConsumerState<DisasterDetailScreen> {
  final PageController _aroundShelterPageController = PageController(
    initialPage: 0,
    viewportFraction: 0.9
  );
  int _selectedActionTipType = 0;
  int _selectedDisasterType = 0;

  late HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();
    homeViewModel = ref.read(homeStateNotifierProvider.notifier);
    ref.read(homeStateNotifierProvider.notifier).getBehaviorTips(widget.extra.disasterTypeId.toString());
  }

  @override
  void dispose() {
    homeViewModel.disposeDisasterDetail();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: SvgPicture.asset('assets/icons/icon_arrow_left.svg')
                        ),
                      )
                    ]
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
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
                                  findDisasterIconByName(name: widget.extra.disasterType ?? ""),
                                  width: 26,
                                  height: 26,
                                  colorFilter: const ColorFilter.mode(DaepiroColorStyle.o_500, BlendMode.srcIn),
                                )
                            ),
                            const SizedBox(height: 8),
                            getLargeHighlightText(title: widget.extra.title ?? "", disaster: widget.extra.disasterType ?? ""),
                            const SizedBox(height: 8),
                            Text(
                              widget.extra.content ?? "",
                              style: DaepiroTextStyle.body_2_m.copyWith(
                                color: DaepiroColorStyle.g_500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              formatDateToDateTime(widget.extra.time ?? ""),
                              style: DaepiroTextStyle.caption.copyWith(
                                color: DaepiroColorStyle.g_300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 4,
                        color: DaepiroColorStyle.g_50,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                  color: DaepiroColorStyle.g_50,
                                ),
                              ),
                              child: Column(
                                children: [
                                  viewModel.behaviorTip != null && viewModel.behaviorTip!.tips!.isNotEmpty
                                    ? Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Row(
                                              children: [
                                                for (int index=0;index<viewModel.behaviorTip!.tips!.length;index++)
                                                  Row(
                                                    children: [
                                                      SecondaryChip(
                                                          isSelected: index == _selectedActionTipType,
                                                          text: viewModel.behaviorTip!.tips![index].filter ?? "",
                                                          onPressed: () {
                                                            setState(() {
                                                              _selectedActionTipType = index;
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
                                          for (int index=0;index<viewModel.behaviorTip!.tips![_selectedActionTipType].tips!.length;index++)
                                            Column(
                                              children: [
                                                ActionTipItem(
                                                  text: viewModel.behaviorTip!.tips![_selectedActionTipType].tips![index].$1,
                                                  isSelected: viewModel.behaviorTip!.tips![_selectedActionTipType].tips![index].$2,
                                                  onClick: () {
                                                    ref.read(homeStateNotifierProvider.notifier).selectCheckList(_selectedActionTipType, index);
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
                                              colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_75, BlendMode.srcIn),
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
                                                style: DaepiroTextStyle.body_2_m.copyWith(
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
                      const SizedBox(height: 4),
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
                                          isSelected: index == _selectedDisasterType,
                                          text: Const.disasterTypeList[index],
                                          onPressed: () {
                                            ref.read(homeStateNotifierProvider.notifier).selectAroundShelterType(index);
                                            setState(() {
                                              _selectedDisasterType = index;
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
                          viewModel.shelterList.isNotEmpty
                              ? Container(
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
                              : Container(
                                    padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 20),
                                    child: const NotLocationPermissionWidget()
                                )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
