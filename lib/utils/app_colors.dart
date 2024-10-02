import 'package:flutter/material.dart';

class AppColors {
  static const Color kPrimaryColor = Color(0xFF4CAF50);
  static Color kTabColor = const Color(0xFFF5F5F5);
  static const Color kSecondaryColor = Color(0xFF255FD5);
  static const Color kTransparent = Colors.transparent;

  static const Color kWhiteColor = Color(0xFFFFFFFF);
  static const Color kRedColor = Colors.redAccent;

  // Text
  static const Color kGreyColor = Color(0xFF6B6B6B);
  static const Color kGreyMediumColor = Color(0xFF666666);

  static const Color kBlueTextColor = Color(0xFF222E58);

  static const Color kBlackColor = Color(0xFF2A2A2A);
  static const Color kBlackMediumColor = Color(0xFF303030);
  static const Color kBlackLightColor = Color(0xFF3A3937);
  static const Color kBlackThinColor = Color(0xFF707070);
  static const Color kIconBGColor = Color(0xFF232F58);
}

class AppGradient {
  static LinearGradient linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.kPrimaryColor.withOpacity(0.8),
      AppColors.kSecondaryColor.withOpacity(0.8),
    ],
  );
}
