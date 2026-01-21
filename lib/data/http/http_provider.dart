import 'package:daepiro/cmm/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storge;
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import '../../route/router.dart';
import '../model/request/refresh_token_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/response/login/refresh_token_response.dart';

final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(baseUrl: dotenv.get('BASE_URL'), headers: {
    'Content-Type': 'application/json',
  });

  final Dio dio = Dio(options);
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      maxWidth: 90,
      enabled: kDebugMode));
  dio.interceptors.add(ref.watch(interceptorProvider(dio)));
  return dio;
});

final communityWriteDioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(baseUrl: dotenv.get('BASE_URL'), headers: {
    'Content-Type': 'multipart/form-data',
  });

  final Dio dio = Dio(options);
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      maxWidth: 90,
      enabled: kDebugMode));
  dio.interceptors.add(ref.watch(interceptorProvider(dio)));
  return dio;
});

final interceptorProvider = Provider.family<InterceptorsWrapper, Dio>((ref, dio) {
  final DaepiroLogger _logger = DaepiroLogger.instance;
  const storage = storge.FlutterSecureStorage();

  return InterceptorsWrapper(
    onRequest: (options, handler) async {
      //헤더주입이 필요없는 api
      if ((!options.path.contains("/kakao")) &&
          (!options.path.contains("/naver")) &&
          (!options.path.contains('/apple')) &&
          (!options.path.contains('/business'))) {
        String? accessToken = await storage.read(key: 'accessToken');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
      }
      handler.next(options);
    },
    // 토큰 갱신만을 담당한다
    onError: (DioException exception, handler) async {
      final router = rootNavigatorKey.currentContext != null
          ? GoRouter.of(rootNavigatorKey.currentContext!)
          : null;
      //토큰 갱신 요청 실패시 재시도 하지 않음
      if (exception.requestOptions.path.contains('/v1/auth/refresh')) {
        _logger.d('토큰 갱신 요청 실패시 재시도 하지 않음');
        handler.next(exception);
        return;
      }
      //네트워크 에러 처리
      // 401 → refresh token 시도
      if (exception.response?.statusCode == 401) {
        String? refreshToken = await storage.read(key: 'refreshToken');
        if (refreshToken != null) {
          try {
            final response = await dio.post(
              '${dotenv.get('BASE_URL')}/v1/auth/refresh',
              data: RefreshTokenRequest(refreshToken: refreshToken),
            );
            final refreshTokenResponse = RefreshTokenResponse.fromJson(response.data);
            // token refresh 성공
            if (refreshTokenResponse.code == 1000) {
              final newAccessToken = refreshTokenResponse.data?.accessToken;
              final newRefreshToken = refreshTokenResponse.data?.refreshToken;

              if (newAccessToken != null && newRefreshToken != null) {
                await storage.write(key: 'accessToken', value: newAccessToken);
                await storage.write(key: 'refreshToken', value: newRefreshToken);

                //원래 요청을 재시도
                exception.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                final clonedResponse = await dio.fetch(
                  exception.requestOptions,
                );
                handler.resolve(clonedResponse);
                return;
              } else {
                //refresh 토큰이 존재하지 않거나 만료되었음 로그인 화면으로 이동해야함
                //저장된 토큰 있다면 리셋 잠시만 비활성화
                await storage.delete(key: 'accessToken');
                await storage.delete(key: 'refreshToken');
              }
            }
          } catch (e) {
            _logger.d('토큰 갱신중 에러가 발생', error: e);
          }
        }
        await storage.delete(key: 'accessToken');
        await storage.delete(key: 'refreshToken');
      }
      handler.next(exception);
    },
    onResponse: (options, handler) => handler.next(options),
  );
});
