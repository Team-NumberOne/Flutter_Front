import 'package:daepiro/data/model/response/home/disasters_history_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/chip/secondary_chip.dart';
import '../component/disaster_history_item.dart';
import '../main/home_view_model.dart';

class DisastersHistoryScreen extends ConsumerStatefulWidget {
  const DisastersHistoryScreen({super.key});

  @override
  _DisasterMessageHistoryScreen createState() => _DisasterMessageHistoryScreen();
}

class _DisasterMessageHistoryScreen extends ConsumerState<DisastersHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(homeStateNotifierProvider.notifier).getDisastersHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
                          child: SvgPicture.asset(
                            'assets/icons/icon_arrow_left.svg',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        child: Text(
                          "재난문자 히스토리",
                          style: DaepiroTextStyle.h6.copyWith(
                            color: DaepiroColorStyle.g_800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 4, 0, 8),
                    child: Row(
                      children: [
                        for (int i=0;i<viewModel.disastersList.length;i++)
                          Row(
                            children: [
                              SecondaryChip(
                                  isSelected: i == viewModel.selectedDisasterHistoryType,
                                  text: viewModel.disastersList[i].region ?? "",
                                  onPressed: () {
                                    _scrollController.animateTo(
                                      0.0,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                    ref.read(homeStateNotifierProvider.notifier).selectDisasterHistoryType(i);
                                  }
                              ),
                              const SizedBox(width: 8)
                            ],
                          )
                      ],
                    ),
                  ),
                  viewModel.historyIsLoading
                      ? Container(
                            padding: const EdgeInsets.only(top: 100),
                            child: const Center(child: CircularProgressIndicator())
                        )
                      : viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters!.isNotEmpty
                          ? Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: viewModel.disastersList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              DisasterHistoryItem(
                                                icon: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].disasterType ?? "",
                                                title: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].title?.replaceAll("기타", "기타 재난") ?? "",
                                                contents: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].content ?? "",
                                                date: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].time ?? "",
                                                isVisibleDate: index == 0
                                                    ? true
                                                    : index != 0 && (
                                                    viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].time?.split("T")[0]
                                                        != viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index-1].time?.split("T")[0]
                                                ),
                                                onClick: () {
                                                  context.push(
                                                      '/disasterDetail',
                                                      extra: Disasters(
                                                        disasterType: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].disasterType,
                                                        disasterTypeId: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].disasterTypeId,
                                                        title: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].title?.replaceAll("기타", "기타 재난"),
                                                        content: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].content,
                                                        time: viewModel.disastersList[viewModel.selectedDisasterHistoryType].disasters?[index].time,
                                                      )
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          );
                                        }
                                    );
                                  },
                                ),
                              )
                            )
                          : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/icon_warning_large.svg',
                                    width: 48,
                                    height: 48,
                                    colorFilter: const ColorFilter.mode(
                                        DaepiroColorStyle.g_75,
                                        BlendMode.srcIn
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                      "최근 한달 간\n재난문자 내역이 없어요",
                                      style: DaepiroTextStyle.h6.copyWith(
                                        color: DaepiroColorStyle.g_300,
                                      ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                          )
                ],
              )
          ),
        )
    );
  }
}
