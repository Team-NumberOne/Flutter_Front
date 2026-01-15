import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../const/utils.dart';
import '../../home/component/map_direction_item.dart';

class ItemAroundShelter extends StatelessWidget {
  final String name;
  final int distinct;
  final String address;
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  const ItemAroundShelter({
    super.key,
    required this.name,
    required this.distinct,
    required this.address,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: DaepiroTextStyle.body_1_b.copyWith(
                          color: DaepiroColorStyle.g_900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      calculateDistance(startLatitude, startLongitude, endLatitude, endLongitude),
                      style: DaepiroTextStyle.body_2_m.copyWith(
                        color: DaepiroColorStyle.o_500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: address));
                      },
                      child: SvgPicture.asset(
                          'assets/icons/icon_copy.svg',
                          colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_100, BlendMode.srcIn),
                          width: 30,
                          height: 30
                      ),
                    )
                  ]
              ),
              Text(
                address,
                style: DaepiroTextStyle.body_2_m.copyWith(
                  color: DaepiroColorStyle.g_500,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  color: DaepiroColorStyle.g_50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 0,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            backgroundColor: DaepiroColorStyle.white,
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "대피소 길찾기 바로가기",
                                            style: DaepiroTextStyle.body_1_b.copyWith(
                                              color: DaepiroColorStyle.g_900,
                                            ),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                context.pop();
                                              },
                                              child: SvgPicture.asset(
                                                  'assets/icons/icon_close.svg',
                                                  width: 24,
                                                  height: 24,
                                                  colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)),
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(height: 1, width: double.infinity, color: DaepiroColorStyle.g_50),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      children: [
                                        MapDirectionItem(
                                          type: "naver",
                                          startLatitude: startLatitude,
                                          startLongitude: startLongitude,
                                          endLatitude: endLatitude,
                                          endLongitude: endLongitude,
                                        ),
                                        const SizedBox(height: 8),
                                        MapDirectionItem(
                                          type: "kakao",
                                          startLatitude: startLatitude,
                                          startLongitude: startLongitude,
                                          endLatitude: endLatitude,
                                          endLongitude: endLongitude,
                                        ),
                                        const SizedBox(height: 8),
                                        MapDirectionItem(
                                          type: "tmap",
                                          startLatitude: startLatitude,
                                          startLongitude: startLongitude,
                                          endLatitude: endLatitude,
                                          endLongitude: endLongitude,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        '길찾기',
                        style: DaepiroTextStyle.body_2_m.copyWith(
                          color: DaepiroColorStyle.g_600,
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: DaepiroColorStyle.g_50,
          height: 1,
        )
      ],
    );
  }
}
