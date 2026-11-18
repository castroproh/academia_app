import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class AppThemeData {
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.secondary,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.tertiary,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceContainerHigh,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: AppColors.shadow,
      scrim: AppColors.scrim,
      inverseSurface: AppColors.onBackground,
      onInverseSurface: AppColors.background,
      inversePrimary: AppColors.primaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      dividerTheme: _dividerTheme(colorScheme),
      navigationBarTheme: _navigationBarTheme(colorScheme),
      navigationRailTheme: _navigationRailTheme(colorScheme),
      drawerTheme: _drawerTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      snackBarTheme: _snackBarTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      segmentedButtonTheme: _segmentedButtonTheme(colorScheme),
      tabBarTheme: _tabBarTheme(colorScheme),
      listTileTheme: _listTileTheme(colorScheme),
      iconTheme: _iconTheme(colorScheme),
      progressIndicatorTheme: _progressIndicatorTheme(colorScheme),
      sliderTheme: _sliderTheme(colorScheme),
      switchTheme: _switchTheme(colorScheme),
      checkboxTheme: _checkboxTheme(colorScheme),
      radioTheme: _radioTheme(colorScheme),
      tooltipTheme: _tooltipTheme(colorScheme),
    );
  }

  static ThemeData get darkTheme {
    final ColorScheme colorScheme = const ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.primaryDark,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.secondaryDark,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.tertiaryLight,
      onTertiary: AppColors.tertiaryDark,
      tertiaryContainer: AppColors.tertiaryDark,
      onTertiaryContainer: AppColors.tertiaryLight,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.error,
      surface: const Color(0xFF1E1F22),
      onSurface: const Color(0xFFE6E6E6),
      surfaceContainerHighest: const Color(0xFF2C2D30),
      onSurfaceVariant: const Color(0xFFC4C6CC),
      outline: const Color(0xFF4A4D52),
      outlineVariant: const Color(0xFF3A3D42),
      shadow: const Color(0x1A000000),
      scrim: const Color(0x80000000),
      inverseSurface: const Color(0xFFE6E6E6),
      onInverseSurface: const Color(0xFF1E1F22),
      inversePrimary: AppColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1A1B1E),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      dividerTheme: _dividerTheme(colorScheme),
      navigationBarTheme: _navigationBarTheme(colorScheme),
      navigationRailTheme: _navigationRailTheme(colorScheme),
      drawerTheme: _drawerTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      snackBarTheme: _snackBarTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      segmentedButtonTheme: _segmentedButtonTheme(colorScheme),
      tabBarTheme: _tabBarTheme(colorScheme),
      listTileTheme: _listTileTheme(colorScheme),
      iconTheme: _iconTheme(colorScheme),
      progressIndicatorTheme: _progressIndicatorTheme(colorScheme),
      sliderTheme: _sliderTheme(colorScheme),
      switchTheme: _switchTheme(colorScheme),
      checkboxTheme: _checkboxTheme(colorScheme),
      radioTheme: _radioTheme(colorScheme),
      tooltipTheme: _tooltipTheme(colorScheme),
    );
  }

  static TextTheme _textTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: colorScheme.onSurface),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: colorScheme.onSurface),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: colorScheme.onSurface),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: colorScheme.onSurface),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: colorScheme.onSurface),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: colorScheme.onSurface),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: colorScheme.onSurface),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: colorScheme.onSurface),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: colorScheme.onSurface),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: colorScheme.onSurface),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: colorScheme.onSurface),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: colorScheme.onSurface),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurface),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }

  static AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: AppElevation.level0,
      scrolledUnderElevation: AppElevation.level1,
      shadowColor: colorScheme.shadow,
      centerTitle: false,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: colorScheme.onSurface),
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
      actionsIconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
    );
  }

  static CardThemeData _cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      color: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: AppElevation.level1,
      shadowColor: colorScheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        elevation: AppElevation.level1,
        shadowColor: colorScheme.shadow,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.md)),
        textStyle: AppTextStyles.labelLarge,
        side: BorderSide.none,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onPrimary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.onPrimary.withValues(alpha: 0.08);
            }
            return null;
          },
        ),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.md)),
        textStyle: AppTextStyles.labelLarge,
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        side: BorderSide(color: colorScheme.outline, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.md)),
        textStyle: AppTextStyles.labelLarge,
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withValues(alpha: 0.05);
            }
            return null;
          },
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        minimumSize: const Size(64, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.md)),
        textStyle: AppTextStyles.labelLarge,
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withValues(alpha: 0.05);
            }
            return null;
          },
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(color: colorScheme.outline, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(color: colorScheme.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(color: colorScheme.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: colorScheme.error),
      helperStyle: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
      floatingLabelStyle: AppTextStyles.bodySmall.copyWith(color: colorScheme.primary),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return colorScheme.primary;
        return colorScheme.onSurfaceVariant;
      }),
      suffixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return colorScheme.primary;
        return colorScheme.onSurfaceVariant;
      }),
    );
  }

  static ChipThemeData _chipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainer,
      disabledColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primaryContainer,
      secondarySelectedColor: colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      labelStyle: AppTextStyles.labelMedium.copyWith(color: colorScheme.onSurface),
      secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: colorScheme.onPrimaryContainer),
      brightness: colorScheme.brightness,
      elevation: AppElevation.level0,
      pressElevation: AppElevation.level1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      selectedShadowColor: colorScheme.shadow,
      showCheckmark: false,
    );
  }

  static DividerThemeData _dividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 1,
      space: 1,
      indent: 0,
      endIndent: 0,
    );
  }

  static NavigationBarThemeData _navigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: AppElevation.level3,
      shadowColor: colorScheme.shadow,
      height: 72,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorColor: colorScheme.primaryContainer,
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colorScheme.primary, size: 24);
        }
        return IconThemeData(color: colorScheme.onSurfaceVariant, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyles.labelSmall.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600);
        }
        return AppTextStyles.labelSmall.copyWith(color: colorScheme.onSurfaceVariant);
      }),
    );
  }

  static NavigationRailThemeData _navigationRailTheme(ColorScheme colorScheme) {
    return NavigationRailThemeData(
      backgroundColor: colorScheme.surface,
      elevation: AppElevation.level1,
      indicatorColor: colorScheme.primaryContainer,
      selectedIconTheme: IconThemeData(color: colorScheme.primary, size: 24),
      unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant, size: 24),
      selectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
      unselectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(color: colorScheme.onSurfaceVariant),
      labelType: NavigationRailLabelType.all,
      minWidth: 72,
      minExtendedWidth: 200,
      groupAlignment: -1.0,
    );
  }

  static DrawerThemeData _drawerTheme(ColorScheme colorScheme) {
    return DrawerThemeData(
      backgroundColor: colorScheme.surface,
      elevation: AppElevation.level4,
      shadowColor: colorScheme.shadow,
      shape: const RoundedRectangleBorder(),
      width: 320,
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      elevation: AppElevation.level4,
      shadowColor: colorScheme.shadow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppBorderRadius.xl)),
      ),
      modalBackgroundColor: colorScheme.surface,
      constraints: const BoxConstraints(maxWidth: 600),
    );
  }

  static DialogThemeData _dialogTheme(ColorScheme colorScheme) {
    return DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: AppElevation.level4,
      shadowColor: colorScheme.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.xl)),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: colorScheme.onSurface),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
      alignment: Alignment.center,
    );
  }

  static SnackBarThemeData _snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onInverseSurface),
      actionTextColor: colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.md)),
      elevation: AppElevation.level3,
    );
  }

  static FloatingActionButtonThemeData _fabTheme(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: AppElevation.level3,
      focusElevation: AppElevation.level4,
      hoverElevation: AppElevation.level4,
      highlightElevation: AppElevation.level4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.xl)),
      extendedTextStyle: AppTextStyles.labelLarge,
      extendedIconLabelSpacing: AppSpacing.sm,
    );
  }

  static SegmentedButtonThemeData _segmentedButtonTheme(ColorScheme colorScheme) {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceContainer;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurface;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.selected)) {
            return BorderSide(color: colorScheme.primary, width: 2);
          }
          return BorderSide(color: colorScheme.outlineVariant, width: 1);
        }),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.md))),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm)),
        textStyle: WidgetStateProperty.all(AppTextStyles.labelMedium),
      ),
    );
  }

  static TabBarThemeData _tabBarTheme(ColorScheme colorScheme) {
    return TabBarThemeData(
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      indicatorColor: colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: colorScheme.outlineVariant,
      labelStyle: AppTextStyles.labelLarge,
      unselectedLabelStyle: AppTextStyles.labelLarge,
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.primary.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.primary.withValues(alpha: 0.05);
        }
        return null;
      }),
    );
  }

  static ListTileThemeData _listTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      titleTextStyle: AppTextStyles.titleMedium.copyWith(color: colorScheme.onSurface),
      subtitleTextStyle: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.md)),
      tileColor: Colors.transparent,
      selectedTileColor: colorScheme.primaryContainer,
      selectedColor: colorScheme.primary,
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      minLeadingWidth: 40,
      minVerticalPadding: AppSpacing.sm,
      horizontalTitleGap: AppSpacing.md,
    );
  }

  static IconThemeData _iconTheme(ColorScheme colorScheme) {
    return IconThemeData(
      color: colorScheme.onSurfaceVariant,
      size: 24,
      opacity: 1.0,
    );
  }

  static ProgressIndicatorThemeData _progressIndicatorTheme(ColorScheme colorScheme) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
      circularTrackColor: colorScheme.surfaceContainerHighest,
      refreshBackgroundColor: colorScheme.surfaceContainer,
    );
  }

  static SliderThemeData _sliderTheme(ColorScheme colorScheme) {
    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.surfaceContainerHighest,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(alpha: 0.1),
      valueIndicatorColor: colorScheme.primary,
      valueIndicatorTextStyle: AppTextStyles.labelSmall.copyWith(color: colorScheme.onPrimary),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    );
  }

  static SwitchThemeData _switchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) return colorScheme.primary;
        return colorScheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) return colorScheme.primaryContainer;
        return colorScheme.surfaceContainerHighest;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) return colorScheme.primary.withValues(alpha: 0.1);
        if (states.contains(WidgetState.focused)) return colorScheme.primary.withValues(alpha: 0.1);
        return null;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) return colorScheme.primary;
        return colorScheme.outlineVariant;
      }),
    );
  }

  static CheckboxThemeData _checkboxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) return colorScheme.primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      side: BorderSide(color: colorScheme.outline, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.sm)),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) return colorScheme.primary.withValues(alpha: 0.1);
        return null;
      }),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  static RadioThemeData _radioTheme(ColorScheme colorScheme) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) return colorScheme.primary;
        return colorScheme.outline;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) return colorScheme.primary.withValues(alpha: 0.1);
        return null;
      }),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  static TooltipThemeData _tooltipTheme(ColorScheme colorScheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      textStyle: AppTextStyles.labelSmall.copyWith(color: colorScheme.onInverseSurface),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      verticalOffset: 8,
      preferBelow: true,
      excludeFromSemantics: false,
    );
  }
}