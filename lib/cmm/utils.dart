import 'package:daepiro/cmm/exception.dart';
import 'package:daepiro/cmm/logger.dart';
import 'package:flutter/foundation.dart';

final DaepiroLogger logger = DaepiroLogger.instance;

Future<dynamic> launch(
Future<dynamic> Function() body, {
      Function(dynamic e)? onError,
}) async {
  try {
    final result = await body();
    return result;
  } on ApiException catch(e, stackTrace) {
    logger.e(e.toString(), error: e, stackTrace: stackTrace);
    if(e.type == ApiExceptionType.networkOff) {
      // 다이얼로그 띄우기
    } else if(e.type == ApiExceptionType.invalidAuthentication) {
      // 로그인 화면으로 이동
    }
  } catch(e, stackTrace) {
    logger.e(e.toString(), error: e, stackTrace: stackTrace);
    if(onError != null) {
      onError(e);
      return;
    }
    // 에러 처리 함수가 안주어진다면
    if(!kDebugMode) {
      // 현재 다이얼로그가 띄워졌는지 확인후 다이얼로그 띄움
    }
  }
}