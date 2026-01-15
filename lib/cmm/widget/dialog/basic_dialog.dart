import 'package:flutter/material.dart';

class BasicDialog extends StatelessWidget {
  final Widget titleWidget;
  final Widget contentWidget;
  final Widget doneWidget;
  final Widget actionWidget;

  const BasicDialog({
    super.key,
    required this.titleWidget,
    required this.contentWidget,
    required this.doneWidget,
    required this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [titleWidget],
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [contentWidget],
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(child: doneWidget),
            const SizedBox(width: 8),
            Expanded(child: actionWidget),
          ],
        ),
      ],
    );
  }

  static Future<void> show(
      BuildContext context, {
        required Widget titleWidget,
        required Widget contentWidget,
        required Widget doneWidget,
        required Widget actionWidget,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BasicDialog(
          titleWidget: titleWidget,
          contentWidget: contentWidget,
          doneWidget: doneWidget,
          actionWidget: actionWidget,
        );
      },
    );
  }
}
