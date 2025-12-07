import 'dart:async';
import 'dart:ui';
import 'package:daepiro/cmm/button/primary_filled_button.dart';
import 'package:daepiro/presentation/community/controller/community_town_view_model.dart';
import 'package:daepiro/presentation/community/controller/town_certificate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../cmm/DaepiroTheme.dart';
import '../../../../cmm/button/secondary_filled_button.dart';
import '../../state/town_certificate_state.dart';

class TownCertificateScreen extends ConsumerStatefulWidget {
  const TownCertificateScreen({super.key});

  @override
  TownCertificateScreenState createState() => TownCertificateScreenState();
}

class TownCertificateScreenState extends ConsumerState<TownCertificateScreen>
    with WidgetsBindingObserver {
  String selectAddress = '';
  bool isFirstDialogAppear = false;
  bool isSecondDialogAppear = false;
  // NMarker? currentMarker;
  // late NaverMapController _mapController;
  //late VideoPlayerController controller;

  bool isvalue = true;

  @override
  void initState() {
    super.initState();
    // controller = controller =
    //     VideoPlayerController.asset('assets/videos/badge_video.mp4')
    //       ..initialize()
    //       ..setLooping(true);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initMapState() async {
    final townState = ref.watch(communityTownProvider);

    final townViewModel = ref.read(townCertificateProvider.notifier);

    await townViewModel.getUserLocation();
    await townViewModel.setCertificate(townState.townLongAddressList);
    final state = ref.watch(townCertificateProvider);

    setState(() {
      // currentMarker = NMarker(
      //   id: 'daepiro',
      //   icon: NOverlayImage.fromAssetImage('assets/icons/icon_location_58.png'),
      //   position: NLatLng(state.latitude, state.longitude),
      // );
      // _mapController.addOverlay(currentMarker!);
    });
    // _mapController.updateCamera(NCameraUpdate.scrollAndZoomTo(
    //   target: NLatLng(state.latitude, state.longitude),
    //   zoom: 15.0,
    // ));
  }

  Future<void> _updateLocation() async {
    final state = ref.watch(townCertificateProvider);
    final townState = ref.watch(communityTownProvider);
    final viewModel = ref.read(townCertificateProvider.notifier);

    await viewModel.getUserLocation();
    await viewModel.setCertificate(townState.townLongAddressList);

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   _mapController.deleteOverlay(currentMarker!.info);
    //
    //   currentMarker = NMarker(
    //     id: 'daepiro',
    //     icon: NOverlayImage.fromAssetImage('assets/icons/icon_location_58.png'),
    //     position: NLatLng(state.latitude, state.longitude),
    //   );
    //
    //   _mapController.addOverlay(currentMarker!);
    //   _mapController.updateCamera(NCameraUpdate.scrollAndZoomTo(
    //     target: NLatLng(state.latitude, state.longitude),
    //   ));
    //   setState(() {});
    // });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) async {
    final viewModel = ref.read(townCertificateProvider.notifier);
    final state = ref.watch(townCertificateProvider);
    switch (appState) {
      case AppLifecycleState.resumed:
        await viewModel.getLocationPermissionStatus();
        if (!state.isPermissionGrant && isSecondDialogAppear && isFirstDialogAppear) {
          GoRouter.of(context).pop();
          GoRouter.of(context).pop();
        }
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    //controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(townCertificateProvider);
    final townState = ref.watch(communityTownProvider);
    final viewModel = ref.read(townCertificateProvider.notifier);

    bool isMapAppear =
        state.isPermissionGrant && !state.firstStep && !state.secondStep;

    ref.read(townCertificateProvider.notifier).getLocationPermissionStatus();

    if (state.firstStep && !isFirstDialogAppear) {
      isFirstDialogAppear = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        certificateNeedDialog(context, ref);
      });
    }
    if (state.secondStep == true && !isSecondDialogAppear) {
      isSecondDialogAppear = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectCertificateAddressDialog(context, townState.townList, ref,
            state.isPermissionGrant, townState.townLongAddressList);
      });
    }

    ref.listen<TownCertificateState>(townCertificateProvider, (previous, next) {
      if (next.isSuccessCertificate) {
        //controller.play();
      }
    });

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          Future.microtask(() {
            viewModel.clearState();
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: isMapAppear
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerWidget(context),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                addressWidget(state.selectAddress),
                                Container(
                                    width: double.infinity,
                                    height: state.isSuccessCertificate ? 317 : 411,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          left: 0,
                                          child: Container(
                                            width: double.infinity,
                                            height: state.isSuccessCertificate ? 317 : 411,
                                            child: SizedBox.shrink()
                                            // NaverMap(
                                            //   options: NaverMapViewOptions(
                                            //       initialCameraPosition:
                                            //       NCameraPosition(
                                            //           target: NLatLng(
                                            //               state.latitude,
                                            //               state.longitude),
                                            //           zoom: 15.0),
                                            //       indoorEnable: true,
                                            //       logoClickEnable: false),
                                            //   onMapReady: (controller) async {
                                            //     _mapController = controller;
                                            //   },
                                            // ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 12,
                                          right: 12,
                                          child: Visibility(
                                              visible: !state.isSuccessCertificate,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await _updateLocation();
                                                },
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: DaepiroColorStyle.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(0.12),
                                                            blurRadius: 4.0,
                                                            spreadRadius: 0.0,
                                                            offset: const Offset(0, 0))
                                                      ]),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: SvgPicture.asset(
                                                        width: 24,
                                                        height: 24,
                                                        'assets/icons/icon_reset.svg',
                                                        colorFilter: ColorFilter.mode(
                                                            DaepiroColorStyle.g_900,
                                                            BlendMode.srcIn)),
                                                  ),
                                                ),
                                              )),
                                        ),
                                        Visibility(
                                          visible: !state.isSuccessCertificate,
                                          child: Positioned(
                                              right: 68,
                                              bottom: 14,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  CustomPaint(
                                                    size: Size(250, 36),
                                                    painter: CustomBalloon(),
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Text(
                                                      '현 위치가 다른 경우 페이지를 새로고침해주세요.',
                                                      textAlign: TextAlign.center,
                                                      style: DaepiroTextStyle.caption
                                                          .copyWith(
                                                          color: DaepiroColorStyle
                                                              .g_50),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        )
                                      ],
                                    )),
                                SizedBox(height: 24),
                                locationCheckWidget(state.isSuccessCertificate),
                                if (!state.isSuccessCertificate)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      '현재 \‘${state.selectAddress}\' 동네 생활에 있어요.\n현 위치가 동네와 다르면 위치를 노출할 수 없어요.',
                                      style: DaepiroTextStyle.body_2_m
                                          .copyWith(color: DaepiroColorStyle.g_500),
                                    ),
                                  ),
                                if (state.isSuccessCertificate)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Center(
                                        child: successCertificate(selectAddress)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        state.isSuccessCertificate
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryFilledButton(
                                          backgroundColor:
                                              DaepiroColorStyle.g_700,
                                          pressedColor: DaepiroColorStyle.g_600,
                                          onPressed: () => GoRouter.of(context).go('/home'),
                                          borderRadius: 8,
                                          child: Text(
                                            '홈으로',
                                            style: DaepiroTextStyle.body_1_b
                                                .copyWith(
                                                    color:
                                                        DaepiroColorStyle.g_75),
                                          ),
                                          verticalPadding: 12),
                                    )
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryFilledButton(
                                          backgroundColor:
                                              DaepiroColorStyle.g_200,
                                          pressedColor: DaepiroColorStyle.g_200,
                                          onPressed: () => GoRouter.of(context).pop(),
                                          borderRadius: 8,
                                          child: Text(
                                            '홈으로',
                                            style: DaepiroTextStyle.body_1_b
                                                .copyWith(
                                                    color:
                                                        DaepiroColorStyle.g_75),
                                          ),
                                          verticalPadding: 12),
                                    )
                                  ],
                                ),
                              )
                      ],
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.6)),
                  )),
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: GestureDetector(
              onTap: () => GoRouter.of(context).pop(),
              child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                      DaepiroColorStyle.g_900, BlendMode.srcIn)),
            ),
          ),
          Expanded(
            child: Text(
              '동네 인증',
              textAlign: TextAlign.center,
              style:
                  DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800),
            ),
          ),
          Container(
            width: 24,
            height: 24,
          )
        ],
      ),
    );
  }

  Widget addressWidget(String address) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 19),
        child: Row(
          children: [
            Text(
              '선택한 동네',
              style: DaepiroTextStyle.body_1_b
                  .copyWith(color: DaepiroColorStyle.g_900),
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: DaepiroColorStyle.o_50),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  address,
                  style: DaepiroTextStyle.body_2_m
                      .copyWith(color: DaepiroColorStyle.o_500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //동네인증 안내 다이얼로그
  void certificateNeedDialog(BuildContext context, WidgetRef ref) {
    return basicDialog(
      context,
      Text(
        '동네 인증이 필요해요',
        style:
            DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_900),
      ),
      Text(
        textAlign: TextAlign.center,
        '동네를 인증하고 뱃지를 얻으세요.\n동네 뱃지는 투명한 정보 공유에 도움이 돼요.',
        style:
            DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_500),
      ),
      SecondaryFilledButton(
          verticalPadding: 12,
          onPressed: () {
            GoRouter.of(context).pop();
            GoRouter.of(context).pop();
          },
          radius: 8,
          backgroundColor: DaepiroColorStyle.g_50,
          pressedColor: DaepiroColorStyle.g_75,
          child: Text(
            textAlign: TextAlign.center,
            '나중에 하기',
            style: DaepiroTextStyle.body_1_b
                .copyWith(color: DaepiroColorStyle.g_700),
          )),
      SecondaryFilledButton(
          verticalPadding: 12,
          onPressed: () {
            ref.read(townCertificateProvider.notifier).setFirstStep(false);
            ref.read(townCertificateProvider.notifier).setSecondStep(true);
          },
          radius: 8,
          backgroundColor: DaepiroColorStyle.g_700,
          pressedColor: DaepiroColorStyle.g_400,
          child: Text(
            textAlign: TextAlign.center,
            '동네 인증하기',
            style: DaepiroTextStyle.body_1_b
                .copyWith(color: DaepiroColorStyle.white),
          )),
    );
  }

  void selectCertificateAddressDialog(
      BuildContext context,
      List<String> townList,
      WidgetRef ref,
      bool isPermissionGrant,
      List<String> townLongAddressList) {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
              ),
              backgroundColor: DaepiroColorStyle.white,
              titlePadding: EdgeInsets.fromLTRB(20, 24, 20, 4),
              title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '인증할 동네를 선택해주세요.',
                      style: DaepiroTextStyle.body_1_b
                          .copyWith(color: DaepiroColorStyle.g_900),
                    ),
                  ]),
              contentPadding: EdgeInsets.fromLTRB(20, 4, 20, 24),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '1개의 지역만 동네 뱃지를 얻을 수 있어요.',
                      style: DaepiroTextStyle.body_2_m
                          .copyWith(color: DaepiroColorStyle.g_500),
                    ),
                    SizedBox(height: 24),
                    ...List.generate(townList.length, (index) {
                      final selected = selectAddress == townList[index];
                      return ConstrainedBox(
                        constraints: BoxConstraints(minWidth: double.infinity),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectAddress = townList[index];
                                ref
                                    .read(townCertificateProvider.notifier)
                                    .setSelectAddress(selectAddress);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: selected
                                    ? DaepiroColorStyle.g_75
                                    : DaepiroColorStyle.g_50,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                overlayColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                shadowColor: Colors.transparent,
                                elevation: 0.0),
                            child: Text(
                              townList[index],
                              style: DaepiroTextStyle.body_1_b
                                  .copyWith(color: DaepiroColorStyle.g_700),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryFilledButton(
                              verticalPadding: 12,
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                GoRouter.of(context).pop();
                                ref
                                    .read(townCertificateProvider.notifier)
                                    .selectCertificateTown('');
                              },
                              radius: 8,
                              backgroundColor: DaepiroColorStyle.g_50,
                              pressedColor: DaepiroColorStyle.g_75,
                              child: Text(
                                textAlign: TextAlign.center,
                                '나중에 하기',
                                style: DaepiroTextStyle.body_1_b
                                    .copyWith(color: DaepiroColorStyle.g_700),
                              )),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                            child: SecondaryFilledButton(
                          onPressed: selectAddress.isNotEmpty
                              ? () async {
                                  ref
                                      .read(townCertificateProvider.notifier)
                                      .selectCertificateTown(selectAddress);
                                  ref
                                      .read(townCertificateProvider.notifier)
                                      .setSecondStep(false);
                                  if (!isPermissionGrant) {
                                    locationPermissionDialog(context);
                                  } else {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    await _initMapState();
                                  }
                                }
                              : null,
                          radius: 8,
                          child: Text(
                            textAlign: TextAlign.center,
                            '인증하기',
                            style: selectAddress.isNotEmpty
                                ? DaepiroTextStyle.body_1_b
                                    .copyWith(color: DaepiroColorStyle.white)
                                : DaepiroTextStyle.body_1_b
                                    .copyWith(color: DaepiroColorStyle.g_75),
                          ),
                          backgroundColor: selectAddress.isNotEmpty
                              ? DaepiroColorStyle.g_700
                              : DaepiroColorStyle.g_200,
                        ))
                      ],
                    )
                  ],
                );
              }));
        });
  }

  void locationPermissionDialog(BuildContext context) {
    basicDialog(
      context,
      Text(
        '위치 허용이 필요해요',
        style:
            DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_900),
      ),
      Text(
        textAlign: TextAlign.center,
        '현 위치 노출을 위해 위치 권한을 허용해주세요.',
        style:
            DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_500),
      ),
      SecondaryFilledButton(
          verticalPadding: 12,
          onPressed: () {
            GoRouter.of(context).pop();
            GoRouter.of(context).pop();
            GoRouter.of(context).pop();
          },
          radius: 8,
          backgroundColor: DaepiroColorStyle.g_50,
          pressedColor: DaepiroColorStyle.g_75,
          child: Text(
            textAlign: TextAlign.center,
            '그만두기',
            style: DaepiroTextStyle.body_1_b
                .copyWith(color: DaepiroColorStyle.g_700),
          )),
      SecondaryFilledButton(
          verticalPadding: 12,
          onPressed: () async {
            GoRouter.of(context).pop();
            var requestStatus = await Permission.location.request();
            var status = await Permission.location.status;
            if(requestStatus.isPermanentlyDenied || status.isPermanentlyDenied) {
              openAppSettings();
            } else if(status.isRestricted) {
              openAppSettings();
            }
          },
          radius: 8,
          backgroundColor: DaepiroColorStyle.g_700,
          pressedColor: DaepiroColorStyle.g_400,
          child: Text(
            textAlign: TextAlign.center,
            '허용하기',
            style: DaepiroTextStyle.body_1_b
                .copyWith(color: DaepiroColorStyle.white),
          )),
    );
  }

  Widget locationCheckWidget(bool checkSuccess) {
    return Container(
      decoration: BoxDecoration(
          color:
              checkSuccess ? DaepiroColorStyle.gre_50 : DaepiroColorStyle.r_50,
          borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            checkSuccess
                ? SvgPicture.asset('assets/icons/icon_certification.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                        DaepiroColorStyle.gre_500, BlendMode.srcIn))
                : SvgPicture.asset('assets/icons/icon_warning.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                        DaepiroColorStyle.r_400, BlendMode.srcIn)),
            SizedBox(width: 8),
            checkSuccess
                ? Text(
                    '인증이 완료되었습니다.',
                    style: DaepiroTextStyle.body_1_b
                        .copyWith(color: DaepiroColorStyle.gre_500),
                  )
                : Text('선택한 동네과 현 위치가 다릅니다.',
                    style: DaepiroTextStyle.body_1_b
                        .copyWith(color: DaepiroColorStyle.r_400))
          ],
        ),
      ),
    );
  }

  void basicDialog(BuildContext context, Widget titleWidget,
      Widget contentWidget, Widget doneWidget, Widget actionWidget) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: DaepiroColorStyle.white,
            titlePadding: EdgeInsets.fromLTRB(20, 24, 20, 4),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [titleWidget],
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 4, 20, 24),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [contentWidget]),
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(child: doneWidget),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(child: actionWidget)
                ],
              ),
            ],
          );
        });
  }

  Widget successCertificate(String selectAddress) {
    return SizedBox.shrink();
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     return Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         SizedBox(
    //           width: 80,
    //           height: 80,
    //           child: FutureBuilder(
    //             future: controller.initialize(),
    //             builder: (context, snapshot) {
    //               if (snapshot.connectionState == ConnectionState.done) {
    //                 controller.setLooping(true);
    //                 controller.play();
    //                 return VideoPlayer(controller);
    //               } else {
    //                 return Center(child: CircularProgressIndicator());
    //               }
    //             },
    //           ),
    //         ),
    //         SizedBox(height: 12),
    //         Text(
    //           '\'${selectAddress}\' 주민 뱃지를 얻었어요!',
    //           style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_700),
    //         ),
    //         Text(
    //           '동네생활에서 주민들과 함께 안전한 동네를 만들어요.',
    //           style: DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_500),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }




}

class CustomBalloon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    const double triangleW = 14;
    final double width = size.width;
    final double height = size.height;

    final Path trianglePath = Path()
      ..moveTo(width, height / 2 - triangleW / 2) // 삼각형 왼쪽 시작점
      ..lineTo(width + triangleW, height / 2) // 삼각형 아래쪽
      ..lineTo(width, height / 2 + triangleW / 2) // 삼각형 오른쪽 끝
      ..close();

    canvas.drawPath(trianglePath, paint);

    final BorderRadius borderRadius = BorderRadius.circular(4);
    final Rect rect = Rect.fromLTWH(0, 0, width, height);
    final RRect outer = borderRadius.toRRect(rect);
    canvas.drawRRect(outer, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
