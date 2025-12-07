import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<String> copyMbtiles() async {
  final data = await rootBundle.load('assets/map/gwangjin.mbtiles');
  //final data = await rootBundle.load('assets/map/gangnam.mbtiles');
  final bytes = data.buffer.asUint8List();

  // 2) 앱 내부 Document directory 경로 얻기
  final dir = await getApplicationDocumentsDirectory();
  final filePath = '${dir.path}/gwangjin.mbtiles';
  //final filePath = '${dir.path}/gangnam.mbtiles';
  final file = File(filePath);

  // 3) 이미 존재하면 덮어쓰지 않아도 됨
  if (!file.existsSync()) {
    await file.writeAsBytes(bytes, flush: true);
  }

  print('저장 완료: $filePath');
  return filePath;

}