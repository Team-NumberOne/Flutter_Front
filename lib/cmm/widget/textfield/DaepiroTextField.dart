import 'package:flutter/material.dart';

/// 앱에서 사용할 검색 인풋박스
class DaepiroTextField extends StatefulWidget {
  /// 자동포커스 활성화여부
  final bool autofocus;

  /// clear 버튼 사용여부
  final bool useClearButton;

  /// 힌트 텍스트
  final String? hintText;

  /// 완료시 호출
  final Function(String value)? onSubmit;

  /// 값이 변경될때 호출되는 함수
  final Function(String value)? onChanged;

  /// 전체 Padding
  final EdgeInsetsGeometry? padding;

  // 검색 입력칸 radius
  final double radius;

  /// 위젯 높이
  final double height;

  /// 검색어 최대 글자수
  final int? maxLength;

  /// 초기 검색어
  final String initValue;

  const DaepiroTextField({
    super.key,
    this.onSubmit,
    this.onChanged,
    this.padding,
    this.radius = 8,
    this.hintText,
    this.height = 40,
    this.initValue = '',
    this.autofocus = true,
    this.useClearButton = true,
    this.maxLength,
  });

  @override
  State<StatefulWidget> createState() {
    return _DaepiroTextFieldState();
  }
}

class _DaepiroTextFieldState extends State<DaepiroTextField> {
  late final TextEditingController _inputEditingCtrl;
  String _currentValue = '';

  @override
  void initState() {
    super.initState();
    _inputEditingCtrl = TextEditingController(text: widget.initValue);
    _currentValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FDSTheme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide.none,
      gapPadding: 0,
    );

    final contentPadding = widget.showSearchIcon
        ? const EdgeInsetsDirectional.symmetric(horizontal: 4, vertical: 8)
        : EdgeInsets.zero;

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: widget.height,
              child: TextField(
                inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
                controller: _searchInputCtl,
                autofocus: widget.autofocus,
                cursorColor: theme.semanticColors.iconPrimary,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: theme.semanticColors.bgSecondary,
                  prefixIcon: widget.showSearchIcon
                      ? const Padding(
                    padding: EdgeInsetsDirectional.only(start: 8.0, end: 4),
                    child: Icon(
                      FDSBaseIcons.ic_line_search,
                      size: 20,
                    ),
                  )
                      : null,
                  prefixIconConstraints: const BoxConstraints(minWidth: 20),
                  hintText: widget.hintText ?? '',
                  hintStyle:
                  theme.textTheme.body2Regular.copyWith(color: theme.semanticColors.textInfo),
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border,
                  errorBorder: border,
                  disabledBorder: border,
                  suffixIcon: _getSuffixIcon(),
                  contentPadding: contentPadding,
                ),
                onChanged: (value) {
                  setState(() {
                    _currentValue = value;
                  });
                  widget.onChanged?.call(value);
                },
                style: theme.textTheme.body2Regular,
                onSubmitted: (value) {
                  if (value.trim().isEmpty) {
                    clear();
                  }
                  widget.onSearch?.call(value);
                },
              ),
            ),
          ),
          if (widget.useCancelButton)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              child: TextButton(
                onPressed: () {
                  widget.onCanceled?.call();
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Text(
                  Resource.messages.searchPage_Lable_InputCancelMessage,
                  style: theme.textTheme.body1Medium
                      .copyWith(color: theme.semanticColors.textSecondary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 인풋 박스 내부 끝부분에 표시될 아이콘 버튼
  Widget? _getSuffixIcon() {
    Widget? suffixIcon;
    const iconButtonMinWidth = 40.0;
    if (widget.useClearButton) {
      // 클리어버튼
      final clearButton = FDSIconButton(
        icon: FDSBaseIcons.ic_line_close_sm,
        padding: const EdgeInsets.all(4.0),
        iconSize: 20,
        onTap: () => clear(),
      );

      suffixIcon = SizedBox(
        width: iconButtonMinWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.useClearButton)
              _currentValue.isNotEmpty ? clearButton : const SizedBox(width: iconButtonMinWidth),
          ],
        ),
      );
    }
    return suffixIcon;
  }

  void clear() {
    _searchInputCtl.clear();
    setState(() {
      _currentValue = '';
    });
    widget.onChanged?.call('');
  }
}