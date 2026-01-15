import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../data/model/response/information/behavior_list_response.dart';
import 'behavior_tip_bottom_sheet.dart';

class SearchDisasterType extends StatelessWidget {
  final String name;
  final List<Behavior> behaviorList;

  const SearchDisasterType({
    super.key,
    required this.name,
    required this.behaviorList,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) {
              return BehaviorTipBottomSheet(
                behavior: behaviorList.firstWhere((item) => item.name == name)
              );
            }
        );
      },
      child: Container(
        color: DaepiroColorStyle.white,
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              findDisasterIconByName(name: name),
              colorFilter: const ColorFilter.mode(DaepiroColorStyle.o_400, BlendMode.srcIn),
              width: 36,
              height: 36
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: DaepiroTextStyle.body_1_m.copyWith(
                    color: DaepiroColorStyle.g_900
                ),
              ),
            ),
            SvgPicture.asset(
                'assets/icons/icon_arrow_right.svg',
                colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_200, BlendMode.srcIn),
                width: 20,
                height: 20
            ),
          ],
        ),
      ),
    );
  }
}
