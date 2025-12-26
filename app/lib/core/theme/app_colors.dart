import 'package:flutter/material.dart';

class AppColors {
  // Private constructor
  AppColors._();

  // ===================
  // DARK THEME COLORS (Principal)
  // ===================
  static const Color darkBackground = Color(0xFF0D0D0D);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceVariant = Color(0xFF252525);
  static const Color darkCard = Color(0xFF1E1E1E);

  // ===================
  // LIGHT THEME COLORS
  // ===================
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEEEEEE);
  static const Color lightCard = Color(0xFFFFFFFF);

  // ===================
  // BRAND COLORS (Premium Gold)
  // ===================
  static const Color primary = Color(0xFFD4AF37); // Gold
  static const Color primaryDark = Color(0xFF8B6914); // Dark Gold
  static const Color secondary = Color(0xFF8B7355); // Bronze
  static const Color accent = Color(0xFFC9A961); // Light Gold
  static const Color tertiary = Color(0xFFB8860B); // Dark Goldenrod

  // Gradient colors
  static const Color gradientStart = Color(0xFFD4AF37);
  static const Color gradientEnd = Color(0xFF8B6914);

  // ===================
  // TEXT COLORS
  // ===================
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);

  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textTertiaryLight = Color(0xFF999999);

  // ===================
  // SEMANTIC COLORS
  // ===================
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color error = Color(0xFFCF6679);
  static const Color errorLight = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF64B5F6);

  // ===================
  // BORDER COLORS
  // ===================
  static const Color borderDark = Color(0xFF333333);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderGold = Color(0xFFD4AF37);

  // ===================
  // OVERLAY COLORS
  // ===================
  static const Color overlay = Color(0x80000000);
  static const Color shimmerBase = Color(0xFF2A2A2A);
  static const Color shimmerHighlight = Color(0xFF3D3D3D);

  // ===================
  // ICON COLORS
  // ===================
  static const Color iconDark = Color(0xFFB3B3B3);
  static const Color iconLight = Color(0xFF666666);
  static const Color iconActive = Color(0xFFD4AF37);

  // ===================
  // GRADIENTS
  // ===================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
  );

  static const LinearGradient goldShimmer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4AF37), Color(0xFFC9A961), Color(0xFFD4AF37)],
  );
}
