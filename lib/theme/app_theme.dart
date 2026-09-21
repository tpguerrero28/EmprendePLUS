import 'package:flutter/material.dart';

class AppTheme {
  // ==========================================================
  // TOKENS PRIMITIVOS
  // ==========================================================
  // Son los valores base de color que forman la paleta visual.

  static const Color purple700 = Color(0xFF6A1B9A);
  static const Color pink600 = Color(0xFFE91E63);

  static const Color gray50 = Color(0xFFF7F5FA);
  static const Color white = Colors.white;

  static const Color gray900 = Color(0xFF212121);
  static const Color gray700 = Color(0xFF616161);

  static const Color green800 = Color(0xFF2E7D32);
  static const Color red800 = Color(0xFFC62828);

  // ==========================================================
  // TOKENS SEMÁNTICOS
  // ==========================================================
  // Indican para qué se utiliza cada color dentro de la interfaz.

  static const Color primaryColor = purple700;
  static const Color secondaryColor = pink600;

  static const Color backgroundColor = gray50;
  static const Color surfaceColor = white;

  static const Color textPrimaryColor = gray900;
  static const Color textSecondaryColor = gray700;

  static const Color successColor = green800;
  static const Color errorColor = red800;

  static const Color onPrimaryColor = white;
  static const Color onSurfaceColor = gray900;

  // ==========================================================
  // TOKENS DE ESPACIADO
  // ==========================================================

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // ==========================================================
  // TOKENS DE RADIOS
  // ==========================================================

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 18;

  // ==========================================================
  // TOKENS DE TIPOGRAFÍA
  // ==========================================================

  static const double fontSizeSm = 14;
  static const double fontSizeMd = 16;
  static const double fontSizeLg = 18;
  static const double fontSizeXl = 24;
  static const double fontSizeDisplay = 30;

  // ==========================================================
  // TEMA PRINCIPAL
  // ==========================================================

  static ThemeData theme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: backgroundColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
      elevation: 0,
      centerTitle: true,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMd,
        vertical: spacingMd,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: fontSizeMd,
        color: textPrimaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: fontSizeSm,
        color: textSecondaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: fontSizeLg,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: fontSizeXl,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: fontSizeDisplay,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
    ),
  );
}