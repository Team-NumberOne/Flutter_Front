import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../../../cmm/DaepiroTheme.dart';
import '../../../../data/model/selected_image.dart';
import '../../controller/community_town_view_model.dart';
import 'gallery_view_screen.dart';

//갤러리에서 선택한 이미지나 본래 첨부된 이미지가 보여지는 위젯
//community_writing_screen에 쓰여질 위젯
class HorizonPhotoWidget extends ConsumerWidget {
  ScrollController scrollController;

  late List<SelectedImage> totalImages;

  HorizonPhotoWidget({
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(selectedImagesProvider); // 선택된 이미지
    final attachedImages = ref.watch(communityTownProvider).attachedImages; // 기존 첨부된 이미지

    // 기존 첨부된 이미지 + 갤러리에서 선택한 이미지 리스트
    final List<SelectedImage> totalImages = [...attachedImages, ...selectedImages];

    return totalImages.isNotEmpty ?
    SizedBox(
      height: 120,
      child: ListView(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: totalImages.map((e) =>
            Padding(
              padding: const EdgeInsets.fromLTRB(0,8,8,0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _horizonPhotoItem(e),
                  _deleteButton(e, ref, attachedImages, context)
                ],
              ),
            )).toList(),
      ),
    ) : const SizedBox();
  }

  //가져온 사진이 보여지는 item 위젯
  Widget _horizonPhotoItem(SelectedImage image) {
    if(image.entity != null) {
      //갤러리에서 가져온 이미지
      return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: image.entity != null
              ? Container(
                width: 118,
                height: 118,
                child: AssetEntityImage(
                image.entity!,
                fit: BoxFit.cover),
              )
              : Container(
              width: 118,
              height: 118,
              child: Image.file(
                  File(image.file!.path),
                  fit: BoxFit.cover)
          )
      );
    } else {
      //카메라로 직접 찍은 동영상 혹은 이미지
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 118,
          height: 118,
          child: Image.file(
            File(image.file!.path),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  Widget _deleteButton(SelectedImage image, WidgetRef ref, List<SelectedImage> attachedImages, BuildContext context) {
    final isAttachedImage = attachedImages.contains(image);

    return Positioned(
        top: -4,
        right: -4,
        child: GestureDetector(
          onTap: () {
            if(isAttachedImage) {
              ref.read(communityTownProvider.notifier).removeAttahedImages(image);
            } else {
              ref.read(selectedImagesProvider.notifier).selectImage(image, attachedImages.length, context);
            }
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DaepiroColorStyle.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                      offset: const Offset(0, 0)
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
                child: SvgPicture.asset(
                    width: 12,
                    height: 12,
                    'assets/icons/icon_close.svg',
                    colorFilter: ColorFilter.mode(
                        DaepiroColorStyle.g_900, BlendMode.srcIn)),
              )
          ),
        )
    );
  }

}

///선택한 파일이 동영상일 경우 재생을 위함
// class VideoThumbnailItem extends StatefulWidget {
//   final File videoFile;
//
//   VideoThumbnailItem({required this.videoFile});
//
//   @override
//   _VideoThumbnailItemState createState() => _VideoThumbnailItemState();
// }
//
// class _VideoThumbnailItemState extends State<VideoThumbnailItem> {
//   late VideoPlayerController _controller;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(widget.videoFile)..initialize().then((_) {
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _togglePlayPause() {
//     setState(() {
//       if(_controller.value.isPlaying) {
//         _controller.pause();
//         _isPlaying = false;
//       } else {
//         _controller.play();
//         _isPlaying = true;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _togglePlayPause,
//       child: SizedBox(
//         width: 118,
//         height: 118,
//         child: Stack(
//           children: [
//             _controller.value.isInitialized ?
//             VideoPlayer(_controller) : Center(child: CircularProgressIndicator()),
//             Positioned.fill(
//                 child: _isPlaying ? Container() : Icon(Icons.play_circle_fill, color: Colors.white,size: 40,)
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
// }