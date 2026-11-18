import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../../core/routing/app_router.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final isStudent = authProvider.isStudent;
    final isTeacher = authProvider.isTeacher;

    final items = _getNavigationItems(isStudent, isTeacher);
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _getSelectedIndex(location, items);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => context.go(items[index].route),
      destinations: items.map((item) => NavigationDestination(
        icon: Icon(item.icon, size: 24),
        selectedIcon: Icon(item.icon, size: 24, color: theme.colorScheme.primary),
        label: item.label,
      )).toList(),
    );
  }

  List<BottomNavItem> _getNavigationItems(bool isStudent, bool isTeacher) {
    if (isStudent) {
      return [
        BottomNavItem(icon: Icons.dashboard_rounded, label: 'Inicio', route: AppRouter.studentDashboard),
        BottomNavItem(icon: Icons.class_rounded, label: 'Clases', route: AppRouter.myClasses),
        BottomNavItem(icon: Icons.grade_rounded, label: 'Notas', route: AppRouter.myGrades),
        BottomNavItem(icon: Icons.how_to_reg_rounded, label: 'Asistencia', route: AppRouter.myAttendance),
        BottomNavItem(icon: Icons.person_rounded, label: 'Perfil', route: AppRouter.myProfile),
      ];
    } else if (isTeacher) {
      return [
        BottomNavItem(icon: Icons.dashboard_rounded, label: 'Inicio', route: AppRouter.teacherDashboard),
        BottomNavItem(icon: Icons.groups_rounded, label: 'Grupos', route: AppRouter.teacherGroups),
        BottomNavItem(icon: Icons.assignment_rounded, label: 'Evaluaciones', route: AppRouter.evaluationManagement),
        BottomNavItem(icon: Icons.people_rounded, label: 'Alumnos', route: AppRouter.studentRegistry),
        BottomNavItem(icon: Icons.person_rounded, label: 'Perfil', route: AppRouter.myProfile),
      ];
    }
    return [];
  }

  int _getSelectedIndex(String location, List<BottomNavItem> items) {
    for (int i = 0; i < items.length; i++) {
      if (location == items[i].route || location.startsWith('${items[i].route}/')) {
        return i;
      }
    }
    return 0;
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}