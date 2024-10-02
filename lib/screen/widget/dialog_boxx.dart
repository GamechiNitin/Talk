import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/core/data/common/user_model.dart';
import 'package:talk/screen/widget/image_widget.dart';
import 'package:talk/utils/app_colors.dart';

class DialogBoxx {
  static void profileView(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Profile View",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.kSecondaryColor,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => GoRouter.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: ImageWidget(image: user.photoURL!, borderRadius: 10),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kSecondaryColor,
                    ),
                  ),
                  subtitle: Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kBlackMediumColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
