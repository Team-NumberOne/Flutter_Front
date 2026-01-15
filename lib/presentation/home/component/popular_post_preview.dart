import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../cmm/theme/DaepiroTheme.dart';
import '../../const/utils.dart';

class PopularPostPreview extends StatefulWidget {
  final String title;
  final String contents;
  final String location;
  final String time;
  final String like;
  final String comment;

  const PopularPostPreview({
    super.key,
    required this.title,
    required this.contents,
    required this.location,
    required this.time,
    required this.like,
    required this.comment,
  });

  @override
  State<PopularPostPreview> createState() => _PopularPostPreviewState();
}

class _PopularPostPreviewState extends State<PopularPostPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: DaepiroColorStyle.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: DaepiroTextStyle.body_1_b.copyWith(
              color: DaepiroColorStyle.g_900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.contents,
            style: DaepiroTextStyle.body_2_m.copyWith(
              color: DaepiroColorStyle.g_500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/icon_location.svg', color: DaepiroColorStyle.g_300),
              const SizedBox(width: 2),
              Text(
                widget.location,
                style: DaepiroTextStyle.caption.copyWith(
                  color: DaepiroColorStyle.g_300,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "·",
                style: DaepiroTextStyle.caption.copyWith(
                  color: DaepiroColorStyle.g_300,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                timeAgo(widget.time),
                style: DaepiroTextStyle.caption.copyWith(
                  color: DaepiroColorStyle.g_300,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/icon_good.svg',
                      colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_200, BlendMode.srcIn),
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      widget.like,
                      style: DaepiroTextStyle.caption.copyWith(
                        color: DaepiroColorStyle.g_300,
                      ),
                    )
                  ]
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/icon_community.svg',
                      colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_200, BlendMode.srcIn),
                      width: 16,
                      height: 16
                    ),
                    const SizedBox(width: 2),
                    Text(
                      widget.comment,
                      style: DaepiroTextStyle.caption.copyWith(
                        color: DaepiroColorStyle.g_300,
                      ),
                    )
                  ]
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
