import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../const/const.dart';

class ItemEmergencyResponse extends StatelessWidget {
  final int tabIndex;
  final int pageIndex;

  const ItemEmergencyResponse({
    super.key,
    required this.tabIndex,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    offset: const Offset(0, 0),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                          color: DaepiroColorStyle.g_50,
                          borderRadius: BorderRadius.circular(14)
                      ),
                      child: Text(
                          Const.emergencyResponseList[tabIndex][pageIndex][0],
                          style: DaepiroTextStyle.body_2_m.copyWith(
                            color: DaepiroColorStyle.g_600,
                          )
                      )
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: DaepiroColorStyle.g_50,
                    ),
                    child: Image.asset(Const.emergencyResponseList[tabIndex][pageIndex][1])
                  ),
                  const SizedBox(height: 30),
                  if (Const.emergencyResponseList[tabIndex][pageIndex][2].isNotEmpty)
                    Column(
                      children: [
                        Text(
                          Const.emergencyResponseList[tabIndex][pageIndex][2],
                          style: DaepiroTextStyle.body_1_b.copyWith(
                            color: DaepiroColorStyle.g_700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  Text(
                    Const.emergencyResponseList[tabIndex][pageIndex][3],
                    style: DaepiroTextStyle.body_2_m.copyWith(
                      color: DaepiroColorStyle.g_600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (tabIndex == 1 && pageIndex == 2)
                    Column(
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "*주의 : 벌침을 핀셋으로 뽑지 말아주세요.",
                          style: DaepiroTextStyle.caption.copyWith(
                            color: DaepiroColorStyle.r_300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  if (tabIndex == 1 && pageIndex == 3)
                    Column(
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "*물린 지 15분 이내라면, 물린 부위의 10cm 위에\n폭 2cm 이상의 헝겊으로 느슨하게 묶어주세요.",
                          style: DaepiroTextStyle.caption.copyWith(
                            color: DaepiroColorStyle.r_300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  const SizedBox(height: 14),
                ],
              )
          ),
        ],
      ),
    );
  }
}
