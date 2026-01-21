import 'dart:io';
import 'package:daepiro/data/model/response/community/community_dongnae_content_detail_response.dart';
import 'package:daepiro/domain/usecase/community/community_article_delete_usecase.dart';
import 'package:daepiro/domain/usecase/community/community_article_edit_usecase.dart';
import 'package:daepiro/domain/usecase/community/community_article_like_usecase.dart';
import 'package:daepiro/domain/usecase/community/community_article_writing_usecase.dart';
import 'package:daepiro/domain/usecase/community/community_check_show_currentlocation_usecase.dart';
import 'package:daepiro/domain/usecase/community/community_dongnae_content_detail_usecase.dart';
import 'package:daepiro/domain/usecase/community/community_dongnae_content_usecase.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/model/request/community_check_current_location_request.dart';
import '../../../data/model/request/community_comment_post_request.dart';
import '../../../data/model/request/community_disaster_edit_request.dart';
import '../../../data/model/response/community/community_dongnae_content_response.dart';
import '../../../data/model/request/report_request.dart';
import '../../../data/model/response/selected_image.dart';
import '../../../domain/usecase/community/community_article_report_usecase.dart';
import '../../../domain/usecase/community/community_comment_write_usecase.dart';
import '../../../domain/usecase/community/community_disaster_delete_usecase.dart';
import '../../../domain/usecase/community/community_disaster_edit_usecase.dart';
import '../../../domain/usecase/community/community_reply_like_usecase.dart';
import '../../../domain/usecase/community/community_reply_report_usecase.dart';
import '../screens/town/gallery_view_screen.dart';
import '../state/community_town_state.dart';
import 'community_disaster_view_model.dart';

final communityTownProvider =
    StateNotifierProvider<CommunityTownViewModel, CommunityTownState>((ref) {
  return CommunityTownViewModel(ref);
});

class CommunityTownViewModel extends StateNotifier<CommunityTownState> {
  final Ref ref;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  var _currentPage = 0;

  CommunityTownViewModel(this.ref) : super(CommunityTownState());

  /// 동네생활 조회할 지역 선택
  Future<void> setUserAddressList() async {
    List<String> addressList = [];
    List<String> longAddressList = [];
    int idx = 0;
    while (true) {
      String address = await storage.read(key: 'shortAddress_$idx') ?? '';
      String longAddress = await storage.read(key: 'fullAddress_$idx') ?? '';
      if (address == '') {
        break;
      } else {
        addressList.add(address);
        longAddressList.add(longAddress);
        idx++;
      }
    }
    state = state.copyWith(
      townList: addressList,
      townLongAddressList: longAddressList,
      selectLongTownAddress: longAddressList[0],
      selectTown: addressList[0],
    );
  }

  Future<void> setSelectAddress(int index) async {
    state = state.copyWith(
        selectTown: state.townList[index],
        selectLongTownAddress: state.townLongAddressList[index],
        contentList: []);
    _currentPage = 0;
    state = state.copyWith(isDongNaeHasMore: true);
    await loadContent();
    return;
  }

  ///동네생활 게시글 리스트
  Future<void> loadContent() async {
    if (!state.isDongNaeHasMore) return;
    state = state.copyWith(isDongNaeLoading: true);
    final newPage = _currentPage + 1;
    final currentList = state.contentList;
    try {
      final result = await ref.read(getCommunityDongNaeUseCaseProvider(
              CommunityDongnaeContentUseCase(
                  category: state.townCategory == '전체'
                      ? null
                      : ContentCategory.getNamedByCategory(state.townCategory),
                  status: 'ACTIVE',
                  address: state.selectLongTownAddress,
                  page: newPage,
                  size: 10))
          .future);
      final lastContent = result.data?.empty ?? false;
      if (lastContent) {
        state = state.copyWith(
          isDongNaeHasMore: false,
          isDongNaeLoading: false,
        );
        return;
      }
      final newContent = result.data?.content ?? [];
      _currentPage = newPage;
      state = state.copyWith(
        contentList: List.from(currentList)..addAll(newContent),
        isDongNaeHasMore: true,
      );
    } catch (e) {
      print('동네생활 viewmodel 에러발생 ${e}');
    } finally {
      state = state.copyWith(isDongNaeLoading: false);
    }
  }

  Future<void> reloadContent() async {
    state = state.copyWith(isDongNaeLoading: true);
    List<Content> updateContentList = [];
    for (int i = 1; i <= _currentPage; i++) {
      final response = await ref.read(getCommunityDongNaeUseCaseProvider(
              CommunityDongnaeContentUseCase(
                  category: state.townCategory == '전체'
                      ? null
                      : ContentCategory.getNamedByCategory(state.townCategory),
                  status: 'ACTIVE',
                  address: state.selectLongTownAddress,
                  page: i,
                  size: 10))
          .future);
      updateContentList.addAll(response.data?.content ?? []);
    }
    state =
        state.copyWith(contentList: updateContentList, isDongNaeLoading: false);
  }

  Future<void> selectButton(String type) async {
    state = state.copyWith(
        isDongNaeLoading: true,
        townCategory: type,
        isDongNaeHasMore: true,
        contentList: []);
    _currentPage = 0;
    await loadContent();
  }

  ///게시글 단건 조회
  //게시글 상세로 이동할때 상태 업데이트
  Future<void> getContentDetail(int id) async {
    final result = await ref.read(
        getCommunityDongNaeContentDetailUseCaseProvider(
                CommunityDongNaeContentDetailUseCase(id: id))
            .future);
    state = state.copyWith(
      contentDetail: result.data!,
      townReplyList: result.data!.comments,
      selectContentId: result.data?.id,
      isDongNaeLoading: false,
    );
  }

  Future<bool> setArticle(String title, String body) async {
    final imageData = await changeMultiPart(false);
    String originalAddress = state.selectLongTownAddress;
    List<String> parts = originalAddress.split(" ");
    String resultAddress = parts.sublist(0, parts.length - 1).join(' ');
    try {
      final result = await ref.read(setCommunityArticleWritingUseCaseProvider(
              CommunityArticleWritingUseCase(
                  articleCategory: ContentCategory.getNamedByCategory(
                      state.writingTownCategory),
                  title: title,
                  body: body,
                  visibility: state.isVisible,
                  longitude: state.longitude,
                  latitude: state.latitude,
                  dongne: resultAddress,
                  attachFileList: imageData))
          .future);
      _currentPage = 0;
      state = state.copyWith(
        contentList: [],
        isDongNaeHasMore: true
      );
      if (result.code != 1000) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print('게시글 작성 오류 발생 $e');
      return false;
    }
  }

  /// 글쓰기
  //글쓰기 타입 지정
  void setCategoryState(String category) {
    state = state.copyWith(writingTownCategory: category);
  }

  void setReplyId(int commentId) {
    if (state.isChildCommentState) {
      state = state.copyWith(editChildCommentId: commentId);
    } else {
      state = state.copyWith(editCommentId: commentId);
    }
  }

  //대댓글 선택 상태 지정
  void setChildCommentState(bool value) {
    state = state.copyWith(isChildCommentState: value);
  }

  void setParentCommentId(int parentCommentId) {
    //답글작성할때 필요
    state = state.copyWith(parentCommentId: parentCommentId);
  }

  //댓글 좋아요
  Future<void> replyLike(int id) async {
    await ref.read(
        communityReplyLikeUseCaseProvider(CommunityReplyLikeUseCase(id: id))
            .future);
    await getContentDetail(state.selectContentId!);
  }

  Future<void> deleteReply(int id) async {
    await ref.read(
        getDisasterDeleteUseCaseProvider(CommunityDisasterDeleteUsecase(id: id))
            .future);
    await getContentDetail(state.selectContentId!);
  }

  //대댓글 작성
  Future<void> setReplyComment(String message, int parentCommentId) async {
    await ref
        .read(communityCommentWriteUseCaseProvider(CommunityCommentWriteUsecase(
            communityCommentPostRequest: CommunityCommentPostRequest(
      body: message,
      parentCommentId: parentCommentId,
      articleId: state.selectContentId,
    ))).future);
    await getContentDetail(state.selectContentId!);
  }

  Future<void> setComment(String message) async {
    await ref
        .read(communityCommentWriteUseCaseProvider(CommunityCommentWriteUsecase(
            communityCommentPostRequest: CommunityCommentPostRequest(
      body: message,
      articleId: state.selectContentId,
    ))).future);
    await getContentDetail(state.selectContentId!);
  }

  Future<List<MultipartFile>> changeMultiPart(bool isEdit) async {
    List<MultipartFile> multipartFiles = [];
    if (isEdit) {
      List<SelectedImage> totalList = [];
      totalList..addAll(state.attachedImages);
      totalList..addAll(state.choiceImages);

      for (var image in totalList) {
        if (image.entity != null) {
          final file = await image.entity!.originFile;
          final multiPartFile = await MultipartFile.fromFile(file!.path,
              filename: file.uri.pathSegments.last);
          multipartFiles.add(multiPartFile);
        } else if (image.file != null) {
          //서버로부터 온 이미지
          final multiPartFile = await MultipartFile.fromFile(image.file!.path,
              filename: image.file!.name);
          multipartFiles.add(multiPartFile);
        }
      }
    } else {
      for (var image in state.choiceImages) {
        if(image.entity != null) {
          final file = await image.entity!.originFile;
          final multiPartFile = await MultipartFile.fromFile(file!.path,
              filename: file.uri.pathSegments.last);
          multipartFiles.add(multiPartFile);
        } else if(image.file != null) {
          final multiPartFile = await MultipartFile.fromFile(image.file!.path,
              filename: image.file!.name);
          multipartFiles.add(multiPartFile);
        }
      }
    }
    return multipartFiles;
  }

  Future<void> setArticleLike() async {
    await ref.read(getArticleLikeUseCaseProvider(
            CommunityArticleLikeUseCase(id: state.selectContentId!))
        .future);
    await getContentDetail(state.selectContentId!);
  }

  //위치 공개 제어
  Future<void> setVisibleState() async {
    bool value = !state.isVisible;
    state = state.copyWith(isVisible: value);
  }

  void initLocationState() {
    state = state.copyWith(longitude: 0.0, latitude: 0.0, isVisible: false);
  }

  Future<bool> getLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      return false;
    }
    return true;
  }

  Future<void> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    state = state.copyWith(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<bool> checkShowCurrentLocation() async {
    await getUserLocation();
    var checkAddress = '';
    List<String> townLongAddressList = state.selectLongTownAddress.trim().split(' ');
    checkAddress = townLongAddressList.sublist(0, townLongAddressList.length-1).join(' ');
    final response = await ref.read(
        communityCheckShowCurrentLocationUseCaseProvider(
            CommunityCheckShowCurrentlocationUsecase(
                communityCheckCurrentLocationRequest:
                    CommunityCheckCurrentLocationRequest(
      address: checkAddress, //TODO 구까지만 보내기로
      longitude: state.longitude,
      latitude: state.latitude,
    ))).future);
    if (response.code != 1000) return false;
    if (response.data == false) {
      state = state.copyWith(longitude: 0.0, latitude: 0.0);
      return false;
    }
    return true;
  }

  /// 신고하기

  //신고하기 유형 선택
  void setReortType(String type) {
    state = state.copyWith(reportType: type);
  }

  //댓글 신고하기 api
  Future<bool> sendReplyReportContent(
      int id, String detail, String email) async {
    final response = await ref.read(communityReplyReportUseCaseProvider(
            CommunityReplyReportUseCase(
                id: id,
                communityReplyReportRequest: ReportRequest(
                    detail: detail,
                    type: ReportCategory.getNamedByCategory(state.reportType),
                    email: email)))
        .future);
    if (response.code != 1000) return false;
    return true;
  }

  //게시글 신고하기
  Future<bool> sendArticleReportContent(
      int id, String detail, String email) async {
    final response = await ref.read(communityArticleReportUseCaseProvider(
            CommunityArticleReportUseCase(
                id: id,
                communityArticleRequest: ReportRequest(
                    detail: detail,
                    type: ReportCategory.getNamedByCategory(state.reportType),
                    email: email)))
        .future);
    if (response.code != 1000) return false;
    return true;
  }

  ///편집하기
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
    await getContentDetail(state.selectContentId!);
  }

  Future<bool> editArticle(String title, String body) async {
    final imageData = await changeMultiPart(true);
    try {
      final result = await ref.read(setCommunityArticleEditUseCaseProvider(
              CommunityArticleEditUseCase(
                  id: state.selectContentId!,
                  articleType: 'DONGNE',
                  articleCategory: ContentCategory.getNamedByCategory(
                      state.writingTownCategory),
                  visibility: state.isVisible,
                  title: title,
                  body: body,
                  attachFileList: imageData))
          .future);
      if (result.code != 1000) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print('게시글 편집 오류 발생 $e');
      return false;
    }
  }

  /// 게시글 삭제
  Future<bool> deleteArticle() async {
    try {
      final result = await ref.read(setCommunityArticleDeleteUseCaseProvider(
              CommunityArticleDeleteUseCase(id: state.selectContentId!))
          .future);
      if (result.code != 1000) {
        return false;
      }
      state = state.copyWith(
          selectContentId: 0,
          isDongNaeLoading: true,
          isDongNaeHasMore: true,
          contentList: []);
      _currentPage = 0;
      await loadContent();
      return true;
    } catch (e) {
      return false;
    }
  }

  void setArticleDeleteState(bool value) {
    state = state.copyWith(deleteArticle: value);
  }

  /// 상태 초기화
  //글쓰기 상태 초기화
  void clearWritingState() {
    ref.read(selectedImagesProvider.notifier).state = [];
    state = state.copyWith(
      isVisible: false,
      writingTownCategory: '',
      choiceImages: [],
      attachedImages: [],
    );
  }

  ///갤러리 사진 선택

  //편집 모드일때 미리 이미지를 세팅하기 위함
  void convertFileToAssetEntity() async {
    final fileUrls = state.contentDetail.files;
    List<SelectedImage> convertResult = [];

    for (String fileUrl in fileUrls) {
      try {
        final response = await http.get(Uri.parse(fileUrl));
        if (response.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/${fileUrl.split('/').last}';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          XFile xfile = XFile(file.path);
          convertResult.add(SelectedImage(entity: null, file: xfile));
        }
      } catch (e) {
        print('파일 다운로드 실패: $e');
      }
    }
    state = state.copyWith(attachedImages: convertResult);
  }

  void setFinalFiles(List<SelectedImage> selectedImages) {
    state = state.copyWith(choiceImages: selectedImages);
  }

  void removeAttahedImages(SelectedImage image) {
    List<SelectedImage> updateList = List.from(state.attachedImages);
    updateList.remove(image);
    state = state.copyWith(attachedImages: updateList);
  }

  //뒤로가기시 게시글 리스트 업데이트
  void needToClearContent() async {
    state = state.copyWith(
      contentDetail: ContentDetail(),
      deleteArticle: false,
      townReplyList: [],
      selectContentId: null,
      writingTownCategory: '',
      parentCommentId: 0,
      isChildCommentState: false,
      editChildCommentId: 0,
      isEditChildCommentState: false,
      isEditState: false,
      editCommentId: 0,
    );
  }
}

enum ContentCategory {
  ALL('ALL'),
  LIFE('LIFE'),
  TRAFFIC('TRAFFIC'),
  SAFE('SAFE'),
  OTHER('OTHER');

  final String value;

  const ContentCategory(this.value);

  String getCategory() {
    switch (this) {
      case ContentCategory.LIFE:
        return '일상';
      case ContentCategory.TRAFFIC:
        return '교통';
      case ContentCategory.SAFE:
        return '치안';
      case ContentCategory.OTHER:
        return '기타';
      default:
        return '전체';
    }
  }

  static String getByValue(String value) {
    return ContentCategory.values
        .firstWhere((el) => el.value == value)
        .getCategory();
  }

  static String getNamedByCategory(String category) {
    return ContentCategory.values
        .firstWhere((el) => el.getCategory() == category)
        .name;
  }
}
