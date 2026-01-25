import 'package:daepiro/presentation/community/controller/community_town_view_model.dart';
import 'package:daepiro/presentation/mypage/controller/mypage_viewmodel.dart';
import 'package:daepiro/resource/message/AppResources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../cmm/theme/DaepiroTheme.dart';
import '../resource/resource.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  final StatefulNavigationShell navigationShell;

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      body: widget.navigationShell,
      currentIndex: widget.navigationShell.currentIndex,
      onDestinationSelected: (index) async {
        if(index != widget.navigationShell.currentIndex) {
          widget.navigationShell.goBranch(index);
          if(index == 4) {
            await ref.read(myPageProvider.notifier).getMyProfiles();
          } else if(index == 1) {
            await ref.read(communityTownProvider.notifier).setUserAddressList();
          }
        }
      },
    );
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: Container (
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: DaepiroColorStyle.g_75, width: 2),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: MediaQuery.of(context).size.height * 0.099,
            backgroundColor: DaepiroColorStyle.white,
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) {
                  if(states.contains(MaterialState.selected)) {
                    return DaepiroTextStyle.caption.copyWith(color: DaepiroColorStyle.g_600);
                  }
                  return DaepiroTextStyle.caption.copyWith(color: DaepiroColorStyle.g_100);
                },
            ),
            iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
                (Set<MaterialState> states) {
                  if(states.contains(MaterialState.selected)) {
                    return IconThemeData(color: DaepiroColorStyle.g_600);
                  }
                  return IconThemeData(color: DaepiroColorStyle.g_100);
                }
            ),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: NavigationBar(
              selectedIndex: currentIndex,
              destinations: [
                NavigationDestination(
                  icon: Resource.images.iconHome.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_100, BlendMode.srcIn),
                  ),
                  selectedIcon: Resource.images.iconHome.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_600, BlendMode.srcIn),
                  ),
                  label: AppResources.MainNavigation_homeLabel,
                ),
                NavigationDestination(
                  icon: Resource.images.iconCommunity.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_100, BlendMode.srcIn),
                  ),
                  selectedIcon: Resource.images.iconCommunity.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_600, BlendMode.srcIn),
                  ),
                  label: AppResources.MainNavigation_communityLabel,
                ),
                NavigationDestination(
                  icon: Resource.images.iconInfo.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_100, BlendMode.srcIn),
                  ),
                  selectedIcon: Resource.images.iconInfo.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_600, BlendMode.srcIn),
                  ),
                  label: AppResources.MainNavigation_informationLabel,
                ),
                NavigationDestination(
                  icon: Resource.images.iconFunding.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_100, BlendMode.srcIn),
                  ),
                  selectedIcon: Resource.images.iconFunding.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_600, BlendMode.srcIn),
                  ),
                  label: AppResources.MainNavigation_fundingLabel,
                ),
                NavigationDestination(
                  icon: Resource.images.iconMy.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_100, BlendMode.srcIn),
                  ),
                  selectedIcon: Resource.images.iconMy.svg(
                    colorFilter: ColorFilter.mode(DaepiroColorStyle.g_600, BlendMode.srcIn),
                  ),
                  label: AppResources.MainNavigation_mypageLabel,
                ),
              ],
              onDestinationSelected: (index) {
                if (index != currentIndex) onDestinationSelected(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}