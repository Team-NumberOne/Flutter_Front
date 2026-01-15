import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../const/utils.dart';
import 'map_direction_item.dart';

class NotLocationPermissionWidget extends StatelessWidget {
  const NotLocationPermissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 44),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: DaepiroColorStyle.g_50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "주변 대피소를 확인하려면 위치 권한이 필요해요",
            style: DaepiroTextStyle.body_2_b.copyWith(
              color: DaepiroColorStyle.g_300,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              openAppSettings();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: DaepiroColorStyle.white,
              ),
              child:  Text(
                "권한 허용하기",
                style: DaepiroTextStyle.body_2_m.copyWith(
                  color: DaepiroColorStyle.g_600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}
