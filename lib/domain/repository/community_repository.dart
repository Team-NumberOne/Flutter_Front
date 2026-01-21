import 'package:daepiro/data/source/community/community_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/http/http_provider.dart';
import '../../data/model/request/community_check_current_location_request.dart';
import '../../data/model/request/community_comment_post_request.dart';
import '../../data/model/request/community_disaster_edit_request.dart';
import '../../data/model/request/set_town_certificate_request.dart';
import '../../data/model/response/basic_response.dart';
import '../../data/model/response/community/community_article_write_response.dart';
import '../../data/model/response/community/community_check_location_response.dart';
import '../../data/model/response/community/community_comment_post_response.dart';
import '../../data/model/response/community/community_disaster_edit_response.dart';
import '../../data/model/response/community/community_dongnae_content_detail_response.dart';
import '../../data/model/response/community/community_dongnae_content_response.dart';
import '../../data/model/response/community/community_reply_like_response.dart';
import '../../data/model/response/community/community_writing_edit_response.dart';
import '../../data/model/response/community/disaster_reply_delete_response.dart';
import '../../data/model/response/community/disaster_reply_response.dart';
import '../../data/model/response/community/disaster_response.dart';
import '../../data/model/response/community/town_certificate_response.dart';
import '../../data/model/request/report_request.dart';
import '../../data/repositoryimpl/community_repository_impl.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final http = ref.watch(dioProvider);
  return CommunityRepositoryImpl(service: CommunityService(http));
});

final communityWritingRepositoryProvider = Provider<CommunityRepository>((ref) {
  final http = ref.watch(communityWriteDioProvider);
  return CommunityRepositoryImpl(service: CommunityService(http));
});

abstract class CommunityRepository {
  Future<List<Disaster>> getDisasterSituation();

  Future<CommunityCommentPostResponse> setComment(
      CommunityCommentPostRequest communityCommentPostRequest);

  Future<List<Reply>> getDisasterReply(int situationId);

  Future<DeleteReplyResponse> deleteReply(int id);

  Future<CommunityDisasterEditResponse> editReply(
      {required int id,
      required CommunityDisasterEditRequest communityDisasterEditRequest});

  Future<CommunityDongnaeContentResponse> getDongNaeContent({
    required String type,
    required String? category,
    required String status,
    required String address,
    required int page,
    required int size,
  });

  Future<CommunityDongNaeDetailContentResponse> getDongNaeDetailContent(
      {required int id});

  Future<CommunityReplyLikeResponse> communityReplyLike({required int id});

  Future<BasicResponse> communityReplyReport(
      {required int id, required ReportRequest communityReplyReportRequest});

  Future<BasicResponse> communityArticleReport(
      {required int id, required ReportRequest communityArticleRequest});

  Future<CommunityArticleWritingResponse> setArticleData({
    required String articleCategory,
    required String title,
    required String body,
    required bool visibility,
    required double longitude,
    required double latitude,
    required String dongne,
    required List<MultipartFile> attachFileList,
  });

  Future<TownCertificateResponse> getTownCertificateInfo();

  Future<CommunityWritingEditResponse> editArticle({
    required int id,
    required String articleType,
    required String articleCategory,
    required bool visibility,
    required String title,
    required String body,
    required List<MultipartFile> attachFileList,
});

  Future<BasicResponse> deleteArticle({required int id});

  Future<BasicResponse> setTownCertificateInfo(
      {required SetTownCertificateRequest setTownCertificateRequest});

  Future<BasicResponse> getArticleLike({required int id});

  Future<CheckShowCurrentLocation> checkShowCurrentLocation({required CommunityCheckCurrentLocationRequest communityCheckCurrentLocationRequest});
}
