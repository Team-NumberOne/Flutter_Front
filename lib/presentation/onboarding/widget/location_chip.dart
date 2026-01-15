import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../cmm/theme/DaepiroTheme.dart';

//지역 별명 칩 focusnode 관리로 인해 따로 정의
class LocationChip extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final WidgetRef ref;
  final FocusNode focusNode;
  final int index;
  final void Function()? onTapOutside;

  const LocationChip({super.key, 
    required this.controller,
    required this.onChanged,
    required this.ref,
    required this.focusNode,
    required this.index,
    this.onTapOutside,
  });

  @override
  _LocationChipState createState() => _LocationChipState();
}

class _LocationChipState extends State<LocationChip> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: widget.focusNode.hasFocus
              ? DaepiroColorStyle.g_400
              : DaepiroColorStyle.g_600,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
              child: SvgPicture.asset(
                'assets/icons/icon_location_24.svg',
                colorFilter:
                    const ColorFilter.mode(DaepiroColorStyle.white, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: TextField(
                focusNode: widget.focusNode,
                cursorWidth: 4,
                maxLength: 8,
                onChanged: widget.onChanged,
                cursorColor: DaepiroColorStyle.white,
                controller: widget.controller,
                onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
                widget.onTapOutside?.call();
                },
                style: DaepiroTextStyle.body_2_b
                    .copyWith(color: DaepiroColorStyle.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
