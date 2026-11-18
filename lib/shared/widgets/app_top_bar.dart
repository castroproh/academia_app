import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routing/app_router.dart';
import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../../models/academic_models.dart';
import '../../shared/widgets/app_avatar.dart';
import '../../shared/widgets/app_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showProfileMenu;
  final VoidCallback? onMenuPressed;

  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showProfileMenu = true,
    this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final location = GoRouterState.of(context).uri.toString();

    return AppBar(
      leading: leading ??
          (onMenuPressed != null
              ? IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: onMenuPressed,
                )
              : null),
      title: Text(title),
      actions: [
        if (actions != null) ...actions!,
        if (showProfileMenu && user != null) _buildProfileMenu(context, theme, user, location),
      ],
    );
  }

  Widget _buildProfileMenu(BuildContext context, ThemeData theme, User user, String location) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuAction(context, value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.md),
              const Text('Mi perfil'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 20, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.md),
              const Text('Configuración'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: theme.colorScheme.error),
              const SizedBox(width: AppSpacing.md),
              Text('Cerrar sesión', style: TextStyle(color: theme.colorScheme.error)),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAvatar(
              name: user.fullName,
              radius: 18,
            ),
            const SizedBox(width: AppSpacing.sm),
            if (!isNarrowScreen(context)) ...[
              Text(
                user.fullName,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  bool isNarrowScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'profile':
        context.go(AppRouter.myProfile);
        break;
      case 'settings':
        context.go(AppRouter.settings);
        break;
      case 'logout':
        context.read<AuthProvider>().logout();
        break;
    }
  }
}

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autoFocus;

  const AppSearchBar({
    super.key,
    this.controller,
    this.hint = 'Buscar...',
    this.onChanged,
    this.onClear,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant, size: 22),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: theme.colorScheme.onSurfaceVariant),
                  onPressed: () {
                    controller!.clear();
                    onClear?.call();
                    onChanged?.call('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}