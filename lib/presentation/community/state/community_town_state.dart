import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/model/response/community/community_dongnae_content_detail_response.dart';
import '../../../data/model/response/community/community_dongnae_content_response.dart';
import '../../../data/model/response/selected_image.dart';

part 'community_town_state.freezed.dart';

@freezed
sealed class CommunityTownState with _$CommunityTownState {
  factory CommunityTownState({

    //동네생활 게시글 상세조회
    @Default(ContentDetail()) ContentDetail contentDetail,

    //게시글 삭제상태
    @Default(false) bool deleteArticle,

    //동네생활 댓글 상태
    @Default([]) List<CommentData> townReplyList,
    @Default(null) int? selectContentId,
    //동네생활 컨텐츠 리스트
    @Default([]) List<Content> contentList,
    //동네생활 로딩 상태
    @Default(true) bool isDongNaeLoading,
    //동네생활 컨텐츠 더있는가
    @Default(true) bool isDongNaeHasMore,

    //동네생활 선택한 동네
    @Default('') String selectTown,
    @Default('') String selectLongTownAddress,
    @Default([]) List<String> townLongAddressList,
    @Default([]) List<String> townList,

    //동네생활 선택 카테고리
    @Default('전체') String townCategory,

    //동네생활 글쓰기 선택 카테고리
    @Default('') String writingTownCategory,

    //대댓글 작성시 필요한 부모 댓글 id
    @Default(0) int parentCommentId,

    //대댓글을 선택한지에 대한 여부
    @Default(false) isChildCommentState,
    @Default(0) int editChildCommentId,
    @Default(false) bool isEditChildCommentState,


    //댓글 수정을 위한 상태 데이터
    @Default(false) bool isEditState,
    @Default(0) int editCommentId,

    //신고하기
    @Default('') String reportType,

    //위치 공개 여부 변수
    @Default(false) bool isVisible,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,

    //사진 선택에 대한 상태
    @Default([]) List<SelectedImage> attachedImages,
    @Default([]) List<SelectedImage> choiceImages,


  }) = _CommunityTownState;
}
