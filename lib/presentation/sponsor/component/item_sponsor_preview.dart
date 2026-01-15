import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

class ItemSponsorPreview extends StatelessWidget {
  final String disasterType;
  final String date;
  final String from;
  final String title;
  final String imagePath;

  const ItemSponsorPreview({
    super.key,
    required this.disasterType,
    required this.date,
    required this.from,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: DaepiroColorStyle.o_50
                ),
                padding: const EdgeInsets.fromLTRB(6,7,10,7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      findDisasterIconByName(name: disasterType),
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(DaepiroColorStyle.o_500, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      disasterType,
                      style: DaepiroTextStyle.caption.copyWith(
                        color: DaepiroColorStyle.o_500,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: DaepiroColorStyle.g_50
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  date,
                  style: DaepiroTextStyle.body_2_m.copyWith(
                    color: DaepiroColorStyle.g_600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      from,
                      style: DaepiroTextStyle.body_2_m.copyWith(
                        color: DaepiroColorStyle.g_400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: DaepiroTextStyle.body_1_b.copyWith(
                        color: DaepiroColorStyle.g_900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  imagePath,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
