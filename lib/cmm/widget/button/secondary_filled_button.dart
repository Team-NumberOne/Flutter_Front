import 'package:flutter/material.dart';

class SecondaryFilledButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final double radius;
  final Widget child;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Color backgroundColor;
  final Color? pressedColor;
  final Color? disableColor;

  const SecondaryFilledButton({
    super.key,
    required this.onPressed,
    required this.radius,
    required this.child,
    this.verticalPadding,
    this.horizontalPadding,
    required this.backgroundColor,
    this.disableColor,
    this.pressedColor
  });

  @override
  _SecondaryFilledButton createState() => _SecondaryFilledButton();
}

class _SecondaryFilledButton extends State<SecondaryFilledButton> {

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          overlayColor: Colors.transparent,
          backgroundColor: widget.backgroundColor,
          disabledBackgroundColor: widget.disableColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius)
          ),
          elevation: 0.0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 0, horizontal: widget.horizontalPadding ?? 0)
        ).copyWith(//g_400
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed) && widget.pressedColor!=null) {
              return widget.pressedColor!;
            }
            return widget.backgroundColor;
          }),
        ),
          onPressed: widget.onPressed,
          child: widget.child
      ),
    );
  }

}