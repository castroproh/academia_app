import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonStyle? style;
  final ButtonVariant variant;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.style,
    this.variant = ButtonVariant.filled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget child = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == ButtonVariant.filled || variant == ButtonVariant.elevated
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
              ),
            ),
          )
        else if (icon != null)
          Icon(icon, size: 20),
        if ((icon != null || isLoading) && !isLoading) const SizedBox(width: AppSpacing.sm),
        Text(label, style: theme.textTheme.labelLarge),
        if (trailingIcon != null && !isLoading) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(trailingIcon, size: 20),
        ],
      ],
    );

    switch (variant) {
      case ButtonVariant.filled:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        );
      case ButtonVariant.elevated:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        );
      case ButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        );
      case ButtonVariant.tonal:
        return FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        );
    }
  }
}

enum ButtonVariant { filled, elevated, outlined, text, tonal }

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double size;
  final double iconSize;
  final bool isSelected;
  final Color? selectedColor;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.size = 40,
    this.iconSize = 24,
    this.isSelected = false,
    this.selectedColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? (isSelected ? theme.colorScheme.primaryContainer : Colors.transparent);
    final fgColor = color ?? (isSelected ? (selectedColor ?? theme.colorScheme.primary) : theme.colorScheme.onSurfaceVariant);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppBorderRadius.full),
          ),
          child: Center(
            child: Icon(icon, size: iconSize, color: fgColor),
          ),
        ),
      ),
    );
  }
}

class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final bool isExtended;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.isExtended = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label!),
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
        elevation: AppElevation.level3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.xl)),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(icon),
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      elevation: AppElevation.level3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.xl)),
    );
  }
}

class AppSegmentedButton<T> extends StatelessWidget {
  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>> onSelectionChanged;

  const AppSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      style: Theme.of(context).segmentedButtonTheme.style,
    );
  }
}