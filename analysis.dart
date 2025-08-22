import 'package:flutter/foundation.dart';

/// Flutter analysis options and linting configuration
/// This file helps maintain code quality and consistency across the project

class AnalysisConfig {
  static const String projectName = 'Local Express';
  static const String description = 'On-Demand Delivery App for Vehari City';
  static const String version = '1.0.0+1';

  static void printProjectInfo() {
    if (kDebugMode) {
      print('=== $projectName ===');
      print('Description: $description');
      print('Version: $version');
      print('Environment: ${kDebugMode ? 'Debug' : 'Release'}');
      print('Platform: ${defaultTargetPlatform.name}');
    }
  }
}

/// Development utilities and helpers
class DevUtils {
  static void logInfo(String message) {
    if (kDebugMode) {
      print('[INFO] $message');
    }
  }

  static void logError(String message, [Object? error]) {
    if (kDebugMode) {
      print('[ERROR] $message');
      if (error != null) {
        print('Error details: $error');
      }
    }
  }

  static void logWarning(String message) {
    if (kDebugMode) {
      print('[WARNING] $message');
    }
  }
}
