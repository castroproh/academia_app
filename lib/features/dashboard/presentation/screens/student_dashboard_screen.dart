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

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showSidebar = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);

    final studentGrades = MockData.grades.where((g) => true).toList();
    final studentAttendance = MockData.attendanceRecords;
    final studentSubjects = MockData.subjects.where((s) => s.group == user.group).toList();

    final averageGrade = _calculateAverage(studentGrades);
    final attendanceRate = _calculateAttendanceRate(studentAttendance);
    final nextClasses = _getNextClasses(studentSubjects);
    final recentGrades = _getRecentGrades(studentGrades);

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: _showSidebar ? AppSidebar(isCollapsed: false) : null,
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Dashboard',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Dashboard'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(theme, user),
                const SizedBox(height: AppSpacing.xl),
                _buildStatsRow(theme, averageGrade, attendanceRate, studentSubjects.length),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildNextClassesCard(theme, nextClasses),
                          const SizedBox(height: AppSpacing.lg),
                          _buildRecentGradesCard(theme, recentGrades),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        children: [
                          _buildQuickActionsCard(theme),
                          const SizedBox(height: AppSpacing.lg),
                          _buildAttendanceChartCard(theme, studentAttendance),
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

  Widget _buildWelcomeHeader(ThemeData theme, User user) {
    return Row(
      children: [
        AppAvatar(name: user.fullName, radius: 32),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, ${user.fullName.split(' ').first}!',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${user.career} • ${user.group}',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              Text(
                user.institution,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
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
              Text(
                'Promedio',
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _calculateAverage(MockData.grades).toStringAsFixed(1),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ThemeData theme, double average, double attendance, int subjectCount) {
    return Row(
      children: [
        Expanded(
          child: AppStatCard(
            label: 'Promedio General',
            value: average.toStringAsFixed(1),
            icon: Icons.grade_rounded,
            iconColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primaryContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppStatCard(
            label: 'Asistencia',
            value: '${attendance.toStringAsFixed(0)}%',
            icon: Icons.how_to_reg_rounded,
            iconColor: AppColors.success,
            backgroundColor: AppColors.successContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppStatCard(
            label: 'Materias',
            value: '$subjectCount',
            icon: Icons.class_rounded,
            iconColor: theme.colorScheme.secondary,
            backgroundColor: theme.colorScheme.secondaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildNextClassesCard(ThemeData theme, List<Subject> classes) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardHeader(
            title: 'Próximas clases',
            subtitle: 'Horario de hoy',
            trailing: TextButton(
              onPressed: () => context.go(AppRouter.myClasses),
              child: const Text('Ver todas'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (classes.isEmpty)
            _buildEmptyState(theme, Icons.class_rounded, 'No hay clases programadas', 'Tu horario aparecerá aquí')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: classes.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
              itemBuilder: (context, index) {
                final subject = classes[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: subject.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Icon(Icons.book_rounded, color: subject.color, size: 22),
                  ),
                  title: Text(subject.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  subtitle: Text('${subject.schedule} • ${subject.classroom}', style: theme.textTheme.bodySmall),
                  trailing: AppButton(
                    label: 'Unirse',
                    variant: ButtonVariant.tonal,
                    onPressed: () {},
                    icon: Icons.video_call_rounded,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRecentGradesCard(ThemeData theme, List<Grade> grades) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardHeader(
            title: 'Últimas calificaciones',
            trailing: TextButton(
              onPressed: () => context.go(AppRouter.myGrades),
              child: const Text('Ver todas'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (grades.isEmpty)
            _buildEmptyState(theme, Icons.grade_rounded, 'Sin calificaciones recientes', 'Las calificaciones aparecerán aquí')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: grades.length.clamp(0, 5),
              separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
              itemBuilder: (context, index) {
                final grade = grades[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _getGradeColor(grade.percentage).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Center(
                      child: Text(
                        grade.score.toStringAsFixed(1),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _getGradeColor(grade.percentage),
                        ),
                      ),
                    ),
                  ),
                  title: Text(grade.subjectName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  subtitle: Text(grade.evaluationName, style: theme.textTheme.bodySmall),
                  trailing: AppBadge(
                    text: grade.formattedScore,
                    variant: _getGradeBadgeVariant(grade.percentage),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(ThemeData theme) {
    final actions = [
      QuickAction(icon: Icons.class_rounded, label: 'Mis Clases', route: AppRouter.myClasses, color: theme.colorScheme.primary),
      QuickAction(icon: Icons.grade_rounded, label: 'Calificaciones', route: AppRouter.myGrades, color: AppColors.success),
      QuickAction(icon: Icons.how_to_reg_rounded, label: 'Asistencia', route: AppRouter.myAttendance, color: theme.colorScheme.secondary),
      QuickAction(icon: Icons.trending_up_rounded, label: 'Progreso', route: AppRouter.myProgress, color: AppColors.warning),
      QuickAction(icon: Icons.search_rounded, label: 'Buscar usuarios', route: AppRouter.searchUsers, color: AppColors.info),
      QuickAction(icon: Icons.rate_review_rounded, label: 'Reseñas', route: AppRouter.teacherReviews, color: AppColors.tertiary),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return InkWell(
                onTap: () => context.go(action.route),
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    border: Border.all(color: action.color.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(action.icon, size: 28, color: action.color),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        action.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: action.color,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceChartCard(ThemeData theme, List<AttendanceRecord> records) {
    final present = records.where((r) => r.status == AttendanceStatus.present).length;
    final late = records.where((r) => r.status == AttendanceStatus.late).length;
    final absent = records.where((r) => r.status == AttendanceStatus.absent).length;
    final justified = records.where((r) => r.status == AttendanceStatus.justified).length;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardHeader(
            title: 'Resumen de asistencia',
            trailing: TextButton(
              onPressed: () => context.go(AppRouter.myAttendance),
              child: const Text('Ver detalle'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: [
                        if (present > 0)
                          PieChartSectionData(
                            value: present.toDouble(),
                            color: AppColors.success,
                            title: '',
                            radius: 60,
                          ),
                        if (late > 0)
                          PieChartSectionData(
                            value: late.toDouble(),
                            color: AppColors.warning,
                            title: '',
                            radius: 60,
                          ),
                        if (absent > 0)
                          PieChartSectionData(
                            value: absent.toDouble(),
                            color: AppColors.error,
                            title: '',
                            radius: 60,
                          ),
                        if (justified > 0)
                          PieChartSectionData(
                            value: justified.toDouble(),
                            color: AppColors.info,
                            title: '',
                            radius: 60,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(theme, 'Presente', present, AppColors.success),
                      _buildLegendItem(theme, 'Retardo', late, AppColors.warning),
                      _buildLegendItem(theme, 'Ausente', absent, AppColors.error),
                      _buildLegendItem(theme, 'Justificado', justified, AppColors.info),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text('$count', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  double _calculateAverage(List<Grade> grades) {
    if (grades.isEmpty) return 0;
    final weightedSum = grades.fold<double>(0, (sum, g) => sum + (g.score / g.maxScore) * g.weight * 100);
    final totalWeight = grades.fold<double>(0, (sum, g) => sum + g.weight);
    return totalWeight > 0 ? weightedSum / totalWeight : 0;
  }

  double _calculateAttendanceRate(List<AttendanceRecord> records) {
    if (records.isEmpty) return 100;
    final attended = records.where((r) => r.status == AttendanceStatus.present || r.status == AttendanceStatus.late || r.status == AttendanceStatus.justified).length;
    return (attended / records.length) * 100;
  }

  List<Subject> _getNextClasses(List<Subject> subjects) {
    return subjects.take(4).toList();
  }

  List<Grade> _getRecentGrades(List<Grade> grades) {
    final sorted = List<Grade>.from(grades)..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 90) return AppColors.success;
    if (percentage >= 70) return AppColors.primary;
    if (percentage >= 60) return AppColors.warning;
    return AppColors.error;
  }

  BadgeVariant _getGradeBadgeVariant(double percentage) {
    if (percentage >= 90) return BadgeVariant.success;
    if (percentage >= 70) return BadgeVariant.standard;
    if (percentage >= 60) return BadgeVariant.warning;
    return BadgeVariant.error;
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const QuickAction({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });
}