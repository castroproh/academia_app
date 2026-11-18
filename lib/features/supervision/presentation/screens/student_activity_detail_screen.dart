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

class StudentActivityDetailScreen extends StatefulWidget {
  final String studentId;

  const StudentActivityDetailScreen({super.key, required this.studentId});

  @override
  State<StudentActivityDetailScreen> createState() => _StudentActivityDetailScreenState();
}

class _StudentActivityDetailScreenState extends State<StudentActivityDetailScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User? _student;
  List<StudentActivity> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  void _loadStudentData() {
    try {
      _student = MockData.students.firstWhere((s) => s.id == widget.studentId);
      _activities = MockData.studentActivities.where((a) => a.studentId == widget.studentId).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      _student = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_student == null) {
      return Scaffold(
        appBar: AppTopBar(title: 'Actividad no encontrada'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
              const SizedBox(height: AppSpacing.md),
              Text('Estudiante no encontrado', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: 'Volver', icon: Icons.arrow_back_rounded, onPressed: () => context.pop()),
            ],
          ),
        ),
      );
    }

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: _student!.fullName,
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: _student!.fullName),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStudentHeader(theme),
                const SizedBox(height: AppSpacing.xl),
                _buildSummaryCards(theme),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTimeline(theme),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        children: [
                          _buildAppDistributionChart(theme),
                          const SizedBox(height: AppSpacing.lg),
                          _buildAppDetailsList(theme),
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

  Widget _buildStudentHeader(ThemeData theme) {
    return Row(
      children: [
        AppAvatar(name: _student!.fullName, radius: 40),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_student!.fullName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Text('${_student!.career} • ${_student!.group}', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              Text(_student!.institution, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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
              Text('Sesión actual', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.xs),
              Text('Inteligencia Artificial', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(ThemeData theme) {
    final totalTime = _activities.fold<Duration>(Duration.zero, (sum, a) => sum + a.duration);
    final allowedTime = _activities.where((a) => a.isAllowed).fold<Duration>(Duration.zero, (sum, a) => sum + a.duration);
    final notAllowedTime = _activities.where((a) => !a.isAllowed).fold<Duration>(Duration.zero, (sum, a) => sum + a.duration);
    final uniqueApps = _activities.map((a) => a.application).toSet().length;

    return Row(
      children: [
        Expanded(child: AppStatCard(label: 'Tiempo total', value: _formatDuration(totalTime), icon: Icons.timer_rounded, iconColor: theme.colorScheme.primary, backgroundColor: theme.colorScheme.primaryContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: AppStatCard(label: 'Apps permitidas', value: _formatDuration(allowedTime), icon: Icons.check_circle_rounded, iconColor: AppColors.success, backgroundColor: AppColors.successContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: AppStatCard(label: 'Apps no autorizadas', value: _formatDuration(notAllowedTime), icon: Icons.warning_rounded, iconColor: AppColors.error, backgroundColor: AppColors.errorContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: AppStatCard(label: 'Apps únicas', value: '$uniqueApps', icon: Icons.apps_rounded, iconColor: AppColors.info, backgroundColor: AppColors.infoContainer)),
      ],
    );
  }

  Widget _buildTimeline(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Línea de tiempo de actividad', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activities.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final activity = _activities[index];
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
                      if (index < _activities.length - 1)
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
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: isAllowed ? AppColors.successContainer : AppColors.errorContainer,
                                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                ),
                                child: Icon(
                                  isAllowed ? Icons.check_circle_rounded : Icons.block_rounded,
                                  size: 20,
                                  color: isAllowed ? AppColors.success : AppColors.error,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(child: Text(activity.application, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))),
                              Text(_formatTimeRange(activity.startTime, activity.endTime), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              AppBadge(
                                text: isAllowed ? 'Permitida' : 'No autorizada',
                                variant: isAllowed ? BadgeVariant.success : BadgeVariant.error,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              AppChip(
                                label: 'Duración: ${activity.duration.inMinutes} min',
                                icon: Icons.timer_outlined,
                                variant: ChipVariant.standard,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              AppChip(
                                label: activity.category,
                                icon: Icons.category_outlined,
                                variant: ChipVariant.standard,
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

  Widget _buildAppDistributionChart(ThemeData theme) {
    final appUsage = <String, int>{};
    for (final activity in _activities) {
      appUsage[activity.application] = (appUsage[activity.application] ?? 0) + activity.duration.inMinutes;
    }
    final sortedApps = appUsage.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Distribución de tiempo por app', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: sortedApps.map((entry) {
                  final isAllowed = AppConstants.allowedApplications.contains(entry.key);
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    color: isAllowed ? AppColors.success : AppColors.error,
                    title: '',
                    radius: 70,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: sortedApps.map((entry) {
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

  Widget _buildAppDetailsList(ThemeData theme) {
    final appUsage = <String, List<StudentActivity>>{};
    for (final activity in _activities) {
      appUsage.putIfAbsent(activity.application, () => []).add(activity);
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detalle por aplicación', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appUsage.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final entry = appUsage.entries.elementAt(index);
              final appName = entry.key;
              final activities = entry.value;
              final isAllowed = AppConstants.allowedApplications.contains(appName);
              final totalMinutes = activities.fold<int>(0, (sum, a) => sum + a.duration.inMinutes);
              final sessions = activities.length;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (isAllowed ? AppColors.success : AppColors.error).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Icon(
                    isAllowed ? Icons.check_circle_rounded : Icons.block_rounded,
                    color: isAllowed ? AppColors.success : AppColors.error,
                    size: 22,
                  ),
                ),
                title: Text(appName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text('$sessions sesiones • $totalMinutes min total', style: theme.textTheme.bodySmall),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppBadge(
                      text: isAllowed ? 'Permitida' : 'No autorizada',
                      variant: isAllowed ? BadgeVariant.success : BadgeVariant.error,
                    ),
                    Text('${activities.first.category}', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
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

  String _formatTimeRange(DateTime start, DateTime end) {
    return '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }
}