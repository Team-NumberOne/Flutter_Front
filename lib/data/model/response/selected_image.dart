import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectedImage {
  AssetEntity? entity;
  XFile? file;

  SelectedImage({
    required this.entity,
    required this.file,
  });
}