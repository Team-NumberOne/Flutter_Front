import 'package:daepiro/data/model/response/information/behavior_list_response.dart';
import 'package:daepiro/presentation/information/component/search_disaster_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../cmm/theme/DaepiroTheme.dart';

class SearchDisasterTypeScreen extends StatefulWidget {
  final List<Behavior> behaviorList;

  const SearchDisasterTypeScreen({
    super.key,
    required this.behaviorList
  });

  @override
  State<SearchDisasterTypeScreen> createState() => _SearchDisasterTypeScreenState();
}

class _SearchDisasterTypeScreenState extends State<SearchDisasterTypeScreen> {
  List<Behavior> searchedDisasterList = List.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: DaepiroColorStyle.g_50,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20,8,12,8),
                color: Colors.white,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: SvgPicture.asset('assets/icons/icon_arrow_left.svg')
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                          child: TextField(
                            style: DaepiroTextStyle.body_1_m.copyWith(
                                color: DaepiroColorStyle.g_900
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: DaepiroColorStyle.g_50,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              suffixIcon: Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                  child: SvgPicture.asset('assets/icons/icon_search.svg')
                              ),
                              suffixIconColor: DaepiroColorStyle.g_200,
                              hintText: "재난명을 입력해주세요.",
                              hintStyle: DaepiroTextStyle.body_1_m.copyWith(
                                color: DaepiroColorStyle.g_200,
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {
                                if (text.isEmpty) {
                                  searchedDisasterList = List.empty();
                                } else {
                                  searchedDisasterList = searchDisasterList(text: text);
                                }
                              });
                            },
                          )
                      )
                    ]
                ),
              ),
              Flexible(
                child: Container(
                    color: Colors.white,
                    padding: searchedDisasterList.isNotEmpty ? const EdgeInsets.symmetric(horizontal: 12, vertical: 20) : const EdgeInsets.all(0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchedDisasterList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SearchDisasterType(
                              name: searchedDisasterList[index].name!,
                              behaviorList: widget.behaviorList
                          );
                        }
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Behavior> searchDisasterList({
    required String text
  }) {
    return widget.behaviorList.where((item) {
      return item.name!.contains(text);
    }).toList();
  }

}
