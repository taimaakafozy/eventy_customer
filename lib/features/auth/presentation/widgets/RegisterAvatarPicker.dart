import 'dart:io';

import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Circular avatar picker.
/// Shows placeholder when no image selected, actual image when picked.
class RegisterAvatarPicker extends StatelessWidget {
  final File? pickedImage;
  final VoidCallback onTap;

  const RegisterAvatarPicker({
    super.key,
    required this.pickedImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // ── Avatar circle ────────────────────────────────────────────────
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softPurple,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.25),
                width: 2.5,
              ),
              image: pickedImage != null
                  ? DecorationImage(
                      image: FileImage(pickedImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: pickedImage == null
                ? Icon(
                    Icons.person_rounded,
                    size: 44,
                    color: AppColors.primary.withOpacity(0.4),
                  )
                : null,
          ),

          // ── Camera badge ─────────────────────────────────────────────────
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              size: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}