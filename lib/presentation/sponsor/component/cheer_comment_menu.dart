import 'dart:ui';
import 'package:daepiro/presentation/community/controller/community_disaster_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../cmm/DaepiroTheme.dart';
import '../../../../cmm/button/secondary_filled_button.dart';

class CheerCommentMenu extends ConsumerWidget {
  final bool isMine;
  final int id;
  final VoidCallback onClickDelete;

  const CheerCommentMenu({
    super.key,
    required this.isMine,
    required this.id,
    required this.onClickDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityDisasterProvider);
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: isMine
                ? editMenu(
                context,
                ref,
                id,
                onClickDelete,
                false
            ) : reportMenu(context)),
      ],
    );
  }

  Widget editMenu(
    BuildContext context,
    WidgetRef ref,
    int id,
    VoidCallback onClickDelete,
    bool isDisasterScreen,
  ) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              context.pop();
              deleteDialog(context, ref, id, onClickDelete);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: DaepiroColorStyle.g_50,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '삭제하기',
                    textAlign: TextAlign.center,
                    style: DaepiroTextStyle.body_1_b
                        .copyWith(color: DaepiroColorStyle.g_700),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget reportMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
          onTap: () {
            context.pop();
            context.push('/cheerReport/$id');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: DaepiroColorStyle.g_50,
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              '신고하기',
              textAlign: TextAlign.center,
              style: DaepiroTextStyle.body_1_b
                  .copyWith(color: DaepiroColorStyle.g_700),
            ),
          )),
    );
  }

  void deleteDialog(
      BuildContext context,
      WidgetRef ref,
      int id,
      VoidCallback onClickDelete,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: Colors.white,
            titlePadding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '댓글을 삭제하시겠습니까?',
                  style: DaepiroTextStyle.body_1_b.copyWith(
                      color: DaepiroColorStyle.g_900
                  ),
                )
              ],
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: SecondaryFilledButton(
                      verticalPadding: 12,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      radius: 8,
                      backgroundColor: DaepiroColorStyle.g_50,
                      pressedColor: DaepiroColorStyle.g_75,
                      child: Text(
                        textAlign: TextAlign.center,
                        '그만두기',
                        style: DaepiroTextStyle.body_1_b.copyWith(
                            color: DaepiroColorStyle.g_700
                        ),
                      )
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SecondaryFilledButton(
                        verticalPadding: 12,
                        onPressed: () async {
                          onClickDelete();
                          context.pop();
                          showDeleteSnackbar(
                            context,
                            onClickDelete,
                          );
                        },
                        radius: 8,
                        backgroundColor: DaepiroColorStyle.g_700,
                        pressedColor: DaepiroColorStyle.g_400,
                        child: Text(
                          textAlign: TextAlign.center,
                          '삭제하기',
                          style: DaepiroTextStyle.body_1_b.copyWith(
                              color: DaepiroColorStyle.white
                          ),
                        )),
                  )
                ],
              ),
            ],
          );
        });
  }

  void showDeleteSnackbar(
      BuildContext context,
      VoidCallback onClickDelete
    ) {
    onClickDelete();
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 20.0,
        right: 20.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Expanded(
                  child: Text(
                    '댓글이 삭제되었습니다.',
                    style: DaepiroTextStyle.body_2_m
                        .copyWith(color: DaepiroColorStyle.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
