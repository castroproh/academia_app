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

class MyGradesScreen extends StatefulWidget {
  const MyGradesScreen({super.key});

  @override
  State<MyGradesScreen> createState() => _MyGradesScreenState();
}

class _MyGradesScreenState extends State<MyGradesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedSubject = 'Todas';

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);

    final studentGrades = MockData.grades;
    final studentSubjects = MockData.subjects.where((s) => s.group == user.group).toList();
    final subjects = ['Todas', ...studentSubjects.map((s) => s.name)];
    
    final filteredGrades = _selectedSubject == 'Todas'
        ? studentGrades
        : studentGrades.where((g) => g.subjectName == _selectedSubject).toList();

    final average = _calculateAverage(filteredGrades);
    final subjectAverages = _calculateSubjectAverages(studentGrades, studentSubjects);

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Calificaciones',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Calificaciones'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                const SizedBox(height: AppSpacing.lg),
                _buildFilterChips(theme, subjects),
                const SizedBox(height: AppSpacing.lg),
                _buildAverageCard(theme, average),
                const SizedBox(height: AppSpacing.lg),
                _buildSubjectAveragesCard(theme, subjectAverages),
                const SizedBox(height: AppSpacing.lg),
                _buildGradesList(theme, filteredGrades),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mis Calificaciones', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Text('Histórico de evaluaciones y desempeño', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(ThemeData theme, List<String> subjects) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: subjects.map((subject) {
          final isSelected = _selectedSubject == subject;
          return Padding(
            padding: EdgeInsets.only(right: subject == subjects.last ? 0 : AppSpacing.sm),
            child: FilterChip(
              label: Text(subject),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedSubject = subject),
              backgroundColor: theme.colorScheme.surfaceContainer,
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
              side: BorderSide(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.full)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAverageCard(ThemeData theme, double average) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Promedio General', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  average.toStringAsFixed(1),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _getAverageColor(average),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _getAverageLabel(average),
                  style: theme.textTheme.bodyMedium?.copyWith(color: _getAverageColor(average), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: average / 100,
              strokeWidth: 12,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(_getAverageColor(average)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectAveragesCard(ThemeData theme, Map<String, double> averages) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Promedio por materia', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < averages.length) {
                          final subjectName = averages.keys.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Text(
                              subjectName.length > 8 ? '${subjectName.substring(0, 8)}...' : subjectName,
                              style: theme.textTheme.labelSmall,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.colorScheme.outlineVariant,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: averages.entries.toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final subject = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: subject.value,
                        color: _getAverageColor(subject.value),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppBorderRadius.sm)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesList(ThemeData theme, List<Grade> grades) {
    if (grades.isEmpty) {
      return AppCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Icon(Icons.grade_rounded, size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                const SizedBox(height: AppSpacing.md),
                Text('Sin calificaciones', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: AppSpacing.xs),
                Text('No hay calificaciones para mostrar', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detalle de evaluaciones', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: grades.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final grade = grades[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(grade.evaluationName, style: theme.textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        AppChip(
                          label: grade.type.name.toUpperCase(),
                          variant: ChipVariant.standard,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        AppChip(
                          label: 'Peso: ${(grade.weight * 100).toInt()}%',
                          variant: ChipVariant.standard,
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppBadge(
                      text: grade.formattedScore,
                      variant: _getGradeBadgeVariant(grade.percentage),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _formatDate(grade.date),
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getAverageColor(double average) {
    if (average >= 90) return AppColors.success;
    if (average >= 80) return AppColors.primary;
    if (average >= 70) return AppColors.info;
    if (average >= 60) return AppColors.warning;
    return AppColors.error;
  }

  String _getAverageLabel(double average) {
    if (average >= 90) return 'Excelente';
    if (average >= 80) return 'Muy bien';
    if (average >= 70) return 'Bien';
    if (average >= 60) return 'Regular';
    return 'Necesita mejorar';
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

  double _calculateAverage(List<Grade> grades) {
    if (grades.isEmpty) return 0;
    final weightedSum = grades.fold<double>(0, (sum, g) => sum + (g.score / g.maxScore) * g.weight * 100);
    final totalWeight = grades.fold<double>(0, (sum, g) => sum + g.weight);
    return totalWeight > 0 ? weightedSum / totalWeight : 0;
  }

  Map<String, double> _calculateSubjectAverages(List<Grade> grades, List<Subject> subjects) {
    final map = <String, double>{};
    for (final subject in subjects) {
      final subjectGrades = grades.where((g) => g.subjectId == subject.id).toList();
      map[subject.name] = _calculateAverage(subjectGrades);
    }
    return map;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}