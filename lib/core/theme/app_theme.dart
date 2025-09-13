import 'package:flutter/material.dart';
import 'package:musicplay/core/theme/app_color.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColor.background,
    
  );
  static final lightTheme = ThemeData.light();
}
