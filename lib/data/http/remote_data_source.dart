import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:daepiro/cmm/exception.dart';
import 'package:dio/dio.dart';

class RemoteDataSource {
  static const int successCode = 200;

  Future<T> apiCall<T>(Future<T> Function() task) async {
    await _checkNetworkConnection();
    try {
      final response = await task();
      return response;
    } on DioException catch(e) {
      if(e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.sendTimeout) {
        throw ApiException(code: 408, type: ApiExceptionType.networkTimeout);
      }
      if(e.type == DioExceptionType.connectionError) {
        throw ApiException(code: -1, type: ApiExceptionType.networkOff);
      }
      // 서버가 응답은 했지만 에러인 상태
      if (e.type == DioExceptionType.badResponse) {
        final response = e.response?.data;

        final int code = _extractCode(response);
        final String? message = _extractMessage(response);

        throw ApiExceptionMapper.fromServer(
          code: code,
          serverMessage: message,
        );
      }
      throw ApiException(code: -1, type: ApiExceptionType.commonException);
    }
  }

  Future<void> _checkNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult.contains(ConnectivityResult.none)) {
      throw ApiException(code: -1, type: ApiExceptionType.networkOff);
    }
  }

  static int _extractCode(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['code'] as int? ?? -1;
    }
    return -1;
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String?;
    }
    return null;
  }

}
