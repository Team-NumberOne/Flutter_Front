import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

class DisasterType extends StatelessWidget {
  final String name;
  final VoidCallback onClick;

  const DisasterType({
    super.key,
    required this.name,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return DaepiroColorStyle.g_75;
          }
          return DaepiroColorStyle.white;
        }),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: onClick,
        child: Ink(
          color: DaepiroColorStyle.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: DaepiroColorStyle.g_50,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: DaepiroColorStyle.g_50,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(findDisasterIconByName(name: name), height: 36, width: 36),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: DaepiroTextStyle.body_2_m.copyWith(
                      color: DaepiroColorStyle.g_500
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
