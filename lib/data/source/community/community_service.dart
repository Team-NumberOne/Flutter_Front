import 'dart:convert';

import 'package:daepiro/data/model/request/community_comment_post_request.dart';
import 'package:daepiro/data/model/response/basic_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../model/request/community_check_current_location_request.dart';
import '../../model/request/community_disaster_edit_request.dart';
import '../../model/response/community/community_check_location_response.dart';
import '../../model/response/community/community_writing_edit_response.dart';
import '../../model/request/report_request.dart';
import '../../model/request/set_town_certificate_request.dart';
import '../../model/response/community/community_article_write_response.dart';
import '../../model/response/community/community_comment_post_response.dart';
import '../../model/response/community/community_disaster_edit_response.dart';
import '../../model/response/community/community_dongnae_content_detail_response.dart';
import '../../model/response/community/community_dongnae_content_response.dart';
import '../../model/response/community/community_reply_like_response.dart';
import '../../model/response/community/disaster_reply_delete_response.dart';
import '../../model/response/community/disaster_reply_response.dart';
import '../../model/response/community/disaster_response.dart';
import '../../model/response/community/town_certificate_response.dart';

part 'community_service.g.dart';

@RestApi()
abstract class CommunityService {
  factory CommunityService(Dio dio, {String baseUrl}) = _CommunityService;

  @GET('/v1/disastersituations')
  Future<DisasterResponse> getDisasterResult();

  @GET('/v1/disastersituations/comments/{situationId}')
  Future<DisasterReplyResponse> getDisasterReply(
      {@Path('situationId') required String situationId});

  //댓글 작성
  @POST('/v1/comments')
  Future<CommunityCommentPostResponse> setComment(
      {@Body()
      required CommunityCommentPostRequest communityCommentPostRequest});

  @DELETE('/v1/comments/{id}')
  Future<DeleteReplyResponse> deleteReply({
    @Path('id') required int id,
  });

  @PUT('/v1/comments/{id}')
  Future<CommunityDisasterEditResponse> editReply(
      {@Path('id') required int id,
      @Body()
      required CommunityDisasterEditRequest communityDisasterEditRequest});

  @GET('/v1/articles')
  Future<CommunityDongnaeContentResponse> dongNaeContent({
    @Query('type') required String type,
    @Query('category') required String? category,
    @Query('status') required String status,
    @Query('address') required String address,
    @Query('page') required int page,
    @Query('size') required int size,
  });

  @GET('/v1/articles/{id}')
  Future<CommunityDongNaeDetailContentResponse> dongNaeDetailContent(
      {@Path('id') required int id});

  @PUT('/v1/comments/{id}/like')
  Future<CommunityReplyLikeResponse> communityReplyLike(
      {@Path('id') required int id});

  @PUT('/v1/comments/{id}/report')
  Future<BasicResponse> communityReplyReport(
      {@Path('id') required int id,
      @Body() required ReportRequest communityReplyReportRequest});

  @PUT('/v1/articles/{id}/report')
  Future<BasicResponse> communityArticleReport(
      {@Path('id') required int id,
      @Body() required ReportRequest communityArticleRequest});

  //게시글 좋아요
  @PUT('/v1/articles/{id}/like')
  Future<BasicResponse> getArticleLike({@Path('id') required int id});

  @POST('/v1/articles')
  @MultiPart()
  Future<CommunityArticleWritingResponse> setArticleData({
    @Query('articleType') required String articleType,
    @Query('articleCategory') required String articleCategory,
    @Query('title') required String title,
    @Query('body') required String body,
    @Query('visibility') required bool visibility,
    @Query('longitude') required double longitude,
    @Query('latitude') required double latitude,
    @Query('dongne') required String dongne,
    @Part() required List<MultipartFile> attachFileList,
  });

  @POST('/v1/articles/{id}')
  @MultiPart()
  Future<CommunityWritingEditResponse> editArticle({
    @Path('id') required int id,
    @Query('articleType') required String articleType,
    @Query('articleCategory') required String articleCategory,
    @Query('visibility') required bool visibility,
    @Query('title') required String title,
    @Query('body') required String body,
    @Part() required List<MultipartFile> attachFileList,
  });

  @DELETE('/v1/articles/{id}')
  Future<BasicResponse> deleteArticle({
    @Path('id') required int id,
});

  @GET('/v1/user-address-verified')
  Future<TownCertificateResponse> getTownCertificateInfo();

  @PUT('/v1/user-address-verified')
  Future<BasicResponse> setTownCertificateInfo(
      {@Body() required SetTownCertificateRequest setTownCertificateRequest});

  //현위치 표시 가능 여부 조회
  @POST('/v1/articles/position')
  Future<CheckShowCurrentLocation> checkShowCurrentLocation({@Body() required CommunityCheckCurrentLocationRequest communityCheckCurrentLocationRequest});
}
