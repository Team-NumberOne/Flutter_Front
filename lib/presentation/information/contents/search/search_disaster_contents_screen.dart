import 'dart:async';

import 'package:daepiro/presentation/const/emergency_disaster_list.dart';
import 'package:daepiro/presentation/information/contents/search/search_disaster_contents_state.dart';
import 'package:daepiro/presentation/information/contents/search/search_disaster_contents_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../cmm/theme/DaepiroTheme.dart';
import '../../component/disaster_contents_preview_item.dart';

class SearchDisasterContentsScreen extends ConsumerStatefulWidget {
  const SearchDisasterContentsScreen({super.key});

  @override
  ConsumerState<SearchDisasterContentsScreen> createState() => _SearchDisasterContentsScreenState();
}

class _SearchDisasterContentsScreenState extends ConsumerState<SearchDisasterContentsScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Map<String, String>> searchedDisasterContentsList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.clear();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(searchDisasterContentsStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                              context.pop(context);
                            },
                            child: SvgPicture.asset('assets/icons/icon_arrow_left.svg')
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: DaepiroTextStyle.body_1_m.copyWith(
                              color: DaepiroColorStyle.g_900,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: DaepiroColorStyle.g_50,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_controller.text.isNotEmpty) {
                                      _controller.clear();
                                      onSearchChanged("");
                                    }
                                  },
                                  child: _controller.text.isNotEmpty
                                    ? SvgPicture.asset('assets/icons/icon_delete.svg')
                                    : SvgPicture.asset('assets/icons/icon_search.svg')
                                ),
                              ),
                              suffixIconColor: DaepiroColorStyle.g_200,
                              hintText: "검색어를 입력해주세요.",
                              hintStyle: DaepiroTextStyle.body_1_m.copyWith(
                                color: DaepiroColorStyle.g_200,
                              ),
                            ),
                            onChanged: (text) {
                              onSearchChanged(text);
                            },
                          ),
                        )
                      ]
                  ),
                ),
                Flexible(
                  child: Container(
                      color: Colors.white,
                      padding: viewModel.searchedContentsList.isNotEmpty ? const EdgeInsets.symmetric(horizontal: 12, vertical: 20) : const EdgeInsets.all(0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.searchedContentsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DisasterContentsItem(
                                title: viewModel.searchedContentsList[index].title ?? "",
                                imagePath: viewModel.searchedContentsList[index].thumbnailUrl ?? "",
                                from: viewModel.searchedContentsList[index].source ?? "",
                                date: viewModel.searchedContentsList[index].publishedAt ?? "",
                                bodyUrl: viewModel.searchedContentsList[index].bodyUrl ?? ""
                            );
                          }
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSearchChanged(String text) {
    _debounce?.cancel();
    if (text.isEmpty) {
      searchedDisasterContentsList = [];
    } else {
      searchedDisasterContentsList = searchDisasterList(text);
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchDisasterContentsStateNotifierProvider.notifier)
          .searchDisasterContents(keyword: text);
    });
  }
}

List<Map<String, String>> searchDisasterList(String text) {
  return EmergencyDisasterList.where((item) {
    return item['name']!.contains(text);
  }).toList();
}
