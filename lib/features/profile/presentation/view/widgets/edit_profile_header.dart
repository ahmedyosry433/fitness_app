import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';

class EditProfileHeader extends StatelessWidget {
  final File? selectedImage;
  final String? photoUrl;
  final String? name;
  final VoidCallback onPickImage;

  const EditProfileHeader({
    super.key,
    required this.selectedImage,
    required this.photoUrl,
    required this.name,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPickImage,
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: selectedImage != null
                        ? FileImage(selectedImage!) as ImageProvider
                        : (photoUrl != null && photoUrl!.isNotEmpty
                            ? NetworkImage(photoUrl!) as ImageProvider
                            : const AssetImage(AppImages.imagesIcLauncher)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.black0C,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryOrange,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.primaryOrange,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(name ?? '', style: 18.bold.copyWith(color: AppColors.whiteFF)),
      ],
    );
  }
}
