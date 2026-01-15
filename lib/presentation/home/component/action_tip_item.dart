import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../cmm/theme/DaepiroTheme.dart';

class ActionTipItem extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onClick;

  const ActionTipItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onClick,
  });

  @override
  State<ActionTipItem> createState() => _ActionTipItemState();
}

class _ActionTipItemState extends State<ActionTipItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return DaepiroColorStyle.g_75;
          }
          return DaepiroColorStyle.white;
        }),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: widget.onClick,
        child: Ink(
          color: DaepiroColorStyle.white,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.isSelected
                    ? SvgPicture.asset('assets/icons/icon_check_box_enabled.svg', colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_500, BlendMode.srcIn), width: 32, height: 32)
                    : SvgPicture.asset('assets/icons/icon_check_box_disabled.svg', colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_100, BlendMode.srcIn), width: 32, height: 32),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.text,
                    style: DaepiroTextStyle.body_2_m.copyWith(
                      color: widget.isSelected ? DaepiroColorStyle.g_200 : DaepiroColorStyle.g_800,
                    ),
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
