import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

class NewsScreen extends ConsumerStatefulWidget {
  final String url;

  const NewsScreen({
    required this.url,
    super.key
  });

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/icon_arrow_left.svg',
                        alignment: Alignment.centerLeft,
                        colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '실시간 뉴스',
                        style: DaepiroTextStyle.h6.copyWith(
                          color: DaepiroColorStyle.g_800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Share.share(widget.url);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/icon_share.svg',
                        alignment: Alignment.centerRight,
                        colorFilter: const ColorFilter.mode(DaepiroColorStyle.g_900, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                        verticalScrollBarEnabled: true,
                        clearCache: true
                    ),
                ),
              ),
            ],
          ),
        )
    );
  }
}