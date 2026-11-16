import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Brand ─────────────────────────────────────────────
  static const Color primary = Color(0xFFFF7176);
  static const Color primarylight = Color(0xFFF6C4C4);
  static const Color primarydark = Color(0xFFF4A0A4);
  static const Color secondary = Color(0xFF282828);
  static const Color accent = Color(0xFF89A7FF);

  // ─── Status ────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ─── Light Theme ───────────────────────────────────────
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF9FAFB);
  static const Color lightSurfaceVariant = Color(0xFFF1F3F5);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightDivider = Color(0xFFEEEEEE);

  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextDisabled = Color(0xFF9CA3AF);
  static const Color lightTextInverse = Color(0xFFFFFFFF);

  // ─── Dark Theme ────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkSurface = Color(0xFF1A1D23);
  static const Color darkSurfaceVariant = Color(0xFF23272F);
  static const Color darkBorder = Color(0xFF2E333B);
  static const Color darkDivider = Color(0xFF2A2E36);

  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFFB0B7C3);
  static const Color darkTextDisabled = Color(0xFF6B7280);
  static const Color darkTextInverse = Color(0xFF111827);

  // ─── Gaming & Casino Accents ─────────────────────────
  static const Color gold = Color(0xFFFFB800);
  static const Color goldLight = Color(0xFFFFE082);
  static const Color neonGreen = Color(0xFF00E676);
  static const Color emeraldGreen = Color(0xFF00B67A);
  static const Color emeraldGreenDark = Color(0xFF008C5D);
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonPurple = Color(0xFF9D4EDD);
  static const Color aviatorRed = Color(0xFFFF2A4B);
  static const Color aviatorGlow = Color(0x33FF2A4B);
  static const Color cardDark = Color(0xFF161922);
  static const Color cardBorder = Color(0xFF252A36);

  // ─── Gradients ──────────────────────────────────────────
  static const Gradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF9100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient aviatorGradient = LinearGradient(
    colors: [Color(0xFFFF2A4B), Color(0xFFFF7176)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient cardGradientDark = LinearGradient(
    colors: [Color(0xFF1E222D), Color(0xFF151821)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient cardGradientGlass = LinearGradient(
    colors: [Color(0x22FFFFFF), Color(0x0AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Neutral ───────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // ─── Gradient Light Theme ──────────────────────────────────────────
  static const Gradient primaryLightGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [primarydark, primarylight],
  );

  // ─── Gradient Dark Theme ──────────────────────────────────────────
  static const Gradient primaryDarkGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [lightTextPrimary, lightTextSecondary],
  );

  // ─── Theme-aware helpers ───────────────────────────────
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color background(BuildContext context) =>
      isDark(context) ? darkBackground : lightBackground;

  static Color surface(BuildContext context) =>
      isDark(context) ? darkSurface : lightSurface;

  static Color surfaceVariant(BuildContext context) =>
      isDark(context) ? darkSurfaceVariant : lightSurfaceVariant;

  static Color border(BuildContext context) =>
      isDark(context) ? darkBorder : lightBorder;

  static Color divider(BuildContext context) =>
      isDark(context) ? darkDivider : lightDivider;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? darkTextSecondary : lightTextSecondary;

  static Color textDisabled(BuildContext context) =>
      isDark(context) ? darkTextDisabled : lightTextDisabled;

  static Color textInverse(BuildContext context) =>
      isDark(context) ? darkTextInverse : lightTextInverse;
}
