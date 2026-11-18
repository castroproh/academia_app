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

class SupervisionDashboardScreen extends StatefulWidget {
  const SupervisionDashboardScreen({super.key});

  @override
  State<SupervisionDashboardScreen> createState() => _SupervisionDashboardScreenState();
}

class _SupervisionDashboardScreenState extends State<SupervisionDashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedSession = 'Actual';
  List<String> _sessions = ['Actual', 'Matemáticas Avanzadas - 5°A', 'Física Cuántica - 5°A'];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    final currentSession = MockData.sessions.firstWhere((s) => s.status == SessionStatus.inProgress, orElse: () => MockData.sessions.first);
    final studentsInSession = MockData.students.where((s) => currentSession.studentIds.contains(s.id)).toList();
    final activities = MockData.studentActivities.where((a) => currentSession.studentIds.contains(a.studentId)).toList();

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Supervisión Digital',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Supervisión Digital'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme, currentSession),
                const SizedBox(height: AppSpacing.lg),
                _buildSessionSelector(theme),
                const SizedBox(height: AppSpacing.lg),
                _buildOverviewCards(theme, studentsInSession, activities),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildStudentsTable(theme, studentsInSession, activities),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        children: [
                          _buildAppUsageChart(theme, activities),
                          const SizedBox(height: AppSpacing.lg),
                          _buildTimelineCard(theme, activities),
                          const SizedBox(height: AppSpacing.lg),
                          _buildAlertsCard(theme),
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

  Widget _buildHeader(ThemeData theme, Session session) {
    final subject = MockData.subjects.firstWhere((s) => s.id == session.subjectId);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Supervisión Digital', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Text('Monitoreo de actividad digital en tiempo real (Demo)', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: subject.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(color: subject.color.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(subject.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: subject.color)),
              Text(session.group, style: theme.textTheme.bodySmall?.copyWith(color: subject.color)),
              Text('${session.studentIds.length} alumnos conectados', style: theme.textTheme.labelSmall?.copyWith(color: subject.color)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionSelector(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Text('Sesión:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedSession,
              isExpanded: true,
              items: _sessions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (value) => setState(() => _selectedSession = value!),
              underline: const SizedBox(),
              style: theme.textTheme.bodyMedium,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AppButton(
            label: 'Iniciar supervisión',
            icon: Icons.play_circle_rounded,
            variant: ButtonVariant.filled,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(ThemeData theme, List<User> students, List<StudentActivity> activities) {
    final totalStudents = students.length;
    final activeStudents = students.length; // Mock
    final allowedApps = activities.where((a) => a.isAllowed).length;
    final notAllowedApps = activities.where((a) => !a.isAllowed).length;

    return Row(
      children: [
        Expanded(child: AppStatCard(label: 'Alumnos en sesión', value: '$totalStudents', icon: Icons.people_rounded, iconColor: theme.colorScheme.primary, backgroundColor: theme.colorScheme.primaryContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: AppStatCard(label: 'Activos ahora', value: '$activeStudents', icon: Icons.circle_rounded, iconColor: AppColors.success, backgroundColor: AppColors.successContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: AppStatCard(label: 'Apps permitidas', value: '$allowedApps', icon: Icons.check_circle_rounded, iconColor: AppColors.info, backgroundColor: AppColors.infoContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: AppStatCard(label: 'Apps no autorizadas', value: '$notAllowedApps', icon: Icons.warning_rounded, iconColor: AppColors.warning, backgroundColor: AppColors.warningContainer)),
      ],
    );
  }

  Widget _buildStudentsTable(ThemeData theme, List<User> students, List<StudentActivity> activities) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Alumnos en la sesión', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: students.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final student = students[index];
              final studentActivities = activities.where((a) => a.studentId == student.id).toList();
              final currentApp = studentActivities.isNotEmpty ? studentActivities.last.application : 'Sin actividad';
              final isAllowed = studentActivities.isNotEmpty ? studentActivities.last.isAllowed : true;
              final totalTime = studentActivities.fold<Duration>(Duration.zero, (sum, a) => sum + a.duration);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => context.go('${AppRouter.studentActivityDetail}/${student.id}'),
                leading: AppAvatar(name: student.fullName, radius: 22, showBorder: true),
                title: Text(student.fullName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Row(
                  children: [
                    AppBadge(
                      text: currentApp,
                      variant: isAllowed ? BadgeVariant.success : BadgeVariant.error,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Tiempo: ${_formatDuration(totalTime)}', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isAllowed ? AppColors.success : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppUsageChart(ThemeData theme, List<StudentActivity> activities) {
    final appUsage = <String, int>{};
    for (final activity in activities) {
      appUsage[activity.application] = (appUsage[activity.application] ?? 0) + activity.duration.inMinutes;
    }
    final sortedApps = appUsage.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Uso de aplicaciones', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: sortedApps.take(6).map((entry) {
                  final isAllowed = AppConstants.allowedApplications.contains(entry.key);
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    color: isAllowed ? AppColors.success : AppColors.error,
                    title: '',
                    radius: 60,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: sortedApps.take(6).map((entry) {
              final isAllowed = AppConstants.allowedApplications.contains(entry.key);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: isAllowed ? AppColors.success : AppColors.error, shape: BoxShape.circle)),
                  const SizedBox(width: AppSpacing.xs),
                  Text('${entry.key} (${entry.value} min)', style: theme.textTheme.labelSmall),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(ThemeData theme, List<StudentActivity> activities) {
    final sortedActivities = List<StudentActivity>.from(activities)..sort((a, b) => a.startTime.compareTo(b.startTime));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Línea de tiempo de actividad', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedActivities.length.clamp(0, 10),
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final activity = sortedActivities[index];
              final student = MockData.students.firstWhere((s) => s.id == activity.studentId);
              final isAllowed = activity.isAllowed;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isAllowed ? AppColors.success : AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.surface, width: 2),
                        ),
                      ),
                      if (index < sortedActivities.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: theme.colorScheme.outlineVariant,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: isAllowed ? AppColors.success.withValues(alpha: 0.3) : AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppAvatar(name: student.fullName, radius: 14),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(child: Text(student.fullName, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500))),
                              Text(_formatTime(activity.startTime), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Icon(isAllowed ? Icons.check_circle_rounded : Icons.warning_rounded, size: 14, color: isAllowed ? AppColors.success : AppColors.error),
                              const SizedBox(width: AppSpacing.xs),
                              Text(activity.application, style: theme.textTheme.bodySmall),
                              const SizedBox(width: AppSpacing.md),
                              Text('Duración: ${activity.duration.inMinutes} min', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              const Spacer(),
                              AppBadge(
                                text: isAllowed ? 'Permitida' : 'No autorizada',
                                variant: isAllowed ? BadgeVariant.success : BadgeVariant.error,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsCard(ThemeData theme) {
    final alerts = [
      AlertItem('Juan Pérez Martínez', 'Usando Discord durante clase', AppColors.warning, 'Hace 5 min'),
      AlertItem('Carlos Sánchez Ruiz', 'Spotify detectado en segundo plano', AppColors.warning, 'Hace 12 min'),
      AlertItem('Pedro Gómez Moreno', 'Discord abierto por 5 min', AppColors.error, 'Hace 18 min'),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Alertas de demostración', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alerts.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: alert.color.withValues(alpha: 0.15),
                  child: Icon(Icons.warning_rounded, color: alert.color, size: 20),
                ),
                title: Text(alert.studentName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text(alert.message, style: theme.textTheme.bodySmall),
                trailing: Text(alert.time, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class AlertItem {
  final String studentName;
  final String message;
  final Color color;
  final String time;

  AlertItem(this.studentName, this.message, this.color, this.time);
}