import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

class ItemCheerComment extends StatefulWidget {
  final String name;
  final String date;
  final String contents;
  final VoidCallback onClickMenu;
  final bool isMine;

  const ItemCheerComment({
    super.key,
    required this.name,
    required this.date,
    required this.contents,
    required this.onClickMenu,
    required this.isMine,
  });

  @override
  State<ItemCheerComment> createState() => _ItemCheerCommentState();
}

class _ItemCheerCommentState extends State<ItemCheerComment> {
  bool _isHighlighted = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isHighlighted = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 0, left: 20, bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: (_isHighlighted && widget.isMine && timeAgoTwoSecond(widget.date)) ? DaepiroColorStyle.o_50 : DaepiroColorStyle.white,
          boxShadow: [
            BoxShadow(
              color: DaepiroColorStyle.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 0),
            )
          ]
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/icon_funding.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(DaepiroColorStyle.o_300, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.name} · ${timeAgo(widget.date)}",
                        style: DaepiroTextStyle.caption.copyWith(
                          color: DaepiroColorStyle.g_900,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onClickMenu();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/icon_more2.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_300, BlendMode.srcIn),
                      ),
                    )
                  ],
                ),
                Text(
                  widget.contents,
                  style: DaepiroTextStyle.body_2_m.copyWith(
                    color: DaepiroColorStyle.g_800,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  bool timeAgoTwoSecond(String date) {
    DateTime past = DateTime.parse(date).toLocal();
    Duration difference = DateTime.now().difference(past);

    return difference.inSeconds <= 2;
  }
}

