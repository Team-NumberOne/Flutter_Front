
import 'package:daepiro/data/model/request/cheer_request.dart';
import 'package:daepiro/data/model/response/basic_response.dart';
import 'package:daepiro/data/model/request/report_request.dart';
import 'package:daepiro/data/model/response/sponsor/cheer_comment_response.dart';
import 'package:daepiro/data/model/response/sponsor/cheer_keyword_response.dart';
import 'package:daepiro/data/model/response/sponsor/sponsor_list_response.dart';
import 'package:daepiro/data/source/sponsor/sponsor_service.dart';
import 'package:daepiro/domain/repository/sponsor_repository.dart';

class SponsorRepositoryImpl extends SponsorRepository {
  SponsorRepositoryImpl({required SponsorService service}) : _service = service;
  final SponsorService _service;

  @override
  Future<SponsorListResponse> getSponsorList() async {
    try {
      final response = await _service.getSponsorList();
      return response;
    } catch(e) {
      print('후원목록 조회 오류 ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<CheerCommentResponse> getCheerCommentList() async {
    try {
      final response = await _service.getCheerCommentList();
      return response;
    } catch(e) {
      print('응원메세지 조회 오류 ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<CheerKeywordResponse> getCheerKeywordList() async {
    try {
      final response = await _service.getCheerKeywordList();
      return response;
    } catch(e) {
      print('응원키워드 조회 오류 ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<BasicResponse> modifyCheer({
    required String content,
    required String id
  }) async {
    try {
      final response = await _service.modifyCheer(
          id: id,
          body : CheerRequest(content: content)
      );
      return response;
    } catch(e) {
      print('응원메세지 수정 오류 ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<BasicResponse> writeCheer({
    required String content
  }) async {
    try {
      final response = await _service.writeCheer(
        body : CheerRequest(content: content)
      );
      return response;
    } catch(e) {
      print('응원메세지 등록 오류 ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<BasicResponse> deleteCheer({
    required String id
  }) async {
    try {
      final response = await _service.deleteCheer(
          id: id
      );
      return response;
    } catch (e) {
      print('응원메세지 삭제 오류 ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<BasicResponse> reportComment({
    required int id,
    required ReportRequest body
  }) async {
    try {
      final response = await _service.cheerCommentReport(
        id: id,
        body: body
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
