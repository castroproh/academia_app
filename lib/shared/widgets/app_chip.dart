import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final Color? labelColor;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final ChipVariant variant;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.labelColor,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
    this.variant = ChipVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case ChipVariant.standard:
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(label, style: theme.textTheme.labelMedium),
            ],
          ),
          selected: isSelected,
          onSelected: onTap != null ? (_) => onTap!() : null,
          onDeleted: onDelete,
          backgroundColor: color ?? theme.colorScheme.surfaceContainer,
          selectedColor: color ?? theme.colorScheme.primaryContainer,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? (labelColor ?? theme.colorScheme.primary) : theme.colorScheme.onSurface,
          ),
          checkmarkColor: labelColor ?? theme.colorScheme.primary,
          deleteIconColor: theme.colorScheme.onSurfaceVariant,
          side: BorderSide(
            color: isSelected ? (color ?? theme.colorScheme.primary) : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.full)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        );
      case ChipVariant.input:
        return InputChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(label, style: theme.textTheme.labelMedium),
            ],
          ),
          selected: isSelected,
          onSelected: onTap != null ? (_) => onTap!() : null,
          onDeleted: onDelete,
          backgroundColor: color ?? theme.colorScheme.surfaceContainer,
          selectedColor: color ?? theme.colorScheme.primaryContainer,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? (labelColor ?? theme.colorScheme.primary) : theme.colorScheme.onSurface,
          ),
          deleteIconColor: theme.colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.full)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        );
      case ChipVariant.choice:
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(label, style: theme.textTheme.labelMedium),
            ],
          ),
          selected: isSelected,
          onSelected: onTap != null ? (_) => onTap!() : null,
          backgroundColor: color ?? theme.colorScheme.surfaceContainer,
          selectedColor: color ?? theme.colorScheme.primaryContainer,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? (labelColor ?? theme.colorScheme.primary) : theme.colorScheme.onSurface,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.full)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        );
      case ChipVariant.action:
        return ActionChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(label, style: theme.textTheme.labelMedium),
            ],
          ),
          onPressed: onTap,
          backgroundColor: color ?? theme.colorScheme.surfaceContainer,
          labelStyle: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.full)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        );
    }
  }
}

enum ChipVariant { standard, input, choice, action }

class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final BadgeVariant variant;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.variant = BadgeVariant.standard,
    this.fontSize = 11,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bgColor;
    Color fgColor;

    switch (variant) {
      case BadgeVariant.standard:
        bgColor = backgroundColor ?? theme.colorScheme.primaryContainer;
        fgColor = textColor ?? theme.colorScheme.primary;
        break;
      case BadgeVariant.success:
        bgColor = backgroundColor ?? AppColors.successContainer;
        fgColor = textColor ?? AppColors.success;
        break;
      case BadgeVariant.warning:
        bgColor = backgroundColor ?? AppColors.warningContainer;
        fgColor = textColor ?? AppColors.warning;
        break;
      case BadgeVariant.error:
        bgColor = backgroundColor ?? AppColors.errorContainer;
        fgColor = textColor ?? AppColors.error;
        break;
      case BadgeVariant.info:
        bgColor = backgroundColor ?? AppColors.infoContainer;
        fgColor = textColor ?? AppColors.info;
        break;
      case BadgeVariant.neutral:
        bgColor = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
        fgColor = textColor ?? theme.colorScheme.onSurfaceVariant;
        break;
      case BadgeVariant.outline:
        return Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline, width: 1),
            borderRadius: BorderRadius.circular(AppBorderRadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize + 2, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                text,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
    }

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: fgColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}

enum BadgeVariant { standard, success, warning, error, info, neutral, outline }

class AppStatusIndicator extends StatelessWidget {
  final String label;
  final StatusType type;
  final bool showDot;
  final double dotSize;

  const AppStatusIndicator({
    super.key,
    required this.label,
    required this.type,
    this.showDot = true,
    this.dotSize = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color dotColor;
    Color textColor;

    switch (type) {
      case StatusType.active:
        dotColor = AppColors.success;
        textColor = AppColors.success;
        break;
      case StatusType.inactive:
        dotColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
        textColor = theme.colorScheme.onSurfaceVariant;
        break;
      case StatusType.pending:
        dotColor = AppColors.warning;
        textColor = AppColors.warning;
        break;
      case StatusType.error:
        dotColor = AppColors.error;
        textColor = AppColors.error;
        break;
      case StatusType.info:
        dotColor = AppColors.info;
        textColor = AppColors.info;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot)
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        if (showDot) const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

enum StatusType { active, inactive, pending, error, info }