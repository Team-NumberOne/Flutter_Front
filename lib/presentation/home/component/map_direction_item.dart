import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

const String STORE_URL = "market://details?id=";

class MapDirectionItem extends StatelessWidget {
  final String type;
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  const MapDirectionItem({
    super.key,
    required this.type,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Image icon;
    VoidCallback onClick;
    onClick = () async {
      String url = "";
      String storeUrl = "";

      if (type == "naver") {
        List<Placemark> startLocationAddress = await placemarkFromCoordinates(startLatitude, startLongitude);
        List<Placemark> endLocationAddress = await placemarkFromCoordinates(endLatitude, endLongitude);

        String startAddress = startLocationAddress.first.street ?? "";
        String endAddress = endLocationAddress.first.street ?? "";

        String encodedStartAddress = Uri.encodeFull(startAddress.replaceAll("대한민국 ", ""));
        String encodedEndAddress = Uri.encodeFull(endAddress.replaceAll("대한민국 ", ""));

        url = "nmap://route/walk?slat=$startLatitude&slng=$startLongitude&sname=$encodedStartAddress&dlat=$endLatitude&dlng=$endLongitude&dname=$encodedEndAddress";
        storeUrl = Platform.isAndroid ? "com.nhn.android.nmap" : "https://apps.apple.com/kr/app/naver-map/id311867728";
      } else if (type == "kakao") {
        url = "kakaomap://route?sp=$startLatitude,$startLongitude&ep=$endLatitude,$endLongitude&by=FOOT";
        if (Platform.isAndroid) {
          storeUrl = "net.daum.android.map";
        } else if (Platform.isIOS) {
          storeUrl = "https://apps.apple.com/kr/app/kakaomap/id304608425";
        }
      } else {
        url = "tmap://route?startx=$startLongitude&starty=$startLatitude&goalx=$endLongitude&goaly=$endLatitude&reqCoordType=WGS84&resCoordType=WGS84";
        if (Platform.isAndroid) {
          storeUrl = "com.skt.tmap.ku";
        } else if (Platform.isIOS) {
          storeUrl = "https://apps.apple.com/kr/app/t-map/id431589174";
        }
      }

      bool isInstalled = await canLaunchUrl(Uri.parse(url));
      if(isInstalled) {
        await launchUrl(Uri.parse(url));
      } else {
        Platform.isAndroid ? await launchUrl(Uri.parse(STORE_URL + storeUrl)) : await launchUrl(Uri.parse(storeUrl));
      }
    };

    if (type == "naver") {
      text = "네이버지도 바로가기";
      icon = Image.asset('assets/icons/image_naver_map.png', height: 24, width: 24);
    } else if (type == "kakao") {
      text = "카카오맵 바로가기";
      icon = Image.asset('assets/icons/image_kakao_map.png', height: 24, width: 24);
    } else {
      text = "티맵 바로가기";
      icon = Image.asset('assets/icons/image_t_map.png', height: 24, width: 24);
    }

    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: DaepiroColorStyle.g_50,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: icon
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: DaepiroTextStyle.body_2_m.copyWith(
                  color: DaepiroColorStyle.g_600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
