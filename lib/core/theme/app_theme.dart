import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.secondary,
    scaffoldBackgroundColor: AppColors.lightBackGround,
    cardColor: AppColors.grey,
    shadowColor: Colors.black12,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackGround,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w600,
        color:Colors.black,
      ),

    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      background: AppColors.light,
      surface: AppColors.light,
      onSurface: Colors.black87,
      secondary: AppColors.primary,

    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardLight,
      labelStyle: const TextStyle(color: AppColors.dark),
      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
      prefixIconColor: AppColors.primary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme:  TextTheme(
      bodyMedium: TextStyle(color: AppColors.dark,
        fontFamily: 'Cairo',
      ),
      titleLarge: TextStyle(
        color: AppColors.dark,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
    ),
    iconTheme: IconThemeData(
      color: AppColors.dark,
    ),

  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backGround,
    cardColor: AppColors.cardDark,
    shadowColor: Colors.black54,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.backGround,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backGround,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w600,
        color: AppColors.light,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      background: AppColors.backGround,
      surface: AppColors.backGround,
      onSurface: AppColors.light,
      secondary: AppColors.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDark,
      labelStyle: const TextStyle(color: AppColors.light),
      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
      prefixIconColor: AppColors.primary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme:  TextTheme(
      bodyMedium: TextStyle(color: AppColors.light,
        fontFamily: 'Cairo',
      ),
      titleLarge: TextStyle(
        color: AppColors.light,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
    ),
    iconTheme: IconThemeData(
      color: AppColors.light,
    ),

  );
}
