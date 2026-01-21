import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/response/basic_response.dart';
import '../../../data/model/request/report_request.dart';
import '../../repository/community_repository.dart';

final communityArticleReportUseCaseProvider = FutureProvider.family<
    BasicResponse,
    CommunityArticleReportUseCase>((ref, request) async {
  final repository = ref.watch(communityRepositoryProvider);
  return await repository.communityArticleReport(
      id: request.id,
      communityArticleRequest: request.communityArticleRequest);
});

class CommunityArticleReportUseCase {
  final int id;
  final ReportRequest communityArticleRequest;

  CommunityArticleReportUseCase(
      {required this.id, required this.communityArticleRequest});
}