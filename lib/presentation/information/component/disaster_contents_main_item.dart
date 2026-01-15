import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

class DisasterContentsMainItem extends StatelessWidget {
  final String type;
  final String source;
  final String title;
  final String date;
  final String thumbnailUrl;
  final String bodyUrl;

  const DisasterContentsMainItem({
    super.key,
    required this.type,
    required this.title,
    required this.source,
    required this.date,
    required this.thumbnailUrl,
    required this.bodyUrl
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      height: 352,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 2,
          color: DaepiroColorStyle.g_50,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
                color: DaepiroColorStyle.o_50,
                borderRadius: BorderRadius.circular(4)
            ),
            child: Text(
                type,
                style: DaepiroTextStyle.caption.copyWith(
                  color: DaepiroColorStyle.o_500,
                )
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: DaepiroTextStyle.h6.copyWith(
              color: DaepiroColorStyle.g_800,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            "${formatDateToDot(date)} · $source",
            style: DaepiroTextStyle.caption.copyWith(
              color: DaepiroColorStyle.g_400,
            ),
          ),
          const Spacer(),
          if (thumbnailUrl.isNotEmpty)
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  thumbnailUrl,
                  width: double.infinity,
                  height: 187,
                  fit: BoxFit.cover))
          else
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                    'assets/icons/empty_image_large.png',
                    width: double.infinity,
                    height: 187,
                    fit: BoxFit.cover))
        ],
      ),
    );
  }
}
