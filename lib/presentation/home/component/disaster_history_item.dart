import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../cmm/theme/DaepiroTheme.dart';
import '../../const/utils.dart';

class DisasterHistoryItem extends StatefulWidget {
  final String icon;
  final String title;
  final String contents;
  final String date;
  final bool isVisibleDate;
  final VoidCallback onClick;

  const DisasterHistoryItem({
    super.key,
    required this.icon,
    required this.title,
    required this.contents,
    required this.date,
    required this.isVisibleDate,
    required this.onClick,
  });

  @override
  _DisasterHistoryItem createState() => _DisasterHistoryItem();
}

class _DisasterHistoryItem extends State<DisasterHistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          if (widget.isVisibleDate)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  alignment: Alignment.topLeft,
                  child: Text(
                    formatDateToDot(widget.date),
                    style: DaepiroTextStyle.body_1_b.copyWith(
                      color: DaepiroColorStyle.g_900,
                    ),
                  ),
                ),
                const SizedBox(height: 8)
              ],
            ),
          GestureDetector(
            onTap: () {
              widget.onClick();
            },
            child: Container(
              color: DaepiroColorStyle.white,
              // padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 42,
                      height: 42,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: DaepiroColorStyle.o_50,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: SvgPicture.asset(
                              findDisasterIconByName(name: widget.icon),
                              width: 26,
                              height: 26,
                              colorFilter: const ColorFilter.mode(DaepiroColorStyle.o_500, BlendMode.srcIn),
                          )
                      )
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getHighlightText(title: widget.title, disaster: widget.icon),
                        const SizedBox(height: 2),
                        Text(
                          widget.contents,
                          style: DaepiroTextStyle.body_2_m.copyWith(
                            color: DaepiroColorStyle.g_500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatDateToDateTime(widget.date),
                          style: DaepiroTextStyle.caption.copyWith(
                            color: DaepiroColorStyle.g_200,
                          ),
                        )
                      ]
                    ),
                  )
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}