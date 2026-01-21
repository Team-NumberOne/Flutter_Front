import 'package:daepiro/data/model/response/basic_response.dart';
import 'package:daepiro/domain/repository/community_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/request/report_request.dart';

final communityReplyReportUseCaseProvider = FutureProvider.family<
    BasicResponse,
    CommunityReplyReportUseCase>((ref, request) async {
  final repository = ref.watch(communityRepositoryProvider);
  return await repository.communityReplyReport(
      id: request.id,
      communityReplyReportRequest: request.communityReplyReportRequest);
});

class CommunityReplyReportUseCase {
  final int id;
  final ReportRequest communityReplyReportRequest;

  CommunityReplyReportUseCase(
      {required this.id, required this.communityReplyReportRequest});
}
