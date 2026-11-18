import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

class ClassSessionsScreen extends StatefulWidget {
  const ClassSessionsScreen({super.key});

  @override
  State<ClassSessionsScreen> createState() => _ClassSessionsScreenState();
}

class _ClassSessionsScreenState extends State<ClassSessionsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedSubject = 'Todas';
  String _selectedStatus = 'Todas';
  List<String> _subjects = ['Todas'];
  final List<String> _statuses = ['Todas', 'Programada', 'En curso', 'Completada', 'Cancelada'];

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser!;
    _subjects = ['Todas', ...MockData.subjects.where((s) => s.teacherId == user.id).map((s) => s.name)];
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);

    final teacherSessions = MockData.sessions.where((s) => s.teacherId == user.id).toList();
    final filteredSessions = teacherSessions.where((s) {
      final subject = MockData.subjects.firstWhere((sub) => sub.id == s.subjectId);
      final subjectMatch = _selectedSubject == 'Todas' || subject.name == _selectedSubject;
      final statusMatch = _selectedStatus == 'Todas' || _getStatusLabel(s.status) == _selectedStatus;
      return subjectMatch && statusMatch;
    }).toList();

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Sesiones de Clase',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Sesiones de Clase'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: Column(
          children: [
            _buildHeader(theme),
            _buildFilters(theme),
            Expanded(
              child: _buildSessionsList(theme, filteredSessions),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sesiones de Clase', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text('Programa y gestiona tus sesiones', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          AppButton(label: 'Nueva sesión', icon: Icons.add_rounded, variant: ButtonVariant.filled, onPressed: () => _showCreateSessionDialog(context)),
        ],
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          DropdownButton<String>(
            value: _selectedSubject,
            items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (value) => setState(() => _selectedSubject = value!),
            underline: const SizedBox(),
            style: theme.textTheme.bodyMedium,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          const SizedBox(width: AppSpacing.md),
          DropdownButton<String>(
            value: _selectedStatus,
            items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (value) => setState(() => _selectedStatus = value!),
            underline: const SizedBox(),
            style: theme.textTheme.bodyMedium,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList(ThemeData theme, List<Session> sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_call_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: AppSpacing.md),
            Text('Sin sesiones', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text('Programa tu primera sesión de clase', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.md),
            AppButton(label: 'Crear sesión', icon: Icons.add_rounded, variant: ButtonVariant.filled, onPressed: () => _showCreateSessionDialog(context)),
          ],
        ),
      );
    }

    final grouped = <DateTime, List<Session>>{};
    for (final session in sessions) {
      final date = DateTime(session.startTime.year, session.startTime.month, session.startTime.day);
      grouped.putIfAbsent(date, () => []).add(session);
    }
    final sortedDates = grouped.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final daySessions = grouped[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(_formatDateHeader(date), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
            ),
            ...daySessions.map((session) => _buildSessionCard(theme, session)),
            const SizedBox(height: AppSpacing.lg),
          ],
        );
      },
    );
  }

  Widget _buildSessionCard(ThemeData theme, Session session) {
    final subject = MockData.subjects.firstWhere((s) => s.id == session.subjectId);
    final statusColor = _getStatusColor(session.status);

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: subject.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Icon(Icons.book_rounded, color: subject.color, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(subject.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                        const SizedBox(width: AppSpacing.sm),
                        AppBadge(text: session.group, variant: BadgeVariant.neutral),
                      ],
                    ),
                    Text('${session.topic ?? 'Sin tema'} • ${session.classroom}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppBadge(
                    text: _getStatusLabel(session.status),
                    variant: _getStatusBadgeVariant(session.status),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${_formatTime(session.startTime)} - ${_formatTime(session.endTime)}',
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppButton(
                label: '${session.studentIds.length} alumnos',
                icon: Icons.people_outline,
                variant: ButtonVariant.text,
                onPressed: () => _showStudentsDialog(context, session),
              ),
              const Spacer(),
              _buildActionButtons(theme, session),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, Session session) {
    switch (session.status) {
      case SessionStatus.scheduled:
        return Row(
          children: [
            AppButton(label: 'Iniciar', icon: Icons.play_arrow_rounded, variant: ButtonVariant.filled, onPressed: () {}),
            const SizedBox(width: AppSpacing.sm),
            AppButton(label: 'Cancelar', icon: Icons.cancel_outlined, variant: ButtonVariant.outlined, onPressed: () {}),
          ],
        );
      case SessionStatus.inProgress:
        return Row(
          children: [
            AppButton(label: 'Supervisar', icon: Icons.supervisor_account_rounded, variant: ButtonVariant.filled, onPressed: () => context.go(AppRouter.supervisionDashboard)),
            const SizedBox(width: AppSpacing.sm),
            AppButton(label: 'Finalizar', icon: Icons.stop_rounded, variant: ButtonVariant.outlined, onPressed: () {}),
          ],
        );
      case SessionStatus.completed:
        return AppButton(label: 'Ver reporte', icon: Icons.analytics_outlined, variant: ButtonVariant.filled, onPressed: () {});
      case SessionStatus.cancelled:
        return AppButton(label: 'Reprogramar', icon: Icons.schedule_outlined, variant: ButtonVariant.tonal, onPressed: () {});
    }
  }

  String _getStatusLabel(SessionStatus status) {
    switch (status) {
      case SessionStatus.scheduled: return 'Programada';
      case SessionStatus.inProgress: return 'En curso';
      case SessionStatus.completed: return 'Completada';
      case SessionStatus.cancelled: return 'Cancelada';
    }
  }

  Color _getStatusColor(SessionStatus status) {
    switch (status) {
      case SessionStatus.scheduled: return AppColors.primary;
      case SessionStatus.inProgress: return AppColors.info;
      case SessionStatus.completed: return AppColors.success;
      case SessionStatus.cancelled: return AppColors.error;
    }
  }

  BadgeVariant _getStatusBadgeVariant(SessionStatus status) {
    switch (status) {
      case SessionStatus.scheduled: return BadgeVariant.standard;
      case SessionStatus.inProgress: return BadgeVariant.info;
      case SessionStatus.completed: return BadgeVariant.success;
      case SessionStatus.cancelled: return BadgeVariant.error;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) return 'Hoy';
    if (sessionDate == tomorrow) return 'Mañana';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showCreateSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear sesión'),
        content: const Text('Esta es una funcionalidad de demostración. En la versión final, podrás programar nuevas sesiones de clase.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido')),
        ],
      ),
    );
  }

  void _showStudentsDialog(BuildContext context, Session session) {
    final students = MockData.students.where((s) => session.studentIds.contains(s.id)).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alumnos - ${session.subjectName}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: AppAvatar(name: student.fullName, radius: 20),
                title: Text(student.fullName),
                subtitle: Text(student.group),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }
}