import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

class ItemCheerKeyword extends StatelessWidget {
  final String text;

  const ItemCheerKeyword({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(88),
          color: DaepiroColorStyle.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Text(
        text,
        style: DaepiroTextStyle.body_2_m.copyWith(
          color: DaepiroColorStyle.g_800,
        ),
      )
    );
  }
}
