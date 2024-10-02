import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FlutterFireConfig {
  final FirebaseOptions _optionsA = FirebaseOptions(
    apiKey: dotenv.env["ANDROID_KEY"] ?? '',
    appId: dotenv.env["ANDROID_AAP_ID"] ?? '',
    messagingSenderId: dotenv.env["ANDROID_MSI"] ?? '',
    projectId: dotenv.env["ANDROID_PROJECT_ID"] ?? '',
  );
  final FirebaseOptions _optionsI = FirebaseOptions(
    apiKey: dotenv.env["IOS_KEY"] ?? '',
    appId: dotenv.env["IOS_AAP_ID"] ?? '',
    messagingSenderId: dotenv.env["IOS_MSI"] ?? '',
    projectId: dotenv.env["IOS_PROJECT_ID"] ?? '',
  );

  // Default android
  FirebaseOptions config() => Platform.isIOS ? _optionsI : _optionsA;
}