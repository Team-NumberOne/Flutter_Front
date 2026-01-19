import '../resource/message/AppResources.dart';

enum ApiExceptionType {
  invalidAuthentication, // 401, 404
  networkTimeout,
  networkOff,
  invalidServerInfo, // 500
  commonException;

  String get message {
    switch (this) {
      case ApiExceptionType.invalidAuthentication:
        return AppResources.ApiException_invalidAuthentication;
      case ApiExceptionType.networkTimeout:
        return AppResources.ApiException_networkTimeout;
      case ApiExceptionType.networkOff:
        return AppResources.ApiException_networkOff;
      case ApiExceptionType.invalidServerInfo:
        return AppResources.ApiException_invalidServerInfo;
      case ApiExceptionType.commonException:
        return AppResources.ApiException_Default;
    }
  }
}

class ApiException implements Exception {
  final int code;
  final ApiExceptionType type;
  final String message;

  ApiException({required this.code, required this.type, String? message})
      : message = message ?? '';

  @override
  String toString() => type.message;
}

class ApiExceptionMapper {
  /// 서버에서 내려온 code를 ApiException으로 변환
  static ApiException fromServer({
    required int code,
    String? serverMessage,
  }) {
    final ApiExceptionType type;

    switch (code) {
    // 인증 / 권한 관련
      case 401:
      case 403:
      case 404:
        type = ApiExceptionType.invalidAuthentication;
        break;

    // 타임아웃
      case 408:
        type = ApiExceptionType.networkTimeout;
        break;

    // 서버 오류
      case 500:
      case 502:
      case 503:
        type = ApiExceptionType.invalidServerInfo;
        break;

    // 그 외는 공통 오류로 묶음
      default:
        type = ApiExceptionType.commonException;
        break;
    }

    return ApiException(
      code: code,
      type: type,
      message: serverMessage,
    );
  }
}