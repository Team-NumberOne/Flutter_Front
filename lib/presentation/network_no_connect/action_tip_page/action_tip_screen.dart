import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daepiro/data/model/response/information/behavior_list_response.dart';
import 'action_tip_viewmodel.dart';
import '../../../cmm/DaepiroTheme.dart';
import '../../information/component/behavior_tip_bottom_sheet.dart';
import '../../information/component/disaster_type.dart';

class BehaviorTipNoNetworkScreen extends ConsumerStatefulWidget {
  const BehaviorTipNoNetworkScreen({super.key});

  @override
  ConsumerState<BehaviorTipNoNetworkScreen> createState() => _BehaviorTipNoNetworkScreenState();
}

class _BehaviorTipNoNetworkScreenState extends ConsumerState<BehaviorTipNoNetworkScreen> with SingleTickerProviderStateMixin {
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
    final viewModel = ref.watch(actionTipStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                _drawBody(viewModel.emergencyBehaviorList, viewModel.commonBehaviorList)
              ],
            ),
          )
      ),
    );
  }

  Widget _drawBody(List<Behavior> emergencyList, List<Behavior> commonList) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Text(
                '행동요령',
                style: DaepiroTextStyle.h6.copyWith(
                  color: DaepiroColorStyle.g_800,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
            ],
          ),
          _tabHeader(),
          Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _emergencyDisaster(emergencyList),
                  _basicDisaster(commonList),
                ],
              )
          )
        ],
      ),
    );
  }

  Widget _tabHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TabBar(
            controller: _tabController,
            labelColor: DaepiroColorStyle.g_800,
            labelStyle: DaepiroTextStyle.body_1_m,
            labelPadding: const EdgeInsets.symmetric(vertical: 12),
            unselectedLabelColor: DaepiroColorStyle.g_300,
            unselectedLabelStyle: DaepiroTextStyle.body_1_m,
            dividerColor: DaepiroColorStyle.white,
            indicatorColor: DaepiroColorStyle.g_800,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(
                child: Text("위급/긴급 재난"),
              ),
              Tab(
                child: Text("일반재난"),
              )
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
    );
  }

  Widget _emergencyDisaster(List<Behavior> emergencyBehaviorList) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20,20,20,0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                    color: DaepiroColorStyle.g_50,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '수신권장',
                        style: DaepiroTextStyle.body_1_b.copyWith(
                          color: DaepiroColorStyle.o_500,
                        )
                    ),
                    const SizedBox(height: 4),
                    Text(
                        '국가적 위기상황이나 당장 대피가 필요할만큼\n생명에 위협이 되는 재난이에요.',
                        style: DaepiroTextStyle.body_2_m.copyWith(
                          color: DaepiroColorStyle.g_800,
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20,20,20,20),
            child: GridView.builder(
                itemCount: emergencyBehaviorList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8
                ),
                itemBuilder: (context, index) {
                  return DisasterType(
                    name: emergencyBehaviorList[index].name ?? "",
                    onClick: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return BehaviorTipBottomSheet(
                              behavior: emergencyBehaviorList[index],
                            );
                          }
                      );
                    },
                  );
                }
            ),
          ),
        )
      ],
    );
  }

  Widget _basicDisaster(List<Behavior> commonBehaviorList) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20,20,20,0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                    color: DaepiroColorStyle.g_50,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '기상 특보와 같이 안전 주의를 요하는 재난입니다.',
                        style: DaepiroTextStyle.body_2_m.copyWith(
                          color: DaepiroColorStyle.g_800,
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20,20,20,20),
            child: GridView.builder(
                itemCount: commonBehaviorList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8
                ),
                itemBuilder: (context, index) {
                  return DisasterType(
                    name: commonBehaviorList[index].name ?? "",
                    onClick: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return BehaviorTipBottomSheet(
                              behavior: commonBehaviorList[index],
                            );
                          }
                      );
                    },
                  );
                }
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}