import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'FlowMate';
  static const String appVersion = '1.0.0';
  
  // Colors - Soft pastels with calming blues and purples
  static const Color primaryBlue = Color(0xFF6B73FF);
  static const Color lightBlue = Color(0xFFE8EAFF);
  static const Color primaryPurple = Color(0xFF9C88FF);
  static const Color lightPurple = Color(0xFFF0EDFF);
  static const Color softPink = Color(0xFFFFB3BA);
  static const Color lightPink = Color(0xFFFFF0F1);
  static const Color softGreen = Color(0xFF98E4D6);
  static const Color lightGreen = Color(0xFFF0FFFE);
  static const Color softYellow = Color(0xFFFFD93D);
  static const Color lightYellow = Color(0xFFFFFAE6);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFFE9ECEF);
  static const Color darkGray = Color(0xFF6C757D);
  static const Color charcoal = Color(0xFF343A40);
  static const Color black = Color(0xFF000000);
  
  // Semantic Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Font Sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 18.0;
  static const double fontSizeXL = 24.0;
  static const double fontSizeXXL = 32.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Task Priorities
  static const List<String> taskPriorities = ['Low', 'Medium', 'High', 'Urgent'];
  static const List<Color> priorityColors = [
    softGreen,
    softYellow,
    softPink,
    error,
  ];
  
  // Focus Timer Defaults
  static const int defaultWorkDuration = 25; // minutes
  static const int defaultShortBreak = 5; // minutes
  static const int defaultLongBreak = 15; // minutes
  static const int longBreakInterval = 4; // sessions
  
  // Storage Keys
  static const String keyTasks = 'tasks';
  static const String keyEvents = 'events';
  static const String keyNotes = 'notes';
  static const String keyFocusSessions = 'focus_sessions';
  static const String keyThemeMode = 'theme_mode';
  static const String keyFirstLaunch = 'first_launch';
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: AppConstants.fontSizeXXL,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: AppConstants.fontSizeXL,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: AppConstants.fontSizeL,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: AppConstants.fontSizeM,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppConstants.fontSizeS,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: AppConstants.fontSizeXS,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
  );
  
  static const TextStyle button = TextStyle(
    fontSize: AppConstants.fontSizeM,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: AppConstants.fontSizeXS,
    fontWeight: FontWeight.w500,
    fontFamily: 'Inter',
  );
}

