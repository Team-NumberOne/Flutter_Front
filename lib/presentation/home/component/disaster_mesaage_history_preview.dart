
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../cmm/theme/DaepiroTheme.dart';
import '../../const/utils.dart';

class DisasterHistoryPreview extends StatefulWidget {
  final String disasterType;
  final String title;
  final String date;

  const DisasterHistoryPreview({
    super.key,
    required this.disasterType,
    required this.title,
    required this.date
  });

  @override
  _DisasterHistoryPreview createState() => _DisasterHistoryPreview();
}

class _DisasterHistoryPreview extends State<DisasterHistoryPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: DaepiroColorStyle.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: DaepiroColorStyle.o_50,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              findDisasterIconByName(name: widget.disasterType),
              width: 26,
              height: 26,
              colorFilter: const ColorFilter.mode(DaepiroColorStyle.o_500, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getHighlightText(title: widget.title, disaster: widget.disasterType),
              const SizedBox(height: 2),
              Text(
                widget.date,
                style: DaepiroTextStyle.caption.copyWith(
                  color: DaepiroColorStyle.g_200,
                ),
              )
            ]
          )
        ]
      ),
    );
  }
}