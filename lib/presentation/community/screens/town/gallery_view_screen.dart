import 'dart:ui';

import 'package:daepiro/presentation/community/controller/community_town_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../../../cmm/DaepiroTheme.dart';
import '../../../../data/model/Album.dart';
import '../../../../data/model/selected_image.dart';

final selectedImagesProvider = StateNotifierProvider<SelectedImagesNotifier, List<SelectedImage>>((ref) {
  return SelectedImagesNotifier();
});

class SelectedImagesNotifier extends StateNotifier<List<SelectedImage>> {
  SelectedImagesNotifier() : super([]);

  int totalSize = 0;

  //선택 제거 상태를 제어하기 위함
  Future<void> selectImage(SelectedImage image, int attachImages, BuildContext context) async {
    final addedImageCheck = state.any((e) => _addedImageCheck(image, e));
    final totalLength = state.length + attachImages;

    if (addedImageCheck) {
      final file = await image.entity?.originFile;
      if (file != null) {
        totalSize -= await file.length();
      }
      state = state.where((e) => !_addedImageCheck(image, e)).toList();
    } else {
      //개수 제한
      if(totalLength >= 3) return;

      //크기 제한
      final file = await image.entity?.originFile;
      if(file != null) {
        final fileSize = await file.length();
        if(totalSize + fileSize > 10 * 1024 * 1024) {
          failSnackbar(context);
          print('여기서 사이즈 체크 ${totalSize} && ${totalLength}');
          return;
        }
        totalSize += await file.length();
      }
      state = [...state, image];
    }
  }

  void clearImages() {
    state = [];
    totalSize = 0;
  }

  bool _addedImageCheck(SelectedImage image, SelectedImage compareImage) {
    return image.entity == compareImage.entity && image.file == compareImage.file;
  }

  void failSnackbar(BuildContext context) {
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
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0.6), // 백그라운드 색상은 여기에
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Text(
                          '파일 용량이 10MB를 초과할 수 없습니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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

class GalleryViewScreen extends ConsumerStatefulWidget {
  GalleryViewScreen({Key? key});

  @override
  _PhotoSelectScreenState createState() => _PhotoSelectScreenState();
}

class _PhotoSelectScreenState extends ConsumerState<GalleryViewScreen> {
  List<AssetPathEntity>? _paths; //모든 파일 정보
  List<Album> _albums = []; //드롭다운 앨범 목록(우리 앱에선 살짝 의미 없음)
  late List<AssetEntity> _images = []; //앨범 이미지 목록
  int _currentPage = 0;
  late Album _currentAlbum;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getAlbum();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> getAlbum() async {
    _paths = await PhotoManager.getAssetPathList(
        onlyAll: true, //전체보기만 불러온다
        type: RequestType.image //불러올 파일 형식 이미지
    );

    _albums = _paths!.map((e) {
      return Album(
        id: e.id,
        name: e.isAll ? '모든 사진' : e.name,
      );
    }).toList();
    await getPhotos(_albums[0], albumChange: true);
  }



  //앨범의 이미지 목록
  // 이 페이지에 처음 진입했을때 & 스크롤이 끝에 다다랐을때 호출된다
  Future<void> getPhotos(Album album, {bool albumChange = false}) async {
    _currentAlbum = album;
    albumChange ? _currentPage = 0 : _currentPage++;

    final loadImages = await _paths!
        .singleWhere((AssetPathEntity e) => e.id == album.id)
        .getAssetListPaged(
      page: _currentPage,
      size: 20,
    );

    setState(() {
      if (albumChange) {
        _images = _isAllCheck(loadImages, reset: true);
      } else {
        _images.addAll(_isAllCheck(loadImages, reset: false));
      }
    });
  }

// 카메라 버튼을 포함하는 함수
  List<AssetEntity> _isAllCheck(List<AssetEntity> loadImages, {required bool reset}) {
    const dummy = AssetEntity(id: 'camera', typeInt: 0, width: 0, height: 0);

    if (reset) {
      return [dummy, ...loadImages];
    } else {
      return loadImages;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedImages = ref.watch(selectedImagesProvider);
    final attachedImages = ref.watch(communityTownProvider).attachedImages;
    int totalLength = selectedImages.length + attachedImages.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            headerWidget(totalLength),
            Expanded(
                child:
                NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scroll) {
                      final scrollPixels = scroll.metrics.pixels / scroll.metrics.maxScrollExtent;
                      if(scrollPixels > 0.7)
                        getPhotos(_currentAlbum);
                      return false;
                    },
                    child: _paths == null
                        ? Center(child: CircularProgressIndicator())
                        :gridPhoto(
                        images: _images,
                        selectedImages: selectedImages,
                        onTap: (image) => ref.read(selectedImagesProvider.notifier).selectImage(image, attachedImages.length, context))
                )
            )
          ],
        ),
      ),
    );
  }

  Widget headerWidget(int totalLength) {
   return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
            Spacer(),
            Text('${totalLength}/3', style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800)),
            Spacer(),
            GestureDetector(
                onTap: () {
                  ref.read(communityTownProvider.notifier).setFinalFiles(ref.read(selectedImagesProvider));
                  GoRouter.of(context).pop();
                },
                child: Text('추가', style: DaepiroTextStyle.body_1_m.copyWith(color: DaepiroColorStyle.o_500),))
          ],
        ),
      ),
    );
  }
}


//갤러리 이미지 선택과 해제를 위한 item
//_gridPhotoItem에서 selectedImages에 해당하면 dim처리와 카운팅
//이미지 선택 해제 카메라로 이미지 가져오면 ontap 실행
class gridPhoto extends ConsumerWidget {
  List<AssetEntity> images;
  List<SelectedImage> selectedImages;
  ValueChanged<SelectedImage> onTap;

  gridPhoto({
    required this.images,
    required this.selectedImages,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final picker = ImagePicker();

  void _loadCamera(BuildContext context) async {
    final file = await picker.pickImage(source: ImageSource.camera);
    if(file != null) {
      final item = SelectedImage(entity: null, file: file); //카메라로 가져온 이미지는 entiy가 널이다
      onTap(item);
      GoRouter.of(context).pop();
    }
  }

  void _selectImage(AssetEntity e) {
    final item = SelectedImage(entity: e, file: null);
    onTap(item);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(selectedImagesProvider);

    return GridView(
      physics: const BouncingScrollPhysics(),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: images.map((e) {
        if(e.id == 'camera') {
          return _cameraButton(context);
        } else {
          return _gridPhotoItem(e, selectedImages, ref);
        }
      }).toList(),
    );
  }

  Widget _cameraButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var status = await Permission.camera.status;
        if(status.isGranted) {
          _loadCamera(context);
        } else {
          await openAppSettings();
        }
      },
      child: Container(
        child: Icon(
          CupertinoIcons.camera,
          size: 50,
        ),
      ),
    );
  }

  Widget _gridPhotoItem(AssetEntity e, List<SelectedImage> selectedImages, WidgetRef ref) {
    final isSelected = selectedImages.any((element) => element.entity == e);

    return GestureDetector(
      onTap: () => _selectImage(e),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: AssetEntityImage(
                e,
                isOriginal: false, //썸네일 로드
                fit: BoxFit.cover,
              ),
            ),
            _dimContainer(isSelected),
            _selectNumberContainer(e, isSelected),
            //동영상일 경우 상징 표시만 해주기
            if(e.type == AssetType.video)
              Positioned(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 20,
                ),
              )
          ],
        ),
      ),
    );
  }

  //선택함을 표시
  Widget _dimContainer(bool isSelected) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.black38 : Colors.transparent
        ),
      ),
    );
  }

  //체크 박스
  Widget _selectNumberContainer(AssetEntity e, bool isSelected) {
    final isSelected = selectedImages.any((element) => element.entity == e);

    return Positioned(
        right: 0,
        top: 0,
        child: Checkbox(
          visualDensity: VisualDensity.compact,
          side: BorderSide(color: Colors.transparent),
          activeColor: DaepiroColorStyle.o_500,
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith((states) {
            if(states.contains(MaterialState.selected)) {
              return DaepiroColorStyle.o_500;
            }
            return DaepiroColorStyle.g_75;
          }),
          value: isSelected,
          onChanged: (value) {
            onTap(SelectedImage(entity: e, file: null));
          },
        )
    );
  }
}