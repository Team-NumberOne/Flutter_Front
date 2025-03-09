import 'dart:ui';

import 'package:daepiro/presentation/community/controller/community_town_view_model.dart';
import 'package:daepiro/presentation/community/screens/town/gallery_view_screen.dart';
import 'package:daepiro/presentation/community/screens/town/horizon_photo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../cmm/DaepiroTheme.dart';
import '../../../../cmm/button/secondary_filled_button.dart';
import '../../../../data/model/response/community/community_dongnae_content_detail_response.dart';

class CommunityTownWritingScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final ContentDetail? contentDetail;

  const CommunityTownWritingScreen(
      {super.key, required this.isEdit, this.contentDetail});

  @override
  CommunityTownWritingState createState() => CommunityTownWritingState();
}

//동네생활 글쓰기 화면
class CommunityTownWritingState
    extends ConsumerState<CommunityTownWritingScreen>
    with WidgetsBindingObserver {
  bool isCompleteEnabled = false;
  bool isWritingContainerPress = false;

  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController contentTextController = TextEditingController();

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    titleTextController.addListener(_updateCompleteButtonState);
    contentTextController.addListener(_updateCompleteButtonState);
    if (widget.isEdit) {
      titleTextController.text = widget.contentDetail?.title ?? '';
      contentTextController.text = widget.contentDetail?.body ?? '';
      //selectedImage 기본값을 세팅해야함
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(communityTownProvider.notifier).convertFileToAssetEntity();
        ref.read(communityTownProvider.notifier).setCategoryState(
            ContentCategory.getByValue(widget.contentDetail!.category));
      });
    }
  }

  void _updateCompleteButtonState() {
    // 제목과 내용이 비어있지 않은지 확인
    final isTitleNotEmpty = titleTextController.text.isNotEmpty;
    final isContentNotEmpty = contentTextController.text.isNotEmpty;
    String category = ref.watch(communityTownProvider).writingTownCategory;

    // 버튼 상태 변경
    if (isCompleteEnabled != (isTitleNotEmpty && isContentNotEmpty && category != '')) {
      setState(() {
        isCompleteEnabled = isTitleNotEmpty && isContentNotEmpty && category != '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    titleTextController.dispose();
    contentTextController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final viewModel = ref.read(communityTownProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        bool isGrant = await viewModel.getLocationPermission();
        if (!isGrant) {
          viewModel.initLocationState();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityTownProvider);
    _updateCompleteButtonState();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerWidget(context),
                SizedBox(height: 12),
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          writingTypeWidget(state.writingTownCategory),
                          SizedBox(
                            height: 20,
                          ),
                          titleTextField(titleTextController),
                          SizedBox(
                            height: 16,
                          ),
                          contentTextField(contentTextController),
                          SizedBox(
                            height: 20,
                          ),
                          photoWidget(),
                          SizedBox(height: 20),
                          Visibility(
                              visible: !widget.isEdit,
                              child: locationCheckWidget(state.isVisible)),
                        ],
                      ),
                    )),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        if (didPop && !widget.isEdit) {
          await ref.read(communityTownProvider.notifier).loadContent();
          ref.read(communityTownProvider.notifier).clearWritingState();
          ref.read(selectedImagesProvider.notifier).clearImages();
        } else if (didPop && widget.isEdit) {
          await ref
              .read(communityTownProvider.notifier)
              .getContentDetail(widget.contentDetail!.id);
          ref.read(communityTownProvider.notifier).clearWritingState();
          ref.read(selectedImagesProvider.notifier).clearImages();
        }
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pop();
                },
                child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                        DaepiroColorStyle.g_900, BlendMode.srcIn)),
              ),
              Expanded(
                child: Text(
                  '글쓰기',
                  textAlign: TextAlign.center,
                  style: DaepiroTextStyle.h6
                      .copyWith(color: DaepiroColorStyle.g_800),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    //게시글 작성 및 편집후 모든 상태 초기화
                    if (isCompleteEnabled && !widget.isEdit) {
                      final isSuccess = await ref
                          .read(communityTownProvider.notifier)
                          .setArticle(titleTextController.text,
                              contentTextController.text);
                      showSnackbar(context, '잠시만 기다려주세요.');
                      Future.delayed(const Duration(milliseconds: 500), () {
                        GoRouter.of(context).pop();
                        showSnackbar(context, isSuccess ? '게시글 작성이 완료되었습니다.' : '잠시 후 다시 시도해주세요.');
                      });
                    }
                    if (widget.isEdit) {
                      //게시글 수정 api 호출
                      final isSuccess = await ref
                          .read(communityTownProvider.notifier)
                          .editArticle(titleTextController.text,
                              contentTextController.text);
                      showSnackbar(context, '잠시만 기다려주세요.');
                      Future.delayed(const Duration(milliseconds: 400), () {
                        GoRouter.of(context).pop();
                        showSnackbar(context, isSuccess ? '게시글 작성이 완료되었습니다.' : '잠시 후 다시 시도해주세요.');
                      });
                    }
                  },
                  child: Text(
                    '완료',
                    style: DaepiroTextStyle.body_1_m.copyWith(
                        color: isCompleteEnabled
                            ? DaepiroColorStyle.o_500
                            : DaepiroColorStyle.g_100),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget writingTypeWidget(String writingTownCategory) {
    //일상, 교통 등등이 매개변수
    return InkWell(
      onTap: () {
        showCategoryBottomSheet(context, isWritingContainerPress);
        setState(() {
          isWritingContainerPress = true;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: DaepiroColorStyle.g_50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                width: 1.5,
                color: isWritingContainerPress
                    ? DaepiroColorStyle.g_75
                    : DaepiroColorStyle.g_50)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              writingTownCategory == ''
                  ? Text(
                      '게시글 주제를 선택해주세요.',
                      style: DaepiroTextStyle.body_1_m
                          .copyWith(color: DaepiroColorStyle.g_300),
                    )
                  : Text(
                      writingTownCategory,
                      style: DaepiroTextStyle.body_1_m
                          .copyWith(color: DaepiroColorStyle.g_900),
                    ),
              Spacer(),
              SvgPicture.asset('assets/icons/icon_arrow_down.svg',
                  colorFilter: ColorFilter.mode(
                      DaepiroColorStyle.g_900, BlendMode.srcIn)),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleTextField(TextEditingController controller) {
    return Container(
      width: double.infinity,
      child: TextField(
        controller: controller,
        maxLength: 38,
        cursorColor: DaepiroColorStyle.g_900,
        style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_900),
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          hintText: '제목을 입력하세요.',
          hintStyle:
              DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_75),
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: DaepiroColorStyle.g_75)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: DaepiroColorStyle.g_75)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: DaepiroColorStyle.g_75)),
        ),
      ),
    );
  }

  Widget contentTextField(TextEditingController controller) {
    return Container(
      width: double.infinity,
      height: 343,
      child: TextField(
        controller: controller,
        maxLength: 2000,
        cursorColor: DaepiroColorStyle.g_900,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        style:
            DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_900),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          hintText: '동네생활과 관련된 이야기를 주민들과 나누세요.',
          hintStyle: DaepiroTextStyle.body_2_m
              .copyWith(color: DaepiroColorStyle.g_200),
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget photoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '사진',
          style: DaepiroTextStyle.body_1_m.copyWith(
            color: DaepiroColorStyle.g_900,
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                var status = await Permission.photos.request();
                if (status.isGranted || status == PermissionStatus.limited) {
                  GoRouter.of(context).push('/community_town_writing_album');
                } else {
                  await openAppSettings();
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                child: Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: DaepiroColorStyle.g_75,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/icon_photo.svg',
                      width: 34,
                      height: 34,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            if (widget.isEdit)
              Expanded(
                child: HorizonPhotoWidget(
                    //편집상태이다
                    scrollController: _scrollController),
              ),
            if (!widget.isEdit)
              Expanded(
                  child: HorizonPhotoWidget(
                      //글쓰기 상태이다
                      scrollController: _scrollController)),
          ],
        ),
      ],
    );
  }

  Widget locationCheckWidget(bool isVisible) {
    Future<void> handleLocationCheck(bool? value) async {
      final locationState = await ref
          .read(communityTownProvider.notifier)
          .getLocationPermission();
      if (!locationState) {
        locationDialog(context);
      } else {
        final locationCorrect = await ref
            .read(communityTownProvider.notifier)
            .checkShowCurrentLocation();
        if (locationCorrect) {
          await ref.read(communityTownProvider.notifier).setVisibleState();
        } else {
          showErrorText(context, '작성하고자 하는 위치와 현위치가 일치하지 않습니다.');
        }
      }
    }

    return ElevatedButton(
      onPressed: () => handleLocationCheck(isVisible),
      style: ElevatedButton.styleFrom(
          backgroundColor: DaepiroColorStyle.g_50,
          padding: EdgeInsets.symmetric(vertical: 12),
          overlayColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          shadowColor: Colors.transparent,
          elevation: 0.0),
      child: Row(
        children: [
          SizedBox(
            width: 12,
          ),
          Checkbox(
              visualDensity: VisualDensity.compact,
              side: BorderSide(color: Colors.transparent),
              activeColor: DaepiroColorStyle.g_500,
              checkColor: DaepiroColorStyle.white,
              fillColor: MaterialStateProperty.resolveWith((state) {
                if (!state.contains(MaterialState.selected)) {
                  return DaepiroColorStyle.g_100;
                }
                return null;
              }),
              value: isVisible,
              onChanged: (value) => handleLocationCheck(isVisible)),
          SizedBox(width: 8),
          Text(
            '현 위치를 표시하겠어요?',
            style: DaepiroTextStyle.body_1_m
                .copyWith(color: DaepiroColorStyle.g_800),
          )
        ],
      ),
    );
  }

  //위치 권한 안내 다이얼로그
  void locationDialog(BuildContext context) {
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
                  '위치 권한이 없습니다.',
                  style: DaepiroTextStyle.body_1_b
                      .copyWith(color: DaepiroColorStyle.g_900),
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 24),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '현 위치 노출을 위해 위치 권한을 허용해주세요.',
                      style: DaepiroTextStyle.body_2_m
                          .copyWith(color: DaepiroColorStyle.g_500),
                    ),
                  ]),
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: SecondaryFilledButton(
                        verticalPadding: 12,
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        radius: 8,
                        backgroundColor: DaepiroColorStyle.g_50,
                        pressedColor: DaepiroColorStyle.g_75,
                        child: Text(
                          textAlign: TextAlign.center,
                          '미허용',
                          style: DaepiroTextStyle.body_1_b
                              .copyWith(color: DaepiroColorStyle.g_700),
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: SecondaryFilledButton(
                        verticalPadding: 12,
                        onPressed: () async {
                          GoRouter.of(context).pop();
                          await openAppSettings();
                        },
                        radius: 8,
                        backgroundColor: DaepiroColorStyle.g_700,
                        pressedColor: DaepiroColorStyle.g_400,
                        child: Text(
                          textAlign: TextAlign.center,
                          '위치 허용',
                          style: DaepiroTextStyle.body_1_b
                              .copyWith(color: DaepiroColorStyle.white),
                        )),
                  )
                ],
              ),
            ],
          );
        });
  }

  //카테고리 선택 바텀시트
  void showCategoryBottomSheet(
      BuildContext context, bool isWritingContainerPress) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (context) {
          return Wrap(
            children: [
              Container(child: categoryItemWidget(isWritingContainerPress)),
            ],
          );
        },
        isScrollControlled: true);
  }

  //바텀시트 내부 위젯
  Widget categoryItemWidget(bool isWritingContainerPress) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bottomSheetheaderWidget(),
          GestureDetector(
              onTap: () {
                setState(() {
                  isWritingContainerPress = false;
                });
              },
              child: categoryListItem('일상')),
          GestureDetector(
              onTap: () {
                setState(() {
                  isWritingContainerPress = false;
                });
              },
              child: categoryListItem('교통')),
          GestureDetector(
              onTap: () {
                setState(() {
                  isWritingContainerPress = false;
                });
              },
              child: categoryListItem('치안')),
          GestureDetector(
              onTap: () {
                setState(() {
                  isWritingContainerPress = false;
                });
              },
              child: categoryListItem('기타')),
        ],
      ),
    );
  }

  //바텀시트 내부 헤더
  Widget bottomSheetheaderWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 16),
                Opacity(
                  opacity: 0.0,
                  child: SvgPicture.asset(
                    'assets/icons/icon_close.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
                Expanded(
                  child: Text(
                    '게시글 주제',
                    textAlign: TextAlign.center,
                    style: DaepiroTextStyle.body_1_b
                        .copyWith(color: DaepiroColorStyle.g_900),
                  ),
                ),
                GestureDetector(
                  onTap: () => GoRouter.of(context).pop(),
                  child: SvgPicture.asset('assets/icons/icon_close.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                          DaepiroColorStyle.g_900, BlendMode.srcIn)),
                ),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: DaepiroColorStyle.g_50),
              width: double.infinity,
              height: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget categoryListItem(String category) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: DaepiroColorStyle.white,
          overlayColor: DaepiroColorStyle.g_50,
          minimumSize: Size.zero,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          ref.read(communityTownProvider.notifier).setCategoryState(category);
          setState(() {
            isWritingContainerPress = !isWritingContainerPress;
          });
          GoRouter.of(context).pop();
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Text(
                  category,
                  textAlign: TextAlign.start,
                  style: DaepiroTextStyle.body_1_m
                      .copyWith(color: DaepiroColorStyle.g_900),
                ),
              ],
            )),
      ),
    );
  }

  void showSnackbar(BuildContext context, String text) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 20.0,
        right: 20.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: DaepiroTextStyle.body_2_m,
                        child: Text(
                          textAlign: TextAlign.center,
                          text,
                          style: DaepiroTextStyle.body_2_m
                              .copyWith(color: DaepiroColorStyle.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  void showErrorText(BuildContext context, String content) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 20.0,
        right: 20.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        content,
                        style: DaepiroTextStyle.body_2_m
                            .copyWith(color: DaepiroColorStyle.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
