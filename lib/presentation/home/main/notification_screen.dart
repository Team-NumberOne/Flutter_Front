import 'package:daepiro/presentation/home/component/notification_item.dart';
import 'package:daepiro/presentation/home/main/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {

  @override
  void initState() {
    super.initState();
    ref.read(homeStateNotifierProvider.notifier).getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: DaepiroColorStyle.white,
          child: Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 4, bottom: 4, left: 12),
                      child: SvgPicture.asset('assets/icons/icon_arrow_left.svg'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    child: Text(
                      "알림",
                      style: DaepiroTextStyle.h6.copyWith(
                        color: DaepiroColorStyle.g_800,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                      itemCount: viewModel.notificationList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return NotificationItem(
                            type: viewModel.notificationList[index].category ?? "",
                            title: viewModel.notificationList[index].title ?? "",
                            contents: viewModel.notificationList[index].body ?? "",
                            date: viewModel.notificationList[index].createdAt ?? ""
                        );
                      }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}