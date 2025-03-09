import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../cmm/DaepiroTheme.dart';

class CommunityPhotoScreen extends ConsumerWidget {
  final List<String>? fileList;
  const CommunityPhotoScreen({super.key, this.fileList});

  //filelist 전달받기
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: headerWidget(context),
            ),
            Expanded(
              child: PageView.builder(
                itemCount: fileList!.length,
                  itemBuilder: (context, index) {
                    String file = fileList![index];
                    return PhotoView(
                        imageProvider: NetworkImage(file),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  }
              ),
            )
          ],
        )
      ),
    );
  }

  //헤더 위젯
  Widget headerWidget(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: GestureDetector(
            onTap: () async {
              GoRouter.of(context).pop();
            },
            child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                width: 24,
                height: 24,
                colorFilter:
                ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)),
          ),
        ),
        SizedBox(
          width: 24,
        )
      ],
    );
  }

}