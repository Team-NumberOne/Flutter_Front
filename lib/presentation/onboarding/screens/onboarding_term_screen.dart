import 'package:daepiro/presentation/const/string_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../cmm/theme/DaepiroTheme.dart';

class OnboardingTermScreen extends ConsumerWidget {
  final String? id;
  OnboardingTermScreen({super.key, this.id});

  final List<String> headerString = ['이용약관', '개인정보 처리 약관', '위치정보 이용 동의'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              headerWidget(context, headerString[int.tryParse(id!) ?? 0]),
              Expanded(
                child: SingleChildScrollView(
                  child: termTextWidget(int.tryParse(id ?? '0') ?? 0)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget termTextWidget(int id) {
    if(id == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Text(StringHelper.usingTermText),
      );
    } else if(id == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Text(StringHelper.infoTermText),
      );
    } else if(id==2) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(StringHelper.locationTermText));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget headerWidget(BuildContext context, String headerString) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => GoRouter.of(context).pop(),
              child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn)
              ),
            ),
            Expanded(
              child: Text(
                  headerString,
                  textAlign: TextAlign.center,
                  style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_800)
              ),
            ),
            Opacity(
              opacity: 0.0,
              child: SvgPicture.asset('assets/icons/icon_arrow_left.svg',
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}