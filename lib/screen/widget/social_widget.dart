import 'package:flutter/material.dart';
import 'package:talk/utils/app_colors.dart';

class SocialButtonWidget extends StatelessWidget {
  const SocialButtonWidget({
    super.key,
    required this.label,
    required this.assetsPath,
    this.onTap,
  });
  final String label, assetsPath;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          color: AppColors.kWhiteColor,
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              offset: Offset(6, 6),
              spreadRadius: 1,
              blurRadius: 4,
            ),
            BoxShadow(
              color: AppColors.kSecondaryColor.withOpacity(0.1),
              offset: const Offset(-6, -6),
              spreadRadius: 1,
              blurRadius: 4,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assetsPath,
              height: 30,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
