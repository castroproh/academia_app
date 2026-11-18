import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final bool showBorder;
  final BorderSide? borderSide;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 20,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.showBorder = false,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? _getColorFromName(name);
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimary;

    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null && name != null
          ? Text(
              _getInitials(name!),
              style: theme.textTheme.titleMedium?.copyWith(
                color: fgColor,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );

    if (showBorder) {
      avatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderSide?.color ?? theme.colorScheme.outlineVariant,
            width: borderSide?.width ?? 2,
            style: borderSide?.style ?? BorderStyle.solid,
          ),
        ),
        child: avatar,
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: avatar,
      );
    }

    return avatar;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  Color _getColorFromName(String? name) {
    if (name == null) return AppColors.primary;
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      AppColors.success,
      AppColors.warning,
      AppColors.info,
    ];
    final index = name.codeUnits.reduce((a, b) => a + b) % colors.length;
    return colors[index];
  }
}

class AppAvatarStack extends StatelessWidget {
  final List<String?> imageUrls;
  final List<String?>? names;
  final int maxVisible;
  final double radius;
  final double overlap;

  const AppAvatarStack({
    super.key,
    required this.imageUrls,
    this.names,
    this.maxVisible = 4,
    this.radius = 20,
    this.overlap = 8,
  });

  @override
  Widget build(BuildContext context) {
    final visibleUrls = imageUrls.take(maxVisible).toList();
    final visibleNames = names?.take(maxVisible).toList();
    final remaining = imageUrls.length - maxVisible;

    return SizedBox(
      width: visibleUrls.length * (radius * 2 - overlap) + overlap + (remaining > 0 ? radius * 2 : 0),
      height: radius * 2,
      child: Stack(
        children: [
          for (int i = 0; i < visibleUrls.length; i++)
            Positioned(
              left: i * (radius * 2 - overlap).toDouble(),
              child: AppAvatar(
                imageUrl: visibleUrls[i],
                name: visibleNames?[i],
                radius: radius,
                showBorder: true,
                borderSide: BorderSide(color: Theme.of(context).colorScheme.surface, width: 2),
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: visibleUrls.length * (radius * 2 - overlap).toDouble(),
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}