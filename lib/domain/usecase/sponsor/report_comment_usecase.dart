import 'package:daepiro/data/model/response/basic_response.dart';
import 'package:daepiro/domain/repository/sponsor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/request/report_request.dart';

final reportCommentUsecaseProvider = FutureProvider
    .family<BasicResponse, ReportCommentUsecase>((ref, request) async {
  final repository = ref.watch(sponsorRepositoryProvider);
  return await repository.reportComment(
    id: request.id,
    body: request.body
  );
});

class ReportCommentUsecase {
  final int id;
  final ReportRequest body;

  ReportCommentUsecase({
    required this.id,
    required this.body,
  });
}
