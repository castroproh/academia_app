import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../features/authentication/presentation/providers/auth_provider.dart';
import '../../../../data/mock/mock_data.dart';
import '../../../../models/academic_models.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../../../../shared/widgets/app_sidebar.dart';
import '../../../../shared/widgets/app_bottom_navigation.dart';
import '../../../../shared/widgets/responsive_layout.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);

    final teacherGroups = MockData.groups.where((g) => g.tutorId == user.id).toList();
    final teacherSubjects = MockData.subjects.where((s) => s.teacherId == user.id).toList();
    final totalStudents = teacherGroups.fold<int>(0, (sum, g) => sum + g.studentCount);

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Dashboard Docente',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Dashboard Docente'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(theme, user, teacherGroups),
                const SizedBox(height: AppSpacing.xl),
                _buildStatsRow(theme, teacherGroups.length, teacherSubjects.length, totalStudents),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildMyGroupsCard(theme, teacherGroups),
                          const SizedBox(height: AppSpacing.lg),
                          _buildRecentActivityCard(theme),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        children: [
                          _buildQuickActionsCard(theme),
                          const SizedBox(height: AppSpacing.lg),
                          _buildSubjectStatsCard(theme, teacherSubjects),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(ThemeData theme, User user, List<Group> teacherGroups) {
    return Row(
      children: [
        AppAvatar(name: user.fullName, radius: 32),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¡Hola, ${user.fullName.split(' ').first}!', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Text(user.career, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              Text(user.institution, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          child: Column(
            children: [
              Text('Grupos a cargo', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                teacherGroups.length.toString(),
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ThemeData theme, int groups, int subjects, int students) {
    return Row(
      children: [
        Expanded(child: AppStatCard(label: 'Grupos', value: '$groups', icon: Icons.groups_rounded, iconColor: theme.colorScheme.primary, backgroundColor: theme.colorScheme.primaryContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: AppStatCard(label: 'Materias', value: '$subjects', icon: Icons.class_rounded, iconColor: theme.colorScheme.secondary, backgroundColor: theme.colorScheme.secondaryContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: AppStatCard(label: 'Alumnos totales', value: '$students', icon: Icons.people_rounded, iconColor: AppColors.success, backgroundColor: AppColors.successContainer)),
      ],
    );
  }

  Widget _buildMyGroupsCard(ThemeData theme, List<Group> groups) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardHeader(
            title: 'Mis grupos',
            trailing: TextButton(onPressed: () => context.go(AppRouter.teacherGroups), child: const Text('Ver todos')),
          ),
          const SizedBox(height: AppSpacing.md),
          if (groups.isEmpty)
            _buildEmptyState(theme, Icons.groups_rounded, 'Sin grupos asignados')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groups.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
              itemBuilder: (context, index) {
                final group = groups[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(group.name.split('°').first, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                  ),
                  title: Text(group.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  subtitle: Text('${group.studentCount} alumnos • ${group.career}', style: theme.textTheme.bodySmall),
                  trailing: AppButton(label: 'Entrar', variant: ButtonVariant.tonal, onPressed: () {}),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(ThemeData theme) {
    final activities = [
      ('Nueva entrega', 'Proyecto final de Programación Estructurada', Icons.assignment_turned_in_rounded, AppColors.info, 'Hace 2 horas'),
      ('Calificación publicada', 'Examen Parcial 1 - Matemáticas Avanzadas', Icons.grade_rounded, AppColors.success, 'Hace 5 horas'),
      ('Sesión programada', 'Inteligencia Artificial - Mañana 10:00', Icons.video_call_rounded, theme.colorScheme.primary, 'Mañana'),
      ('Reseña recibida', 'Nueva reseña anónima para tu clase', Icons.rate_review_rounded, AppColors.warning, 'Ayer'),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardHeader(title: 'Actividad reciente'),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final (title, subtitle, icon, color, time) = activities[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(icon, color: color, size: 20)),
                title: Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
                trailing: Text(time, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(ThemeData theme) {
    final actions = [
      QuickAction(icon: Icons.groups_rounded, label: 'Mis Grupos', route: AppRouter.teacherGroups, color: theme.colorScheme.primary),
      QuickAction(icon: Icons.people_rounded, label: 'Alumnos', route: AppRouter.studentRegistry, color: AppColors.success),
      QuickAction(icon: Icons.assignment_rounded, label: 'Evaluaciones', route: AppRouter.evaluationManagement, color: theme.colorScheme.secondary),
      QuickAction(icon: Icons.video_call_rounded, label: 'Sesiones', route: AppRouter.classSessions, color: AppColors.info),
      QuickAction(icon: Icons.supervisor_account_rounded, label: 'Supervisión', route: AppRouter.supervisionDashboard, color: AppColors.warning),
      QuickAction(icon: Icons.analytics_rounded, label: 'Reportes', route: AppRouter.settings, color: AppColors.tertiary),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardHeader(title: 'Accesos rápidos'),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: AppSpacing.md, mainAxisSpacing: AppSpacing.md, childAspectRatio: 1),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return InkWell(
                onTap: () => context.go(action.route),
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: action.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppBorderRadius.lg), border: Border.all(color: action.color.withValues(alpha: 0.3))),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(action.icon, size: 28, color: action.color), const SizedBox(height: AppSpacing.sm), Text(action.label, style: theme.textTheme.labelMedium?.copyWith(color: action.color, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectStatsCard(ThemeData theme, List<Subject> subjects) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardHeader(title: 'Materias impartidas'),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjects.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final subject = subjects[index];
              final group = MockData.groups.firstWhere((g) => g.subjectIds.contains(subject.id));
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundColor: subject.color.withValues(alpha: 0.15), child: Icon(Icons.book_rounded, color: subject.color)),
                title: Text(subject.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text('${group.name} • ${group.studentCount} alumnos', style: theme.textTheme.bodySmall),
                trailing: AppButton(label: 'Gestionar', variant: ButtonVariant.tonal, onPressed: () {}),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, IconData icon, String title) {
    return Center(child: Padding(padding: const EdgeInsets.all(AppSpacing.xl), child: Column(children: [Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)), const SizedBox(height: AppSpacing.md), Text(title, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))])));
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const QuickAction({required this.icon, required this.label, required this.route, required this.color});
}