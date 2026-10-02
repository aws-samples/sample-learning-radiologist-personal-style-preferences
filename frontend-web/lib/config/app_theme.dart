import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme configuration — Deep Navy + Clinical Teal identity
class AppTheme {
  AppTheme._();

  // ── Brand palette ──────────────────────────────────────────────
  static const Color navy = Color(0xFF1B2A4A);
  static const Color teal = Color(0xFF00897B);
  static const Color amber = Color(0xFFF5A623);

  // ── Color schemes ──────────────────────────────────────────────

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary – navy
    primary: navy,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFD6E3F8),
    onPrimaryContainer: Color(0xFF0D1B33),
    // Secondary – teal
    secondary: teal,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFB2DFDB),
    onSecondaryContainer: Color(0xFF00332E),
    // Tertiary – amber
    tertiary: amber,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFF0D4),
    onTertiaryContainer: Color(0xFF4A2800),
    // Error
    error: Color(0xFFC62828),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD4),
    onErrorContainer: Color(0xFF410002),
    // Surface
    surface: Color(0xFFF8F9FC),
    onSurface: Color(0xFF1B1C1F),
    onSurfaceVariant: Color(0xFF44474E),
    // Outline
    outline: Color(0xFF74777F),
    outlineVariant: Color(0xFFC4C6CF),
    // Misc
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF2F3033),
    onInverseSurface: Color(0xFFF1F0F4),
    inversePrimary: Color(0xFFAAC7FF),
    surfaceContainerHighest: Color(0xFFE2E2E6),
    surfaceContainerHigh: Color(0xFFE8E7EB),
    surfaceContainer: Color(0xFFEDECF0),
    surfaceContainerLow: Color(0xFFF3F3F6),
    surfaceContainerLowest: Colors.white,
    surfaceTint: navy,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary
    primary: Color(0xFFAAC7FF),
    onPrimary: Color(0xFF0D1B33),
    primaryContainer: Color(0xFF2A3F63),
    onPrimaryContainer: Color(0xFFD6E3F8),
    // Secondary
    secondary: Color(0xFF80CBC4),
    onSecondary: Color(0xFF00332E),
    secondaryContainer: Color(0xFF005B52),
    onSecondaryContainer: Color(0xFFB2DFDB),
    // Tertiary
    tertiary: Color(0xFFFFCC80),
    onTertiary: Color(0xFF4A2800),
    tertiaryContainer: Color(0xFF6B3E00),
    onTertiaryContainer: Color(0xFFFFF0D4),
    // Error
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD4),
    // Surface
    surface: Color(0xFF121316),
    onSurface: Color(0xFFE3E2E6),
    onSurfaceVariant: Color(0xFFC4C6CF),
    // Outline
    outline: Color(0xFF8E9099),
    outlineVariant: Color(0xFF44474E),
    // Misc
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE3E2E6),
    onInverseSurface: Color(0xFF2F3033),
    inversePrimary: navy,
    surfaceContainerHighest: Color(0xFF333538),
    surfaceContainerHigh: Color(0xFF292A2D),
    surfaceContainer: Color(0xFF1E1F23),
    surfaceContainerLow: Color(0xFF1B1C1F),
    surfaceContainerLowest: Color(0xFF0D0E11),
    surfaceTint: Color(0xFFAAC7FF),
  );

  // ── Theme extensions ───────────────────────────────────────────

  static const lightCategoryColors = CategoryColorsTheme(
    terminology: Color(0xFF5C8DB8),
    formatting: Color(0xFF4DB6A0),
    detailLevel: Color(0xFFE8913A),
    phrasing: Color(0xFF8E6BAD),
    priority: Color(0xFFC45C5C),
    defaultColor: Color(0xFF8A8F99),
  );

  static const darkCategoryColors = CategoryColorsTheme(
    terminology: Color(0xFF7EADD4),
    formatting: Color(0xFF6DD4BE),
    detailLevel: Color(0xFFEDAA5E),
    phrasing: Color(0xFFAB8CC8),
    priority: Color(0xFFD67E7E),
    defaultColor: Color(0xFFA0A5AF),
  );

  static const lightRiskColors = RiskColorsTheme(
    high: Color(0xFFC62828),
    medium: Color(0xFFE8913A),
    low: Color(0xFFF5D55A),
    defaultColor: Color(0xFF8A8F99),
  );

  static const darkRiskColors = RiskColorsTheme(
    high: Color(0xFFEF5350),
    medium: Color(0xFFEDAA5E),
    low: Color(0xFFF5DE7A),
    defaultColor: Color(0xFFA0A5AF),
  );

  static final lightClinicalText = ClinicalTextTheme(
    bodyStyle: GoogleFonts.sourceSerif4(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: const Color(0xFF1B1C1F),
    ),
    editorStyle: GoogleFonts.sourceSerif4(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: const Color(0xFF1B1C1F),
    ),
  );

  static final darkClinicalText = ClinicalTextTheme(
    bodyStyle: GoogleFonts.sourceSerif4(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: const Color(0xFFE3E2E6),
    ),
    editorStyle: GoogleFonts.sourceSerif4(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: const Color(0xFFE3E2E6),
    ),
  );

  // ── Shared section header decoration ──────────────────────────

  static BoxDecoration sectionHeaderDecoration(ColorScheme cs) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          cs.primaryContainer,
          cs.primaryContainer.withValues(alpha: 0.7),
          cs.primary.withValues(alpha: 0.15),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    );
  }

  // ── Public API ─────────────────────────────────────────────────

  static ThemeData get lightTheme => _buildTheme(_lightScheme);
  static ThemeData get darkTheme => _buildTheme(_darkScheme);

  // ── Shared builder ─────────────────────────────────────────────

  static ThemeData _buildTheme(ColorScheme cs) {
    final textTheme = _buildTextTheme(cs);
    final isLight = cs.brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      textTheme: textTheme,
      appBarTheme: _buildAppBarTheme(cs),
      cardTheme: _buildCardTheme(cs),
      inputDecorationTheme: _buildInputTheme(cs),
      filledButtonTheme: _buildFilledButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      chipTheme: _buildChipTheme(),
      navigationRailTheme: _buildNavRailTheme(cs),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      extensions: [
        isLight ? lightCategoryColors : darkCategoryColors,
        isLight ? lightRiskColors : darkRiskColors,
        isLight ? lightClinicalText : darkClinicalText,
      ],
    );
  }

  // ── Text theme (Inter) ─────────────────────────────────────────

  static TextTheme _buildTextTheme(ColorScheme cs) {
    return GoogleFonts.interTextTheme(
      const TextTheme(),
    ).copyWith(
      displayLarge: GoogleFonts.inter(fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.inter(fontWeight: FontWeight.w700),
      displaySmall: GoogleFonts.inter(fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.inter(fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.inter(fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w500),
      labelMedium: GoogleFonts.inter(fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.inter(fontWeight: FontWeight.w500),
    );
  }

  // ── Component themes ───────────────────────────────────────────

  static AppBarTheme _buildAppBarTheme(ColorScheme cs) {
    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
    );
  }

  static CardThemeData _buildCardTheme(ColorScheme cs) {
    return CardThemeData(
      elevation: 1,
      shadowColor: cs.shadow.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
    );
  }

  static InputDecorationTheme _buildInputTheme(ColorScheme cs) {
    return InputDecorationTheme(
      filled: true,
      fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: cs.error),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  static NavigationRailThemeData _buildNavRailTheme(ColorScheme cs) {
    final isLight = cs.brightness == Brightness.light;

    return NavigationRailThemeData(
      elevation: 0,
      backgroundColor: isLight ? navy : cs.surfaceContainerLow,
      indicatorColor: teal.withValues(alpha: 0.85),
      selectedIconTheme: const IconThemeData(
        color: Colors.white,
        size: 26,
      ),
      unselectedIconTheme: IconThemeData(
        color: isLight
            ? Colors.white.withValues(alpha: 0.65)
            : cs.onSurfaceVariant,
        size: 26,
      ),
      selectedLabelTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: GoogleFonts.inter(
        color: isLight
            ? Colors.white.withValues(alpha: 0.65)
            : cs.onSurfaceVariant,
        fontSize: 12,
      ),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  static ChipThemeData _buildChipTheme() {
    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

/// Theme-aware category colors for preferences
class CategoryColorsTheme extends ThemeExtension<CategoryColorsTheme> {
  const CategoryColorsTheme({
    required this.terminology,
    required this.formatting,
    required this.detailLevel,
    required this.phrasing,
    required this.priority,
    required this.defaultColor,
  });

  final Color terminology;
  final Color formatting;
  final Color detailLevel;
  final Color phrasing;
  final Color priority;
  final Color defaultColor;

  Color getColor(String? category) {
    switch (category) {
      case 'terminology':
        return terminology;
      case 'formatting':
        return formatting;
      case 'detail_level':
        return detailLevel;
      case 'phrasing':
        return phrasing;
      case 'priority':
        return priority;
      default:
        return defaultColor;
    }
  }

  @override
  CategoryColorsTheme copyWith({
    Color? terminology,
    Color? formatting,
    Color? detailLevel,
    Color? phrasing,
    Color? priority,
    Color? defaultColor,
  }) {
    return CategoryColorsTheme(
      terminology: terminology ?? this.terminology,
      formatting: formatting ?? this.formatting,
      detailLevel: detailLevel ?? this.detailLevel,
      phrasing: phrasing ?? this.phrasing,
      priority: priority ?? this.priority,
      defaultColor: defaultColor ?? this.defaultColor,
    );
  }

  @override
  CategoryColorsTheme lerp(CategoryColorsTheme? other, double t) {
    if (other is! CategoryColorsTheme) return this;
    return CategoryColorsTheme(
      terminology: Color.lerp(terminology, other.terminology, t)!,
      formatting: Color.lerp(formatting, other.formatting, t)!,
      detailLevel: Color.lerp(detailLevel, other.detailLevel, t)!,
      phrasing: Color.lerp(phrasing, other.phrasing, t)!,
      priority: Color.lerp(priority, other.priority, t)!,
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
    );
  }
}

/// Theme-aware risk level colors for rejected preferences
class RiskColorsTheme extends ThemeExtension<RiskColorsTheme> {
  const RiskColorsTheme({
    required this.high,
    required this.medium,
    required this.low,
    required this.defaultColor,
  });

  final Color high;
  final Color medium;
  final Color low;
  final Color defaultColor;

  Color getColor(String? riskLevel) {
    switch (riskLevel) {
      case 'high':
        return high;
      case 'medium':
        return medium;
      case 'low':
        return low;
      default:
        return defaultColor;
    }
  }

  @override
  RiskColorsTheme copyWith({
    Color? high,
    Color? medium,
    Color? low,
    Color? defaultColor,
  }) {
    return RiskColorsTheme(
      high: high ?? this.high,
      medium: medium ?? this.medium,
      low: low ?? this.low,
      defaultColor: defaultColor ?? this.defaultColor,
    );
  }

  @override
  RiskColorsTheme lerp(RiskColorsTheme? other, double t) {
    if (other is! RiskColorsTheme) return this;
    return RiskColorsTheme(
      high: Color.lerp(high, other.high, t)!,
      medium: Color.lerp(medium, other.medium, t)!,
      low: Color.lerp(low, other.low, t)!,
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
    );
  }
}

/// Theme-aware clinical text styles for medical content
class ClinicalTextTheme extends ThemeExtension<ClinicalTextTheme> {
  const ClinicalTextTheme({
    required this.bodyStyle,
    required this.editorStyle,
  });

  final TextStyle bodyStyle;
  final TextStyle editorStyle;

  @override
  ClinicalTextTheme copyWith({
    TextStyle? bodyStyle,
    TextStyle? editorStyle,
  }) {
    return ClinicalTextTheme(
      bodyStyle: bodyStyle ?? this.bodyStyle,
      editorStyle: editorStyle ?? this.editorStyle,
    );
  }

  @override
  ClinicalTextTheme lerp(ClinicalTextTheme? other, double t) {
    if (other is! ClinicalTextTheme) return this;
    return ClinicalTextTheme(
      bodyStyle: TextStyle.lerp(bodyStyle, other.bodyStyle, t)!,
      editorStyle: TextStyle.lerp(editorStyle, other.editorStyle, t)!,
    );
  }
}
