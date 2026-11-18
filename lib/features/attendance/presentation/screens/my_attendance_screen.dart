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

class MyAttendanceScreen extends StatefulWidget {
  const MyAttendanceScreen({super.key});

  @override
  State<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends State<MyAttendanceScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedSubject = 'Todas';
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);

    final studentAttendance = MockData.attendanceRecords;
    final studentSubjects = MockData.subjects.where((s) => s.group == user.group).toList();
    final subjects = ['Todas', ...studentSubjects.map((s) => s.name)];
    
    final filteredAttendance = _selectedSubject == 'Todas'
        ? studentAttendance
        : studentAttendance.where((a) => a.subjectName == _selectedSubject).toList();

    final monthlyAttendance = filteredAttendance.where((a) => 
      a.date.month == _selectedMonth.month && a.date.year == _selectedMonth.year).toList();

    final attendanceRate = _calculateAttendanceRate(filteredAttendance);
    final present = filteredAttendance.where((a) => a.status == AttendanceStatus.present).length;
    final late = filteredAttendance.where((a) => a.status == AttendanceStatus.late).length;
    final absent = filteredAttendance.where((a) => a.status == AttendanceStatus.absent).length;
    final justified = filteredAttendance.where((a) => a.status == AttendanceStatus.justified).length;

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Asistencia',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Asistencia'),
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
                _buildStatsRow(theme, attendanceRate, present, late, absent, justified),
                const SizedBox(height: AppSpacing.lg),
                _buildMonthlyCalendar(theme, monthlyAttendance),
                const SizedBox(height: AppSpacing.lg),
                _buildAttendanceList(theme, filteredAttendance),
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
              Text('Mi Asistencia', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Text('Registro de asistencias y ausencias', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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

  Widget _buildStatsRow(ThemeData theme, double rate, int present, int late, int absent, int justified) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(theme, 'Asistencia', '${rate.toStringAsFixed(0)}%', Icons.how_to_reg_rounded, AppColors.success, AppColors.successContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildStatCard(theme, 'Presentes', '$present', Icons.check_circle_rounded, AppColors.success, AppColors.successContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildStatCard(theme, 'Retardos', '$late', Icons.access_time_rounded, AppColors.warning, AppColors.warningContainer)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildStatCard(theme, 'Ausentes', '$absent', Icons.cancel_rounded, AppColors.error, AppColors.errorContainer)),
      ],
    );
  }

  Widget _buildStatCard(ThemeData theme, String label, String value, IconData icon, Color color, Color bgColor) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(AppBorderRadius.md)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: color)),
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildMonthlyCalendar(ThemeData theme, List<AttendanceRecord> records) {
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_selectedMonth.year, _selectedMonth.month, 1).weekday;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Calendario de ${_getMonthName(_selectedMonth.month)} ${_selectedMonth.year}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              Row(
                children: [
                  IconButton(onPressed: () => setState(() => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1)), icon: const Icon(Icons.chevron_left)),
                  IconButton(onPressed: () => setState(() => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1)), icon: const Icon(Icons.chevron_right)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
            itemCount: firstWeekday - 1 + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) {
                return const SizedBox.shrink();
              }
              final day = index - firstWeekday + 2;
              final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
              final record = records.where((r) => r.date.day == day && r.date.month == _selectedMonth.month && r.date.year == _selectedMonth.year).firstOrNull;
              return _buildCalendarDay(theme, day, record);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _buildLegend(theme),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(ThemeData theme, int day, AttendanceRecord? record) {
    Color? bgColor;
    if (record != null) {
      switch (record.status) {
        case AttendanceStatus.present: bgColor = AppColors.success.withValues(alpha: 0.2); break;
        case AttendanceStatus.late: bgColor = AppColors.warning.withValues(alpha: 0.2); break;
        case AttendanceStatus.absent: bgColor = AppColors.error.withValues(alpha: 0.2); break;
        case AttendanceStatus.justified: bgColor = AppColors.info.withValues(alpha: 0.2); break;
      }
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Center(
        child: Text('$day', style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: record != null ? _getStatusColor(record.status) : theme.colorScheme.onSurface,
        )),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        _buildLegendItem(theme, 'Presente', AppColors.success),
        _buildLegendItem(theme, 'Retardo', AppColors.warning),
        _buildLegendItem(theme, 'Ausente', AppColors.error),
        _buildLegendItem(theme, 'Justificado', AppColors.info),
      ],
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }

  Widget _buildAttendanceList(ThemeData theme, List<AttendanceRecord> records) {
    if (records.isEmpty) {
      return AppCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Icon(Icons.how_to_reg_rounded, size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                const SizedBox(height: AppSpacing.md),
                Text('Sin registros de asistencia', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      );
    }

    final grouped = <String, List<AttendanceRecord>>{};
    for (final record in records) {
      final key = '${record.subjectName}';
      grouped.putIfAbsent(key, () => []).add(record);
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Historial detallado', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: grouped.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final subjectName = grouped.keys.elementAt(index);
              final subjectRecords = grouped[subjectName]!;
              return ExpansionTile(
                title: Text(subjectName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text('${subjectRecords.length} sesiones', style: theme.textTheme.bodySmall),
                children: subjectRecords.map((record) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getStatusColor(record.status).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getStatusIcon(record.status), size: 16, color: _getStatusColor(record.status)),
                  ),
                  title: Text(_formatDate(record.date), style: theme.textTheme.bodyMedium),
                  subtitle: Text(record.teacherName, style: theme.textTheme.bodySmall),
                  trailing: AppBadge(
                    text: _getStatusLabel(record.status),
                    variant: _getStatusBadgeVariant(record.status),
                  ),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present: return AppColors.success;
      case AttendanceStatus.late: return AppColors.warning;
      case AttendanceStatus.absent: return AppColors.error;
      case AttendanceStatus.justified: return AppColors.info;
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present: return Icons.check_rounded;
      case AttendanceStatus.late: return Icons.access_time_rounded;
      case AttendanceStatus.absent: return Icons.close_rounded;
      case AttendanceStatus.justified: return Icons.verified_rounded;
    }
  }

  String _getStatusLabel(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present: return 'Presente';
      case AttendanceStatus.late: return 'Retardo';
      case AttendanceStatus.absent: return 'Ausente';
      case AttendanceStatus.justified: return 'Justificado';
    }
  }

  BadgeVariant _getStatusBadgeVariant(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present: return BadgeVariant.success;
      case AttendanceStatus.late: return BadgeVariant.warning;
      case AttendanceStatus.absent: return BadgeVariant.error;
      case AttendanceStatus.justified: return BadgeVariant.info;
    }
  }

  String _getMonthName(int month) {
    const months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  double _calculateAttendanceRate(List<AttendanceRecord> records) {
    if (records.isEmpty) return 100;
    final attended = records.where((r) => r.status == AttendanceStatus.present || r.status == AttendanceStatus.late || r.status == AttendanceStatus.justified).length;
    return (attended / records.length) * 100;
  }
}