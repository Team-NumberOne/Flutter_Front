import 'package:daepiro/data/model/response/information/around_shelter_list_response.dart';
import 'package:daepiro/presentation/information/component/item_around_shelter.dart';
import 'package:daepiro/presentation/information/shelter/around_shelter_extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cmm/theme/DaepiroTheme.dart';
import '../../../cmm/widget/chip/secondary_chip.dart';
import '../../const/const.dart';

class AroundShelterScreen extends StatefulWidget {
  final AroundShelterExtra extra;

  const AroundShelterScreen({
    super.key,
    required this.extra,
  });

  @override
  State<AroundShelterScreen> createState() => _AroundShelterScreen();
}

class _AroundShelterScreen extends State<AroundShelterScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedDisasterType = 0;
  List<Shelters> shelterList = [];

  @override
  void initState() {
    super.initState();
    shelterList = widget.extra.earthquakeShelterList;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      GoRouter.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 4, bottom: 4, left: 12),
                      child: SvgPicture.asset(
                        'assets/icons/icon_arrow_left.svg',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    child: Text(
                      "주변 대피소 목록",
                      style: DaepiroTextStyle.h6.copyWith(
                        color: DaepiroColorStyle.g_800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    for (int index=0;index<Const.disasterTypeList.length;index++)
                      Row(
                        children: [
                          SecondaryChip(
                              isSelected: index == _selectedDisasterType,
                              text: Const.disasterTypeList[index],
                              onPressed: () {
                                setState(() {
                                  _selectedDisasterType = index;

                                  if (index == 0) {
                                    shelterList = widget.extra.civilShelterList;
                                  } else if (index == 1) {
                                    shelterList = widget.extra.earthquakeShelterList;
                                  } else if (index == 2) {
                                    shelterList = widget.extra.tsunamiShelterList;
                                  } else if (index == 3) {
                                    shelterList = widget.extra.temperatureShelterList;
                                  }
                                });

                                _scrollController.animateTo(
                                  0.0, // 최상단
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                          ),
                          const SizedBox(width: 8)
                        ],
                      )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                    color: DaepiroColorStyle.g_50,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/icon_location_24.svg'),
                    const SizedBox(width: 4),
                    Text(
                      widget.extra.address,
                      style: DaepiroTextStyle.body_1_m.copyWith(
                        color: DaepiroColorStyle.g_600,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: shelterList.length,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemAroundShelter(
                          name: shelterList[index].name ?? "",
                          distinct: shelterList[index].distance ?? 0,
                          address: shelterList[index].address ?? "",
                          startLatitude: widget.extra.latitude,
                          startLongitude: widget.extra.longitude,
                          endLatitude: shelterList[index].latitude ?? 0,
                          endLongitude: shelterList[index].longitude ?? 0
                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
