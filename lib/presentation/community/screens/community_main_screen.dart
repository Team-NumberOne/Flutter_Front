import 'package:daepiro/presentation/community/controller/community_disaster_view_model.dart';
import 'package:daepiro/presentation/community/controller/community_town_view_model.dart';
import 'package:daepiro/presentation/community/screens/disaster/community_disaster_screen.dart';
import 'package:daepiro/presentation/community/screens/town/community_town_address_menu_screen.dart';
import 'package:daepiro/presentation/community/screens/town/community_town_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../state/community_disaster_state.dart';

//커뮤니티 메인화면
class CommunityMainScreen extends ConsumerStatefulWidget {
  final bool? fromHome;
  const CommunityMainScreen({super.key, this.fromHome});

  @override
  _CommunityMainScreenState createState() => _CommunityMainScreenState();
}
class _CommunityMainScreenState extends ConsumerState<CommunityMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final disasterViewModel = ref.read(communityDisasterProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromHome == true) {
        setState(() {
          _tabController.index = 1;
          disasterViewModel.changeScreenState(false);
        });
      }
    });

    _tabController.addListener(() {
      if (_tabController.index == 1) {
        ref.read(communityDisasterProvider.notifier).changeScreenState(false);
      } else {
        ref.read(communityDisasterProvider.notifier).changeScreenState(true);
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityDisasterProvider);
    final townState = ref.watch(communityTownProvider);
    final disasterViewModel = ref.read(communityDisasterProvider.notifier);

    ref.listen<CommunityDisasterState>(communityDisasterProvider, (previous, next) {
      if(next.fromHome) {
        _tabController.index = 1;
        disasterViewModel.setStateFromHomeScreen(false);
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            communityHeader(state.isDisasterScreen, townState.selectTown, context),
            TabBar(
              controller: _tabController,
              padding: EdgeInsets.zero,
              splashFactory: NoSplash.splashFactory,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.0,
                  color: DaepiroColorStyle.g_800,
                ),
                insets: EdgeInsets.symmetric(
                    horizontal: 100.0),
              ),
              indicatorWeight: 2,
              labelStyle: DaepiroTextStyle.body_1_m,
              labelColor: DaepiroColorStyle.g_800,
              unselectedLabelColor: DaepiroColorStyle.g_300,
              labelPadding: const EdgeInsets.symmetric(vertical: 5),
              tabs: [Tab(text: '재난상황'), Tab(text: '동네생활')],
            ),
            Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    CommunityDisasterScreen(),
                    CommunityTownScreen()
                  ],
                ))
          ],
        ),
      )),
    );
  }

  Widget disasterHeaderWidget() {
    return Container(
        child: Row(
      children: [
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Text(
            '커뮤니티',
            style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800),
          ),
        )
      ],
    ));
  }

  Widget townHeaderWidget(String address, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              goToMenu(context);
            },
            child: Row(
              children: [
                Text(address,
                  style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                    'assets/icons/icon_arrow_down.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)),
              ],
            ),
          ),
          const Spacer(),
          TextButton(
              onPressed: (){
                GoRouter.of(context).push(
                    '/community_town_writing',
                  extra: {
                    'isEdit': false,
                  },
                );
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text(
                '글쓰기',
                style: DaepiroTextStyle.body_1_m.copyWith(color: DaepiroColorStyle.o_500),
              )
          )
        ],
      ),
    );
  }
  Widget communityHeader(bool tabState, String address, BuildContext context) {
    if(tabState) {
      return disasterHeaderWidget();
    } else {
      return townHeaderWidget(address,context);
    }
  }

  void goToMenu(BuildContext context) {
    showDialog(
      useSafeArea: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (context) {
          return CommunityTownAddressMenuScreen();
        });
  }
}
