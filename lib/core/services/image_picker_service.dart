import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract class ImagePickerService {
  Future<File?> pickImage();
}

@Injectable(as: ImagePickerService)
class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  @override
  Future<File?> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final croppedFile = await _cropper.cropImage(
          sourcePath: pickedFile.path,
        );
        if (croppedFile != null) {
          return File(croppedFile.path);
        }
      }
      return null;
    } on PlatformException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
