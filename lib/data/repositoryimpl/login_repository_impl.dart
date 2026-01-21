import 'package:daepiro/data/http/remote_data_source.dart';
import 'package:daepiro/data/model/request/set_fcm_request.dart';
import 'package:daepiro/data/model/request/social_login_request.dart';
import 'package:daepiro/data/model/response/basic_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repository/login_repository.dart';
import '../model/response/login/sociallogin_token_response.dart';
import '../source/login/login_service.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({required LoginService service, required RemoteDataSource remoteDataSource})
      : _service = service,
        _remoteDataSource = remoteDataSource;

  final LoginService _service;
  final RemoteDataSource _remoteDataSource;
  final storage = const FlutterSecureStorage();

  @override
  Future<SocialLoginTokenResponse> getSocialLogin(
      {required String platform, required SocialLoginRequest socialLoginRequest}) {
    return _remoteDataSource.apiCall(() async {
      final tokenResult =
          await _service.getSocialLogin(platform: platform, socialLoginRequest: socialLoginRequest);
      await storage.write(key: 'accessToken', value: tokenResult.data?.accessToken);
      await storage.write(key: 'refreshToken', value: tokenResult.data?.refreshToken);
      return tokenResult;
    });
  }

  @override
  Future<BasicResponse> setFCMToken({required SetFcmRequest setFcmRequest}) {
    return _remoteDataSource.apiCall(() => _service.setFCMToken(setFcmRequest: setFcmRequest));
  }
}
