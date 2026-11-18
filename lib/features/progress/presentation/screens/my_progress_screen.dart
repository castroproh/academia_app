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

class MyProgressScreen extends StatefulWidget {
  const MyProgressScreen({super.key});

  @override
  State<MyProgressScreen> createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);

    final studentGrades = MockData.grades;
    final semesters = [1, 2, 3, 4, 5];
    final semesterAverages = _calculateSemesterAverages(studentGrades);
    final recognitions = _getMockRecognitions();

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Mi Progreso',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Mi Progreso'),
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
                _buildEvolutionChart(theme, semesterAverages),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildRecognitionsCard(theme, recognitions),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: _buildAcademicHistoryCard(theme),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildSubjectProgressCard(theme, studentGrades),
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
              Text('Mi Progreso Académico', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Text('Evolución de rendimiento y logros', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEvolutionChart(ThemeData theme, Map<int, double> averages) {
    final sortedSemesters = averages.keys.toList()..sort();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Evolución del promedio por semestre', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) => FlLine(color: theme.colorScheme.outlineVariant, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 10,
                      getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: theme.textTheme.labelSmall),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final semester = value.toInt();
                        if (averages.containsKey(semester)) {
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Text('Sem $semester', style: theme.textTheme.labelSmall),
                          );
                        }
                        return const Text('');
},
            ),
          ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: sortedSemesters.map((s) => FlSpot(s.toDouble(), averages[s]!)).toList(),
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 6,
                        color: theme.colorScheme.primary,
                        strokeWidth: 3,
                        strokeColor: theme.colorScheme.surface,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                minY: 0,
                maxY: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecognitionsCard(ThemeData theme, List<Recognition> recognitions) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reconocimientos y logros', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          if (recognitions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Icon(Icons.emoji_events_rounded, size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                    const SizedBox(height: AppSpacing.md),
                    Text('Sin reconocimientos aún', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Tus logros aparecerán aquí', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recognitions.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
              itemBuilder: (context, index) {
                final recognition = recognitions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: recognition.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Icon(recognition.icon, color: recognition.color, size: 24),
                  ),
                  title: Text(recognition.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recognition.description, style: theme.textTheme.bodySmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(_formatDate(recognition.date), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: recognition.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppBorderRadius.full),
                    ),
                    child: Text(recognition.category, style: theme.textTheme.labelSmall?.copyWith(color: recognition.color, fontWeight: FontWeight.w600)),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAcademicHistoryCard(ThemeData theme) {
    final history = [
      AcademicHistoryItem('2023-2024', '5° Semestre', 'Ingeniería en Sistemas', 8.7, 'Cursando'),
      AcademicHistoryItem('2022-2023', '3°-4° Semestre', 'Ingeniería en Sistemas', 8.4, 'Completado'),
      AcademicHistoryItem('2021-2022', '1°-2° Semestre', 'Ingeniería en Sistemas', 8.9, 'Completado'),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Historial académico', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      item.period.split('°').first,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _getStatusColor(item.status),
                      ),
                    ),
                  ),
                ),
                title: Text(item.period, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.career, style: theme.textTheme.bodySmall),
                    Text(item.year, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.average.toStringAsFixed(1),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _getAverageColor(item.average),
                      ),
                    ),
                    AppBadge(
                      text: item.status,
                      variant: _getStatusBadgeVariant(item.status),
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

  Widget _buildSubjectProgressCard(ThemeData theme, List<Grade> grades) {
    final subjectProgress = _calculateSubjectProgress(grades);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progreso por materia', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjectProgress.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final progress = subjectProgress[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(progress.subjectName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      Text('${progress.percentage.toStringAsFixed(0)}%', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: _getAverageColor(progress.percentage))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  LinearProgressIndicator(
                    value: progress.percentage / 100,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(_getAverageColor(progress.percentage)),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(AppBorderRadius.full),
                  ),
                ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Cursando': return AppColors.primary;
      case 'Completado': return AppColors.success;
      default: return AppColors.onSurface;
    }
  }

  BadgeVariant _getStatusBadgeVariant(String status) {
    switch (status) {
      case 'Cursando': return BadgeVariant.standard;
      case 'Completado': return BadgeVariant.success;
      default: return BadgeVariant.neutral;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Map<int, double> _calculateSemesterAverages(List<Grade> grades) {
    // Mock data for semesters
    return {
      1: 8.9 * 10,
      2: 8.9 * 10,
      3: 8.4 * 10,
      4: 8.4 * 10,
      5: 8.7 * 10,
    };
  }

  List<Recognition> _getMockRecognitions() {
    return [
      Recognition('Primer lugar Hackathon', 'Ganador del Hackathon Universitario 2024', Icons.emoji_events_rounded, AppColors.warning, 'Competencia', DateTime(2024, 3, 15)),
      Recognition('Excelencia Académica', 'Promedio mayor a 9.0 en 3° semestre', Icons.star_rounded, AppColors.primary, 'Académico', DateTime(2023, 12, 20)),
      Recognition('Mejor Proyecto IA', 'Proyecto de clasificación de imágenes destacado', Icons.psychology_rounded, AppColors.info, 'Proyecto', DateTime(2024, 4, 10)),
      Recognition('Liderazgo Estudiantil', 'Presidente de la sociedad de computación', Icons.groups_rounded, AppColors.secondary, 'Liderazgo', DateTime(2023, 9, 1)),
    ];
  }

  List<SubjectProgress> _calculateSubjectProgress(List<Grade> grades) {
    final subjects = MockData.subjects;
    return subjects.map((subject) {
      final subjectGrades = grades.where((g) => g.subjectId == subject.id).toList();
      double avg = 0;
      if (subjectGrades.isNotEmpty) {
        final weightedSum = subjectGrades.fold<double>(0, (sum, g) => sum + (g.score / g.maxScore) * g.weight * 100);
        final totalWeight = subjectGrades.fold<double>(0, (sum, g) => sum + g.weight);
        avg = totalWeight > 0 ? weightedSum / totalWeight : 0;
      }
      return SubjectProgress(subject.name, avg);
    }).toList();
  }
}

class Recognition {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
  final DateTime date;

  Recognition(this.title, this.description, this.icon, this.color, this.category, this.date);
}

class AcademicHistoryItem {
  final String year;
  final String period;
  final String career;
  final double average;
  final String status;

  AcademicHistoryItem(this.year, this.period, this.career, this.average, this.status);
}

class SubjectProgress {
  final String subjectName;
  final double percentage;

  SubjectProgress(this.subjectName, this.percentage);
}