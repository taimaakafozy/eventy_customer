// import 'package:flutter/material.dart';
// import 'app_colors.dart';

// class AppTheme {
//   static ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: AppColors.secondary,
//     scaffoldBackgroundColor: AppColors.lightBackGround,
//     cardColor: AppColors.grey,
//     shadowColor: Colors.black12,
//     bottomSheetTheme: BottomSheetThemeData(
//       backgroundColor: AppColors.light,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//     ),
//     fontFamily: 'Cairo',
//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.lightBackGround,
//       foregroundColor: Colors.black,
//       titleTextStyle: TextStyle(
//         fontSize: 23,
//         fontWeight: FontWeight.w600,
//         color:Colors.black,
//       ),

//     ),
//     colorScheme: const ColorScheme.light(
//       primary: AppColors.primary,
//       background: AppColors.light,
//       surface: AppColors.light,
//       onSurface: Colors.black87,
//       secondary: AppColors.primary,

//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         textStyle: const TextStyle(
//           fontSize: 18,
//           color: Colors.white,
//         ),
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: AppColors.cardLight,
//       labelStyle: const TextStyle(color: AppColors.dark),
//       floatingLabelStyle: const TextStyle(
//         color: AppColors.primary,
//         fontWeight: FontWeight.bold,
//       ),
//       prefixIconColor: AppColors.primary,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//     ),
//     textTheme:  TextTheme(
//       bodyMedium: TextStyle(color: AppColors.dark,
//         fontFamily: 'Cairo',
//       ),
//       titleLarge: TextStyle(
//         color: AppColors.dark,
//         fontWeight: FontWeight.w600,
//         fontSize: 22,
//       ),
//     ),
//     iconTheme: IconThemeData(
//       color: AppColors.dark,
//     ),

//   );

//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: AppColors.primary,
//     scaffoldBackgroundColor: AppColors.backGround,
//     cardColor: AppColors.cardDark,
//     shadowColor: Colors.black54,
//     bottomSheetTheme: BottomSheetThemeData(
//       backgroundColor: AppColors.backGround,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//     ),
//     fontFamily: 'Cairo',
//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.backGround,
//       foregroundColor: Colors.white,
//       titleTextStyle: TextStyle(
//         fontSize: 23,
//         fontWeight: FontWeight.w600,
//         color: AppColors.light,
//       ),
//     ),
//     colorScheme: const ColorScheme.dark(
//       primary: AppColors.primary,
//       background: AppColors.backGround,
//       surface: AppColors.backGround,
//       onSurface: AppColors.light,
//       secondary: AppColors.primary,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,

//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         textStyle: const TextStyle(
//           fontSize: 18,
//           color: Colors.white,
//         ),
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: AppColors.cardDark,
//       labelStyle: const TextStyle(color: AppColors.light),
//       floatingLabelStyle: const TextStyle(
//         color: AppColors.primary,
//         fontWeight: FontWeight.bold,
//       ),
//       prefixIconColor: AppColors.primary,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//     ),
//     textTheme:  TextTheme(
//       bodyMedium: TextStyle(color: AppColors.light,
//         fontFamily: 'Cairo',
//       ),
//       titleLarge: TextStyle(
//         color: AppColors.light,
//         fontWeight: FontWeight.w600,
//         fontSize: 22,
//       ),
//     ),
//     iconTheme: IconThemeData(
//       color: AppColors.light,
//     ),

//   );
// }
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    primaryColor: AppColors.primary,

    scaffoldBackgroundColor: AppColors.lightBackground,

    cardColor: AppColors.cardLight,

    shadowColor: Colors.black12,

    fontFamily: 'Cairo',

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
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

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: AppColors.softPurple,

      labelStyle: const TextStyle(
        color: AppColors.darkText,
      ),

      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),

      prefixIconColor: AppColors.primary,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
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

    iconTheme: const IconThemeData(
      color: AppColors.darkText,
    ),
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.lightText,
      centerTitle: true,
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

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),

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

      labelStyle: const TextStyle(
        color: AppColors.lightText,
      ),

      floatingLabelStyle: const TextStyle(
        color: AppColors.secondary,
        fontWeight: FontWeight.bold,
      ),

      prefixIconColor: AppColors.secondary,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.secondary,
          width: 1.5,
        ),
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

    iconTheme: const IconThemeData(
      color: AppColors.lightText,
    ),
  );
}