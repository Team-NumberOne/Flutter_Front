import 'package:daepiro/data/model/request/community_comment_post_request.dart';
import 'package:daepiro/data/model/request/report_request.dart';
import 'package:daepiro/domain/usecase/community/community_disaster_edit_usecase.dart';
import 'package:daepiro/domain/usecase/community/community_disaster_reply_usecase.dart';
import 'package:daepiro/domain/usecase/community/community_reply_like_usecase.dart';
import 'package:daepiro/domain/usecase/community/community_reply_report_usecase.dart';
import 'package:daepiro/presentation/community/state/community_disaster_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/request/community_disaster_edit_request.dart';
import '../../../domain/usecase/community/community_comment_write_usecase.dart';
import '../../../domain/usecase/community/community_disaster_delete_usecase.dart';
import '../../../domain/usecase/community/community_disaster_usecase.dart';

final communityDisasterProvider =
    StateNotifierProvider<CommunityDisasterViewModel, CommunityDisasterState>(
        (ref) {
  return CommunityDisasterViewModel(ref);
});

class CommunityDisasterViewModel extends StateNotifier<CommunityDisasterState> {
  final Ref ref;

  CommunityDisasterViewModel(this.ref) : super(CommunityDisasterState());

  void changeScreenState(bool isdisasterScreen) {
    state = state.copyWith(isDisasterScreen: isdisasterScreen);
  }

  void setStateFromHomeScreen(bool value) {
    state = state.copyWith(fromHome: value);
    if(value == false) {
      state = state.copyWith(isDisasterScreen: false);
    }
  }

  Future<void> getDisasterSituaions() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(
      getCommunityDisasterSituationUseCaseProvider.future,
    );
    final receivedSituations = result.where((el) => el.isReceived!).toList();
    state = state.copyWith(
      allDisasterResponse: result,
      receivedDisasterResponse: receivedSituations,
      isLoading: false,
    );
  }

  Future<void> selectButton(String type) async {
    state = state.copyWith(disasterCommunityType: type);
    await getDisasterSituaions();
  }

  Future<void> getReloadDisasterData() async {
    try {
      await getDisasterSituaions();
    } catch (e) {
      print('재난상황 재로드 오류발생 CommunityDisasterViewModel: $e');
    }
  }

  Future<void> reloadData() async {
    try {
      if (state.selectSituaionId != null)
        await getReplyData(state.selectSituaionId!);
      await getReloadDisasterData();
    } catch (e) {
      print('Error reloading data: $e');
    }
  }

  String parseTitle(String title, String type) {
    if (!title.contains(type)) {
      return title;
    }
    int typeIndex = title.indexOf(type);
    return title.substring(0, typeIndex);
  }

  void setLoadingState(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<void> getReplyData(int situationId) async {
    final result = await ref.read(getCommunityDisasterReplyUseCaseProvider(
            CommunityDisasterReplyUsecase(situationId: situationId))
        .future);
    state = state.copyWith(
      disasterReplyList: result,
      selectSituaionId: situationId,
    );
  }

  Future<void> setComment(String message) async {
    await ref
        .read(communityCommentWriteUseCaseProvider(CommunityCommentWriteUsecase(
            communityCommentPostRequest: CommunityCommentPostRequest(
      body: message,
      articleId: state.selectSituaionId,
    ))).future);
    await reloadData();
  }

  //대댓글 작성
  Future<void> setReplyComment(String message, int parentCommentId) async {
    await ref
        .read(communityCommentWriteUseCaseProvider(CommunityCommentWriteUsecase(
            communityCommentPostRequest: CommunityCommentPostRequest(
      body: message,
      parentCommentId: parentCommentId,
      articleId: state.selectSituaionId,
    ))).future);
    await reloadData();
  }

  void setReortType(String type) {
    state = state.copyWith(reportType: type);
  }

  Future<bool> sendReplyReportContent(int id, String detail, String email) async {
    final response = await ref.read(communityReplyReportUseCaseProvider(
            CommunityReplyReportUseCase(
                id: id,
                communityReplyReportRequest: ReportRequest(
                    detail: detail,
                    type: ReportCategory.getNamedByCategory(state.reportType),
                    email: email)))
        .future);
    if(response.code != 1000) return false;
    return true;
  }

  Future<void> deleteReply(int id) async {
    await ref.read(
        getDisasterDeleteUseCaseProvider(CommunityDisasterDeleteUsecase(id: id))
            .future);
    await reloadData();
  }

  Future<void> editReply(String body) async {
    if (state.isChildCommentState) {
      await ref.read(getCommunityDisasterEditUseCaseProvider(
              CommunityDisasterEditUsecase(
                  id: state.editChildCommentId,
                  communityDisasterEditRequest:
                      CommunityDisasterEditRequest(body: body)))
          .future);
    } else {
      await ref.read(getCommunityDisasterEditUseCaseProvider(
              CommunityDisasterEditUsecase(
                  id: state.editCommentId,
                  communityDisasterEditRequest:
                      CommunityDisasterEditRequest(body: body)))
          .future);
    }
    await reloadData();
  }

  void setEditState(bool value) {
    if (state.isChildCommentState) {
      state = state.copyWith(
        isEditChildCommentState: value,
      );
    } else {
      state = state.copyWith(
        isEditState: value,
      );
    }
  }

  void setReplyId(int commentId) {
    if (state.isChildCommentState) {
      state = state.copyWith(editChildCommentId: commentId);
    } else {
      state = state.copyWith(editCommentId: commentId);
    }
  }

  void setParentCommentId(int parentCommentId) {
    //답글작성할때 필요
    state = state.copyWith(parentCommentId: parentCommentId);
  }

  void clearDisasterReplyData() {
    state = state.copyWith(selectSituaionId: null, disasterReplyList: []);
  }

  Future<void> replyLike(int id) async {
    await ref.read(
        communityReplyLikeUseCaseProvider(CommunityReplyLikeUseCase(id: id))
            .future);
    await reloadData();
  }

  void setSelectSituationId(int situationId) {
    state = state.copyWith(selectSituaionId: situationId);
  }

  void setChildCommentState(bool value) {
    state = state.copyWith(isChildCommentState: value);
  }

  void initDisasterScreenState() {
    state = state.copyWith(
        isChildCommentState: false,
        editChildCommentId: 0,
        isEditChildCommentState: false,
        parentCommentId: 0,
        selectSituaionId: null,
        isEditState: false,
        editCommentId: 0,
    );
  }
}

enum ReportCategory {
  LIE('허위사실 유포'),
  ABUSE('욕설 및 비방'),
  AD('상업적 광고 및 판매'),
  LEWD('음란물 및 불건전한 내용'),
  ETC('기타');

  final String value;

  const ReportCategory(this.value);

  String getCategory() {
    switch (this) {
      case ReportCategory.LIE:
        return '허위사실 유포';
      case ReportCategory.ABUSE:
        return '욕설 및 비방';
      case ReportCategory.AD:
        return '상업적 광고 및 판매';
      case ReportCategory.LEWD:
        return '음란물 및 불건전한 내용';
      default:
        return '기타';
    }
  }

  static String getByValue(String value) {
    return ReportCategory.values
        .firstWhere((el) => el.value == value)
        .getCategory();
  }

  static String getNamedByCategory(String category) {
    return ReportCategory.values
        .firstWhere((el) => el.getCategory() == category)
        .name;
  }
}
