import 'package:flutter/material.dart';

import '../../theme/DaepiroTheme.dart';


class PrimaryFilledButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color pressedColor;
  final double borderRadius;
  final Color? disabledColor;
  final Widget child;
  final double verticalPadding;

  const PrimaryFilledButton({
    super.key,
    this.onPressed,
    required this.backgroundColor,
    required this.pressedColor,
    required this.borderRadius,
    this.disabledColor,
    required this.child,
    required this.verticalPadding
  });

  @override
  _PrimaryFilledButton createState() => _PrimaryFilledButton();
}

class _PrimaryFilledButton extends State<PrimaryFilledButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        elevation: WidgetStateProperty.all(1.0),
        shadowColor: WidgetStateProperty.all(DaepiroColorStyle.black.withOpacity(0.15)),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: widget.verticalPadding),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return widget.disabledColor ?? widget.backgroundColor;  // 비활성화 상태 색상
            }
            if (states.contains(WidgetState.pressed)) {
              return widget.pressedColor;  // 눌렀을 때의 색상
            }
            return widget.backgroundColor;  // 기본 색상
          },
        ),
      ),
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}

