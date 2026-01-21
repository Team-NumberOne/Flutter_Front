import 'package:daepiro/data/model/request/cheer_request.dart';
import 'package:daepiro/data/model/response/basic_response.dart';
import 'package:daepiro/data/model/response/sponsor/cheer_comment_response.dart';
import 'package:daepiro/data/model/response/sponsor/cheer_keyword_response.dart';
import 'package:daepiro/data/model/response/sponsor/sponsor_list_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../model/request/report_request.dart';
part 'sponsor_service.g.dart';

@RestApi()
abstract class SponsorService {
  factory SponsorService(Dio dio, {String baseUrl}) = _SponsorService;

  // 후원목록 조회
  @GET('/v1/sponsors/articles')
  Future<SponsorListResponse> getSponsorList();

  // 응원 메세지 목록 조회
  @GET('/v1/sponsors/cheering')
  Future<CheerCommentResponse> getCheerCommentList();

  // 홈 - 응원 메세지 키워드 조회
  @GET('/v1/sponsors/messages')
  Future<CheerKeywordResponse> getCheerKeywordList();

  // 응원메세지 등록
  @POST('/v1/sponsors/cheering')
  Future<BasicResponse> writeCheer({
    @Body() required CheerRequest body
  });

  // 응원메세지 수정
  @PUT('/v1/sponsors/cheering/{id}')
  Future<BasicResponse> modifyCheer({
    @Path("id") required String id,
    @Body() required CheerRequest body
  });

  // 응원메세지 삭제
  @DELETE('/v1/sponsors/cheering/{id}')
  Future<BasicResponse> deleteCheer({
    @Path("id") required String id,
  });

  // 응원메시지 신고
  @PUT('/v1/sponsors/cheering/{id}/report')
  Future<BasicResponse> cheerCommentReport({
    @Path('id') required int id,
    @Body() required ReportRequest body
  });

}
