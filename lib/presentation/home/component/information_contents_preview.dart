import 'package:daepiro/presentation/const/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

class InformationContentsPreview extends StatefulWidget {
  final String imagePath;
  final String title;
  final String from;
  final String date;
  final String bodyUrl;

  const InformationContentsPreview({
    super.key,
    required this.imagePath,
    required this.title,
    required this.from,
    required this.date,
    required this.bodyUrl,
  });

  @override
  State<InformationContentsPreview> createState() => _InformationContentsPreviewState();
}

class _InformationContentsPreviewState extends State<InformationContentsPreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/news/${Uri.encodeComponent(widget.bodyUrl)}');
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: DaepiroColorStyle.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: widget.imagePath.isEmpty
                  ? Image.asset(
                        'assets/icons/empty_image.png',
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover)
                  : Image.network(
                        widget.imagePath,
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover
                    ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: DaepiroTextStyle.body_1_b.copyWith(
                      color: DaepiroColorStyle.g_900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.from,
                        style: DaepiroTextStyle.caption.copyWith(
                          color: DaepiroColorStyle.g_700,
                        ),
                      ),
                      Text(
                        formatDateToDot(widget.date),
                        style: DaepiroTextStyle.caption.copyWith(
                          color: DaepiroColorStyle.g_200,
                        ),
                      )
                    ]
                  )
                ]
              ),
            )
          ]
        ),
      ),
    );
  }
}
