import 'package:daepiro/data/model/response/home/disasters_history_response.dart';
import 'package:daepiro/data/model/response/sponsor/sponsor_list_response.dart';
import 'package:daepiro/presentation/community/screens/town/community_photo_screen.dart';
import 'package:daepiro/presentation/home/main/notification_screen.dart';
import 'package:daepiro/presentation/information/contents/disaster_contents_screen.dart';
import 'package:daepiro/presentation/information/contents/news_screen.dart';
import 'package:daepiro/presentation/information/emergency_response/emergency_response_screen.dart';
import 'package:daepiro/presentation/information/contents/search/search_disaster_contents_screen.dart';
import 'package:daepiro/presentation/information/behavior_tip/search/search_disaster_type_screen.dart';
import 'package:daepiro/presentation/community/screens/community_rule_screen.dart';
import 'package:daepiro/presentation/information/shelter/around_shelter_extra.dart';
import 'package:daepiro/presentation/onboarding/screens/juso_input_screen.dart';
import 'package:daepiro/presentation/onboarding/screens/onboarding_third_screen.dart';
import 'package:daepiro/presentation/sponsor/cheer_report_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../data/model/response/community/community_dongnae_content_detail_response.dart';
import '../data/model/response/information/behavior_list_response.dart';
import '../presentation/community/screens/community_main_screen.dart';
import '../presentation/community/screens/town/community_report_screen.dart';
import '../presentation/community/screens/town/community_town_detail_screen.dart';
import '../presentation/community/screens/town/community_town_writing_screen.dart';
import '../presentation/home/history/disaster_detail_screen.dart';
import '../presentation/home/history/disasters_history_screen.dart';
import '../presentation/community/screens/town/gallery_view_screen.dart';
import '../presentation/community/screens/town/town_certificate_screen.dart';
import '../presentation/home/main/home_screen.dart';
import '../presentation/information/behavior_tip/behavior_tips_screen.dart';
import '../presentation/information/main/information_screen.dart';
import '../presentation/information/shelter/around_shelter_screen.dart';
import '../presentation/login/login_screen.dart';
import '../presentation/mypage/screens/mypage_alarm_setting_screen.dart';
import '../presentation/mypage/screens/mypage_announcement_detail_screen.dart';
import '../presentation/mypage/screens/mypage_announcement_screen.dart';
import '../presentation/mypage/screens/mypage_disaster_address_setting_screen.dart';
import '../presentation/mypage/screens/mypage_disaster_type_setting_screen.dart';
import '../presentation/mypage/screens/mypage_fix_userinfo_screen.dart';
import '../presentation/mypage/screens/mypage_inquires_screen.dart';
import '../presentation/mypage/screens/mypage_screen.dart';
import '../presentation/mypage/screens/mypage_user_withdraw_screen.dart';
import '../presentation/mypage/screens/mypage_user_writing_screen.dart';
import '../presentation/onboarding/screens/onboarding_fifth_screen.dart';
import '../presentation/onboarding/screens/onboarding_final_screen.dart';
import '../presentation/onboarding/screens/onboarding_first_screen.dart';
import '../presentation/onboarding/screens/onboarding_fourth_screen.dart';
import '../presentation/onboarding/screens/onboarding_second_screen.dart';
import '../presentation/onboarding/screens/onboarding_term_screen.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/sponsor/cheer_screen.dart';
import '../presentation/sponsor/sponsor_detail_screen.dart';
import '../presentation/sponsor/sponsor_screen.dart';
import 'main_navigation.dart';

//navigatorstate로 접근할 수 있게 해주어 앱내 화면이동 가능
//루트 네비게이터와 별도의 네비게이션 키를 설정하는 부분
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _communityNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'community');
final _informationNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'information');
final _sponsorNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sponsor');
final _mypageNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'mypage');
const FlutterSecureStorage storage = FlutterSecureStorage();

//중간에 토큰 만료시 로직은 개선해야함
Future<String?> checkRedirect(BuildContext context, GoRouterState state) async {
  String current = state.uri.path;
  if (current != '/splash') {
    await Future.delayed(const Duration(seconds: 3));
    String? accessToken = await storage.read(key: 'accessToken');
    String? refreshToken = await storage.read(key: 'refreshToken');
    if ((accessToken == null && refreshToken == null) ||
        accessToken == "" && refreshToken == "") {
      return '/login';
    }
    return '/home';
  } else {
    return null;
  }
}

final goRouteProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/splash',
    // initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
          path: '/onboarding_terms/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '0';
            return OnboardingTermScreen(id: id);
          }),
      GoRoute(
          path: '/community_rule',
          builder: (context, state) => const CommunityRuleScreen()),
      GoRoute(
          path: '/community_town_detail',
          builder: (context, state) {
            final fromMyPage = state.extra as Map<String, bool>? ?? {'fromMyPage': false};
            return CommunityTownDetailScreen(
                fromMyPage: fromMyPage['fromMyPage'],
            );
          }),
      GoRoute(
          path: '/community_town_writing_album',
          builder: (context, state) => GalleryViewScreen()),
      GoRoute(
          path: '/community_report_screen/:id/:isArticle',
          builder: (context, state) {
            return CommunityReportScreen(
              id: int.tryParse(state.pathParameters['id'] ?? '0'),
              isArticle: state.pathParameters['isArticle'] == 'true',
            );
          }),
      GoRoute(
        path: '/community_town_writing',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final isEdit = extra['isEdit'] as bool? ?? false;
          final contentDetail = extra['contentDetail'] as ContentDetail?;
          return CommunityTownWritingScreen(
            isEdit: isEdit,
            contentDetail: contentDetail,
          );
        },
      ),
      GoRoute(
          path: '/community_photo_screen',
          builder: (context, state) => CommunityPhotoScreen(
              fileList: state.extra as List<String>
          )
      ),
      GoRoute(
          path: '/town_certificate',
          builder: (context, state) => TownCertificateScreen()),
      GoRoute(
          path: '/mypage_fix_userinfo',
          builder: (context, state) => MyPageFixUserinfoScreen()),
      GoRoute(
          path: '/mypage_fix_alarminfo',
          builder: (context, state) => MyPageAlarmSettingScreen()),
      GoRoute(
          path: '/mypage_setting_address',
          builder: (context, state) => MypageDisasterAddressSettingScreen()),
      GoRoute(
          path: '/mypage_setting_disaster_type',
          builder: (context, state) => MypageDisasterTypeSettingScreen()),
      GoRoute(
          path: '/mypage_user_writing',
          builder: (context, state) => MyPageUserWritingScreen()),
      GoRoute(
          path: '/mypage_inquires',
          builder: (context, state) => MyPageInquiresScreen()),
      GoRoute(
          path: '/mypage_withdraw',
          builder: (context, state) => MyPageUserWithDrawScreen()),
      GoRoute(
          path: '/mypage_announcement',
          builder: (context, state) => MypageAnnouncementScreen()),
      GoRoute(
          path: '/mypage_announcement_detail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '0';
            return MypageAnnouncementDetailScreen(id: id);
          }),
      GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingFirstScreen(),
          routes: [
            GoRoute(
                path: 'first',
                builder: (context, state) => const OnboardingSecondScreen()),
            GoRoute(
                path: 'second',
                builder: (context, state) => const OnboardingThirdScreen()),
            GoRoute(
                path: 'juso/:type/:index/:userNickName',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>? ?? {};
                  final type = state.pathParameters['type'];
                  final index = state.pathParameters['index'];
                  final userNickName = state.pathParameters['userNickName'];
                  final fromMyPage = extra['fromMyPage'] as bool? ?? false;
                  return JusoInputScreen(type: type, index: index, userNickName: userNickName, fromMyPage: fromMyPage);
                }),
            GoRoute(
                path: 'third',
                builder: (context, state) => OnboardingFourthScreen()),
            GoRoute(
                path: 'fourth',
                builder: (context, state) => OnboardingFifthScreen()),
            GoRoute(
                path: 'final',
                builder: (context, state) => OnboardingFinalScreen()),
          ]),
      GoRoute(
          path: '/behaviorTips',
          builder: (context, state) => BehaviorTipsScreen()
      ),
      GoRoute(
          path: '/emergencyResponse',
          builder: (context, state) => EmergencyResponseScreen()
      ),
      GoRoute(
          path: '/disasterContents',
          builder: (context, state) => DisasterContentsScreen()
      ),
      GoRoute(
          path: '/searchDisasterContents',
          builder: (context, state) => SearchDisasterContentsScreen()
      ),
      GoRoute(
        path: '/aroundShelter',
        builder: (context, state) => AroundShelterScreen(
            extra: state.extra as AroundShelterExtra
        ),
      ),
      GoRoute(
          path: '/searchDisasterType',
          builder: (context, state) => SearchDisasterTypeScreen(
              behaviorList: state.extra as List<Behavior>
          )
      ),
      GoRoute(
        path: '/sponsorDetail',
        builder: (context, state) => SponsorDetailScreen(
            extra: state.extra as Sponsor
        ),
      ),
      GoRoute(
        path: '/cheer',
        builder: (context, state) => CheerScreen(),
      ),
      GoRoute(
        path: '/cheerReport/:id',
        builder: (context, state) {
          return CheerReportScreen(id: int.tryParse(state.pathParameters['id'] ?? '0'));
        },
      ),
      GoRoute(
        path: '/news/:url',
        builder: (context, state) {
          return NewsScreen(url: Uri.decodeComponent(state.pathParameters['url'] ?? ""));
        }),
      GoRoute(
        path: '/disastersHistory',
        builder: (context, state) => const DisastersHistoryScreen(),
      ),
      GoRoute(
        path: '/disasterDetail',
        builder: (context, state) => DisasterDetailScreen(
            extra: state.extra as Disasters
        ),
      ),
      GoRoute(
        path: '/notification',
        builder: (context, state) => const NotificationScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigation(navigationShell: navigationShell);
        },
        parentNavigatorKey: _rootNavigatorKey,
          branches:[
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                    path: '/home',
                    builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _communityNavigatorKey,
              routes: [
                GoRoute(
                  path: '/community',
                  builder: (context, state) => const CommunityMainScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _informationNavigatorKey,
              routes: [
                GoRoute(
                  path: '/information',
                  builder: (context, state) => InformationScreen(),
                  routes: [


                  ]
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _sponsorNavigatorKey,
              routes: [
                GoRoute(
                  path: '/sponsor',
                  builder: (context, state) => const SponsorScreen(),
                ),

              ],
            ),
            StatefulShellBranch(
              navigatorKey: _mypageNavigatorKey,
              routes: [
                GoRoute(
                  path: '/mypage',
                  builder: (context, state) => const MypageScreen(),
                ),
              ],
            ),
          ],
      )
    ],
  );
});