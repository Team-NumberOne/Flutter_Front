import 'package:daepiro/data/model/response/basic_response.dart';
import 'package:daepiro/data/model/response/sponsor/cheer_comment_response.dart';
import 'package:daepiro/data/model/response/sponsor/cheer_keyword_response.dart';
import 'package:daepiro/data/model/response/sponsor/sponsor_list_response.dart';
import 'package:daepiro/data/source/sponsor/sponsor_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/http/http_provider.dart';
import '../../data/model/request/report_request.dart';
import '../../data/repositoryimpl/sponsor_repository_impl.dart';

final sponsorRepositoryProvider = Provider<SponsorRepository>((ref) {
  final http = ref.watch(dioProvider);
  return SponsorRepositoryImpl(service: SponsorService(http));
});

abstract class SponsorRepository {
  Future<SponsorListResponse> getSponsorList();
  Future<CheerCommentResponse> getCheerCommentList();
  Future<CheerKeywordResponse> getCheerKeywordList();
  Future<BasicResponse> writeCheer({required String content});
  Future<BasicResponse> modifyCheer({required String content, required String id});
  Future<BasicResponse> deleteCheer({required String id});

  Future<BasicResponse> reportComment({required int id, required ReportRequest body});
}
