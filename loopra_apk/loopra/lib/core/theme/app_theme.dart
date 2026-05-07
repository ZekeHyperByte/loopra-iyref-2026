import 'package:flutter/material.dart';

class AppColors {
  // Primary backgrounds
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color backgroundLight = Color(0xFFF5F5F0);
  static const Color cardDark = Color(0xFF111111);
  static const Color cardLight = Color(0xFFF0F0EC);

  // Green shades
  static const Color greenCard = Color(0xFF1A2F24);
  static const Color greenDeep = Color(0xFF1A3D2A);
  static const Color greenPrimary = Color(0xFF1B5E2F);
  static const Color greenLight = Color(0xFF2D8A4E);

  // Accent
  static const Color lime = Color(0xFF4ADE80);
  static const Color limeDark = Color(0xFF0F3D22);

  // Text
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF9CA3AF);
  static const Color darkText = Color(0xFF111111);

  // Status
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFACC15);

  // Gradients
  static const LinearGradient walletGradient = LinearGradient(
    colors: [Color(0xFF0F3D22), Color(0xFF0F3D22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient limeGradient = LinearGradient(
    colors: [lime, greenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static const String _fontFamily = 'PlusJakartaSans';

  static TextStyle _textStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.lime,
      fontFamily: _fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lime,
        secondary: AppColors.greenLight,
        surface: AppColors.cardDark,
        error: AppColors.danger,
        onPrimary: AppColors.limeDark,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onError: AppColors.white,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.backgroundDark,
        titleTextStyle: _textStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.white),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.cardDark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF111111),
        selectedItemColor: AppColors.lime,
        unselectedItemColor: AppColors.muted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lime,
        foregroundColor: AppColors.limeDark,
      ),
      textTheme: TextTheme(
        displayLarge: _textStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.white),
        displayMedium: _textStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white),
        titleLarge: _textStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.white),
        titleMedium: _textStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white),
        bodyLarge: _textStyle(fontSize: 16, color: AppColors.white),
        bodyMedium: _textStyle(fontSize: 14, color: AppColors.muted),
        labelLarge: _textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.lime),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.limeDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: _textStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.limeDark),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.lime),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  static ThemeData get lightTheme {
    return darkTheme.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.backgroundLight,
        titleTextStyle: _textStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkText),
        iconTheme: const IconThemeData(color: AppColors.darkText),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.lime,
        unselectedItemColor: AppColors.muted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.cardLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.lime),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }
}
