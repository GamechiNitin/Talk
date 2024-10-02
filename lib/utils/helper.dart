import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_colors.dart';

class Helper {
  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // I am connected to a wifi network.
      return true;
    } else {
      return false;
    }
  }

  static void toast(BuildContext context, String message, {bool? success}) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          duration: const Duration(milliseconds: 1200),
          dismissDirection: DismissDirection.up,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          content: Text(message),
          backgroundColor: success == true ? Colors.lightGreen : Colors.red,
        ),
      );

  static Widget progress() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.kPrimaryColor,
      ),
    );
  }
}

extension DateTimeFormat on DateTime {
  String chatTimestamp() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return DateFormat('MMM dd, yyyy').format(this);
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

extension ImageFileExtension on String {
  bool get isImageFormat {
    final imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'tiff',
      'webp',
    ];

    final extension = split('.').last.toLowerCase();

    return imageExtensions.contains(extension);
  }
}
