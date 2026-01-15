import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../cmm/theme/DaepiroTheme.dart';

class NotificationItem extends StatefulWidget {
  final String type;
  final String title;
  final String contents;
  final String date;

  const NotificationItem({
    super.key,
    required this.type,
    required this.title,
    required this.contents,
    required this.date,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.type == "재난문자")
                SvgPicture.asset('assets/icons/icon_notification_alram.svg')
              else if (widget.type == "커뮤니티")
                SvgPicture.asset('assets/icons/icon_notification_community.svg')
              else if (widget.type == "후원")
                  SvgPicture.asset('assets/icons/icon_notification_funding.svg')
              else
                SvgPicture.asset('assets/icons/icon_notification_notice.svg'),
              const SizedBox(width: 6),
              Text(
                widget.type,
                style: DaepiroTextStyle.body_2_m.copyWith(
                  color: DaepiroColorStyle.g_900,
                )
              ),
              const Spacer(),
              Text(
                  timeAgo(widget.date),
                  style: DaepiroTextStyle.caption.copyWith(
                    color: DaepiroColorStyle.g_200,
                  )
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
              widget.title,
              style: DaepiroTextStyle.body_1_m.copyWith(
                color: DaepiroColorStyle.g_900,
              )
          ),
          Text(
              widget.contents,
              style: DaepiroTextStyle.body_2_m.copyWith(
                color: DaepiroColorStyle.g_400,
              )
          ),
        ],
      ),
    );
  }
}
