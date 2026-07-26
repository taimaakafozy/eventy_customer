import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,

    cardColor: AppColors.grey,

    shadowColor: Colors.black12,

    fontFamily: 'Cairo',

    bottomSheetTheme: const BottomSheetThemeData(
      // backgroundColor: AppColors.cardLight,
      backgroundColor: AppColors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.grey, // نفس لون cardColor — معتم بالكامل
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),

    timePickerTheme: TimePickerThemeData(
  backgroundColor: AppColors.grey,
  hourMinuteColor: AppColors.softPurple,
  dialBackgroundColor: AppColors.softPurple,
  entryModeIconColor: AppColors.primary,
),

datePickerTheme: DatePickerThemeData(
  backgroundColor: AppColors.grey,
  headerBackgroundColor: AppColors.primary,
  headerForegroundColor: Colors.white,
  todayForegroundColor: WidgetStateProperty.all(AppColors.primary),
  dayForegroundColor: WidgetStateProperty.all(AppColors.darkText),
),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.darkText,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
        fontFamily: 'Cairo',
      ),
    ),

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.lightBackground,
      surface: AppColors.cardLight,
      onSurface: AppColors.darkText,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        padding: const EdgeInsets.symmetric(vertical: 14),

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: AppColors.cardLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      labelStyle: TextStyle(
        color: AppColors.darkText.withOpacity(0.5),
        fontWeight: FontWeight.w500,
      ),

      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),

      prefixIconColor: AppColors.primary,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error, width: 1.4),
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: AppColors.darkText,
        fontFamily: 'Cairo',
        fontSize: 15,
      ),

      titleLarge: TextStyle(
        color: AppColors.darkText,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        fontFamily: 'Cairo',
      ),

      titleMedium: TextStyle(
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        fontFamily: 'Cairo',
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.darkText),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    primaryColor: AppColors.primary,

    scaffoldBackgroundColor: AppColors.darkBackground,

    cardColor: AppColors.cardDark,

    shadowColor: Colors.black54,

    fontFamily: 'Cairo',

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    dialogTheme: const DialogThemeData(
  backgroundColor: AppColors.cardDark,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
),

timePickerTheme: TimePickerThemeData(
  backgroundColor: AppColors.cardDark,
  hourMinuteColor: AppColors.primary.withOpacity(.15),
  dialBackgroundColor: AppColors.primary.withOpacity(.1),
  entryModeIconColor: AppColors.secondary,
),

datePickerTheme: DatePickerThemeData(
  backgroundColor: AppColors.cardDark,
  headerBackgroundColor: AppColors.primary,
  headerForegroundColor: Colors.white,
  todayForegroundColor: WidgetStateProperty.all(AppColors.secondary),
  dayForegroundColor: WidgetStateProperty.all(AppColors.lightText),
),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.lightText,
      // centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.lightText,
        fontFamily: 'Cairo',
      ),
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.darkBackground,
      surface: AppColors.cardDark,
      onSurface: AppColors.lightText,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        padding: const EdgeInsets.symmetric(vertical: 14),

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDark,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      labelStyle: const TextStyle(
        color: AppColors.lightText,
        fontWeight: FontWeight.w500,
      ),

      floatingLabelStyle: const TextStyle(
        color: AppColors.secondary,
        fontWeight: FontWeight.w600,
      ),

      prefixIconColor: AppColors.secondary,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.4),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error, width: 1.4),
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: AppColors.lightText,
        fontFamily: 'Cairo',
        fontSize: 15,
      ),

      titleLarge: TextStyle(
        color: AppColors.lightText,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        fontFamily: 'Cairo',
      ),

      titleMedium: TextStyle(
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        fontFamily: 'Cairo',
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.lightText),
  );
}
