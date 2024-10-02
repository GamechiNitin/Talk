import 'package:flutter/material.dart';
import 'package:talk/utils/app_colors.dart';
import 'package:talk/utils/app_dimens.dart';
import 'package:talk/utils/helper.dart';

import 'image_widget.dart';

class ChatBubbleWidget extends StatelessWidget {
  const ChatBubbleWidget({
    super.key,
    required this.currentUser,
    required this.name,
    this.image,
    this.time,
    required this.message,
    this.type,
    this.onTap,
  });
  final bool currentUser;
  final String name;
  final String message;
  final String? image;
  final String? type;
  final String? time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (currentUser) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.only(left: kToolbarHeight, bottom: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.p16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.3),
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppDimens.p8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (image != null &&
                      image != '' &&
                      (type != null && type!.isImageFormat))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ImageWidget(
                        image: "$image",
                        borderRadius: 10,
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  if (image != null &&
                      image != '' &&
                      (type != null && !type!.isImageFormat))
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.kBlueTextColor,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.file_copy,
                            size: 16,
                            color: AppColors.kWhiteColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Tap to view! $type",
                            style: const TextStyle(
                              color: AppColors.kWhiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  if (message != '')
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.kBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            if (time != null)
              Text(
                time!,
                style: const TextStyle(
                  fontSize: 8,
                  color: AppColors.kBlackLightColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.only(right: kToolbarHeight, bottom: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.p16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.kSecondaryColor.withOpacity(0.9),
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppDimens.p8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (image != null &&
                      image != '' &&
                      (type != null && type!.isImageFormat))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ImageWidget(
                        image: "$image",
                        borderRadius: 10,
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  if (image != null &&
                      image != '' &&
                      (type != null && !type!.isImageFormat))
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.kBlueTextColor,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.file_copy,
                            size: 16,
                            color: AppColors.kWhiteColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Tap to view! $type",
                            style: const TextStyle(
                              color: AppColors.kWhiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  if (message != '')
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.kWhiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            if (time != null)
              Text(
                time!,
                style: const TextStyle(
                  fontSize: 8,
                  color: AppColors.kBlackLightColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      );
    }
  }
}
