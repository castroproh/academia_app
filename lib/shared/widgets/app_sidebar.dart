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

class AppSidebar extends StatelessWidget {
  final bool isCollapsed;

  const AppSidebar({super.key, this.isCollapsed = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final isStudent = authProvider.isStudent;
    final isTeacher = authProvider.isTeacher;

    final navigationItems = _getNavigationItems(isStudent, isTeacher);

    return Container(
      width: isCollapsed ? 72 : 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Column(
        children: [
          _buildHeader(theme, user, isCollapsed),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.builder(
              itemCount: navigationItems.length,
              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : AppSpacing.md),
              itemBuilder: (context, index) {
                final item = navigationItems[index];
                return _buildNavItem(context, item, isCollapsed);
              },
            ),
          ),
          _buildFooter(context, theme, authProvider, isCollapsed),
        ],
      ),
    );
  }

  List<NavigationItem> _getNavigationItems(bool isStudent, bool isTeacher) {
    if (isStudent) {
      return [
        NavigationItem(
          icon: Icons.dashboard_rounded,
          label: 'Dashboard',
          route: AppRouter.studentDashboard,
        ),
        NavigationItem(
          icon: Icons.class_rounded,
          label: 'Mis Clases',
          route: AppRouter.myClasses,
        ),
        NavigationItem(
          icon: Icons.grade_rounded,
          label: 'Calificaciones',
          route: AppRouter.myGrades,
        ),
        NavigationItem(
          icon: Icons.how_to_reg_rounded,
          label: 'Asistencia',
          route: AppRouter.myAttendance,
        ),
        NavigationItem(
          icon: Icons.trending_up_rounded,
          label: 'Progreso',
          route: AppRouter.myProgress,
        ),
        NavigationItem(
          icon: Icons.search_rounded,
          label: 'Buscar usuarios',
          route: AppRouter.searchUsers,
        ),
        NavigationItem(
          icon: Icons.rate_review_rounded,
          label: 'Reseñas docentes',
          route: AppRouter.teacherReviews,
        ),
        NavigationItem(
          icon: Icons.supervisor_account_rounded,
          label: 'Supervisión',
          route: AppRouter.supervisionDashboard,
        ),
      ];
    } else if (isTeacher) {
      return [
        NavigationItem(
          icon: Icons.dashboard_rounded,
          label: 'Dashboard',
          route: AppRouter.teacherDashboard,
        ),
        NavigationItem(
          icon: Icons.groups_rounded,
          label: 'Mis Grupos',
          route: AppRouter.teacherGroups,
        ),
        NavigationItem(
          icon: Icons.people_rounded,
          label: 'Registro de alumnos',
          route: AppRouter.studentRegistry,
        ),
        NavigationItem(
          icon: Icons.assignment_rounded,
          label: 'Evaluaciones',
          route: AppRouter.evaluationManagement,
        ),
        NavigationItem(
          icon: Icons.video_call_rounded,
          label: 'Sesiones de clase',
          route: AppRouter.classSessions,
        ),
        NavigationItem(
          icon: Icons.supervisor_account_rounded,
          label: 'Supervisión',
          route: AppRouter.supervisionDashboard,
        ),
      ];
    }
    return [];
  }

  Widget _buildHeader(ThemeData theme, User? user, bool isCollapsed) {
    return Container(
      padding: EdgeInsets.all(isCollapsed ? AppSpacing.md : AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: isCollapsed
          ? Center(
              child: Icon(Icons.school_rounded, size: 32, color: theme.colorScheme.primary),
            )
          : Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [theme.colorScheme.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  ),
                  child: Icon(Icons.school_rounded, size: 24, color: theme.colorScheme.onPrimary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        AppConstants.appTagline,
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavigationItem item, bool isCollapsed) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.toString();
    final isSelected = location == item.route || location.startsWith('${item.route}/');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(item.route),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? AppSpacing.md : AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: isCollapsed
                ? Center(
                    child: Icon(
                      item.icon,
                      size: 24,
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 24,
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          item.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme, AuthProvider authProvider, bool isCollapsed) {
    final user = authProvider.currentUser;

    return Container(
      padding: EdgeInsets.all(isCollapsed ? AppSpacing.md : AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: isCollapsed
          ? Center(
              child: IconButton(
                icon: Icon(Icons.logout, color: theme.colorScheme.error),
                onPressed: () => authProvider.logout(),
                tooltip: 'Cerrar sesión',
              ),
            )
          : Column(
              children: [
                Row(
                  children: [
                    AppAvatar(
                      name: user?.fullName,
                      radius: 20,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Usuario',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            user?.role == UserRole.student ? 'Estudiante' : 'Docente',
                            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Perfil',
                        icon: Icons.person_outline,
                        variant: ButtonVariant.outlined,
                        onPressed: () => context.go(AppRouter.myProfile),
                        isFullWidth: true,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppButton(
                        label: 'Salir',
                        icon: Icons.logout,
                        variant: ButtonVariant.text,
                        onPressed: () => authProvider.logout(),
                        isFullWidth: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}