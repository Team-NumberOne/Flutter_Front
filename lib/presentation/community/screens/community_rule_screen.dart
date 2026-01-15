import 'package:daepiro/presentation/community/controller/community_disaster_view_model.dart';
import 'package:daepiro/presentation/const/string_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../const/AppStrings.dart';
import '../../const/const.dart';
//공지사항 페이지
class CommunityRuleScreen extends ConsumerWidget {
  const CommunityRuleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerWidget(context),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        bodyWidget(context),
                        footerWidget(),
                        SizedBox(height: 20)
                      ],
                    ),
                  )),
            ],
          ),
        )
      )
    );
  }

  Widget headerWidget(BuildContext context) {
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
                  '공지사항',
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


  Widget bodyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text('대피로 커뮤니티 수칙',
        style: DaepiroTextStyle.h6.copyWith(color: DaepiroColorStyle.g_900),),
        SizedBox(height: 8),
        Text('2025.03.01', style: DaepiroTextStyle.caption.copyWith(color: DaepiroColorStyle.g_400),),
        SizedBox(height: 24),
        Text(AppStrings.daepiroCommunityRule, style: DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_800)),
        SizedBox(height: 36),
        communityRuleItemWidget(AppStrings.shareFineInformationTitle, AppStrings.shareFineInformationSubTitle, Const.communityRuleList1),
        SizedBox(height: 36),
        communityRuleItemWidget(AppStrings.cleanClutureTitle, AppStrings.cleanClutureSubTitle, Const.communityRuleList2),
        SizedBox(height: 36),
        communityRuleItemWidget(AppStrings.protectTitle, AppStrings.protectSubTitle, Const.communityRuleList3),
        SizedBox(height: 36),
        communityRuleItemWidget(AppStrings.respectTitle, AppStrings.respectSubTitle, Const.communityRuleList4),
        SizedBox(height: 36),
        Text(AppStrings.limitTitle, style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_900)),
        SizedBox(height: 8),
        RichText(
            text: TextSpan(
              style: DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_400),
              children: <TextSpan> [
                TextSpan(text: AppStrings.limitDescription),
                TextSpan(
                    text: '이용약관',
                    style: DaepiroTextStyle.body_2_b.copyWith(color: DaepiroColorStyle.g_900, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => GoRouter.of(context).push('/onboarding_terms/0')
                ),
                TextSpan(text: '을 참고해주세요.'),
              ]
            )
        ),
        SizedBox(height: 36),
        Text(AppStrings.finalDescription, style: DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_800),),
        SizedBox(height: 24),
      ],
    );
  }

  Widget communityRuleItemWidget(String title, String subTitle, List<String> descriptionList) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                  'assets/icons/icon_certification.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                      DaepiroColorStyle.o_300, BlendMode.srcIn)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: DaepiroTextStyle.body_1_b.copyWith(color: DaepiroColorStyle.g_800),
                  softWrap: true,
                  maxLines: 2,
                overflow: TextOverflow.visible,),
              )
            ],
          ),
          SizedBox(height: 10),
          Text(subTitle, style: DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_400)),
          SizedBox(height: 10),
          ListView.builder(
            itemCount: descriptionList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    SvgPicture.asset(
                        'assets/icons/icon_start.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                            DaepiroColorStyle.g_100, BlendMode.srcIn)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                          descriptionList[index],
                        style: DaepiroTextStyle.body_2_m.copyWith(color: DaepiroColorStyle.g_400),
                      ),
                    )
                  ],
                );
              }
          )
        ],
      ),
    );
  }

  Widget footerWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Text('CONTACT: daepiro82@gmail.com',
          style: DaepiroTextStyle.caption.copyWith(color: DaepiroColorStyle.g_400),
        ),
      ),
    );
  }

}