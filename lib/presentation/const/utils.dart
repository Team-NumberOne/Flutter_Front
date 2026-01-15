import 'package:daepiro/presentation/const/common_disaster_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../cmm/theme/DaepiroTheme.dart';
import 'emergency_disaster_list.dart';

// "2024-12-15T18:08:00" 형식의 String을 yyyy.mm.dd 형태로 변환
String formatDateToDot(String date) {
  if (date.isEmpty) return "";

  DateTime parsedDate = DateTime.parse(date);
  String formattedDate = DateFormat('yyyy.MM.dd').format(parsedDate);
  return formattedDate;
}

// "2024-12-15T18:08:00" 형식의 String을 yyyy.mm.dd hh:mm형태로 변환
String formatDateToDateTime(String date) {
  if (date.isEmpty) return "";

  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat("yyyy.MM.dd a hh:mm").format(dateTime);
  formattedDate = formattedDate.replaceAll("AM", "오전").replaceAll("PM", "오후");

  return formattedDate;
}

// "2024-12-15T18:08:00" 형식의 String을 D-13 형태로 변환
String calculateDaysDiff(String date) {
  if (date.isEmpty) return "상시";

  DateTime parsedDate = DateTime.parse(date);
  DateTime now = DateTime.now();

  DateTime parsedDateOnly =
      DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
  DateTime nowDateOnly = DateTime(now.year, now.month, now.day);

  int difference = nowDateOnly.difference(parsedDateOnly).inDays;

  // D-day 형식으로 반환
  if (difference == 0) {
    return "D-day";
  } else if (difference > 0) {
    return "D+$difference"; // 과거
  } else {
    return "D$difference"; // 미래
  }
}

// "2024-12-15T18:08:00" 형식의 String을 n분 전 형태로 변환
String timeAgo(String date) {
  DateTime past = DateTime.parse(date).toLocal();
  Duration difference = DateTime.now().difference(past);

  if (difference.inMinutes < 1) {
    return "방금전";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes}분전";
  } else if (difference.inHours < 24) {
    return "${difference.inHours}시간전";
  } else {
    return "${difference.inDays}일전";
  }
}

// 재난명으로 아이콘 찾기
String findDisasterIconByName({required String name}) {
  for (var item in EmergencyDisasterList + CommonDisasterList) {
    if (item["name"] == name) {
      return item["icon"] ?? "";
    }
  }

  return "";
}

// 재난명을 강조해서 Text 반환
Text getHighlightText({required String title, required String disaster}) {
  List<TextSpan> spans = [];
  int start = 0;

  while (true) {
    int index = title.indexOf(disaster, start);
    if (index == -1) {
      spans.add(TextSpan(text: title.substring(start)));
      break;
    }

    if (index > start) {
      spans.add(TextSpan(text: title.substring(start, index)));
    }

    spans.add(TextSpan(
      text: disaster,
      style: const TextStyle(color: DaepiroColorStyle.o_500),
    ));

    start = index + disaster.length;
  }

  return Text.rich(TextSpan(
    children: spans,
    style: DaepiroTextStyle.body_1_b.copyWith(
      color: DaepiroColorStyle.g_900,
    ),
  ));
}

// 재난명을 강조해서 큰글씨 Text 반환
Text getLargeHighlightText({required String title, required String disaster}) {
  List<TextSpan> spans = [];
  int start = 0;

  while (true) {
    int index = title.indexOf(disaster, start);
    if (index == -1) {
      spans.add(TextSpan(text: title.substring(start)));
      break;
    }

    if (index > start) {
      spans.add(TextSpan(text: title.substring(start, index)));
    }

    spans.add(TextSpan(
      text: disaster,
      style: const TextStyle(color: DaepiroColorStyle.o_500),
    ));

    start = index + disaster.length;
  }

  return Text.rich(TextSpan(
    children: spans,
    style: DaepiroTextStyle.h5.copyWith(
      color: DaepiroColorStyle.g_900,
    ),
  ));
}

//00분전, 00일전으로 시간 반환
String parseRegTime(String timeText) {
  if (timeText == '') {
    return '';
  }
  DateTime dateTime = DateTime.parse(timeText).toLocal();
  DateTime currentTime = DateTime.now();
  Duration differ = currentTime.difference(dateTime);

  if (differ.inMinutes < 1) {
    return '방금 전';
  } else if (differ.inMinutes < 60) {
    return '${differ.inMinutes}분전';
  } else if (differ.inHours < 24) {
    return '${differ.inHours} 시간전';
  } else {
    return '${differ.inDays}일전';
  }
}

//오후 00시 00분 형식으로 시간 반환
String parseDateTime(String timeText) {
  if (timeText == '') {
    return '';
  }
  DateTime dateTime = DateTime.parse(timeText).toLocal();
  String period = dateTime.hour >= 12 ? '오후' : '오전';
  String hour = (period == '오전' ? dateTime.hour : dateTime.hour - 12).toString().padLeft(2, '0');
  period == '오후' && hour == '00' ? hour = '12' : hour;
  String minute = dateTime.minute.toString().padLeft(2, '0');
  return '${period} ${hour}:${minute}';
}

//특수문자 판단용
bool checkForSpecialCharacter(String text) {
  final regex = RegExp(r'[^가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]+$');
  return !regex.hasMatch(text);
}

//영문 판단용
bool checkForNameRule(String text) {
  final pattern = RegExp(r'[a-zA-Z0-9\p{P}\p{S}\s]', unicode: true);
  return pattern.hasMatch(text);
}

//이메일 형식 체크
bool isEmailValid(String email) {
  if (email.isEmpty) return false;
  final regExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  if(!regExp.hasMatch(email)) return false;
  return true;
}

String calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  double distanceInMeters = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);

  if (distanceInMeters >= 1000) {
    return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
  } else {
    return '${distanceInMeters.round()}m';
  }
}