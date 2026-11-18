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
import '../../../../shared/widgets/app_input.dart';

class StudentRegistryScreen extends StatefulWidget {
  const StudentRegistryScreen({super.key});

  @override
  State<StudentRegistryScreen> createState() => _StudentRegistryScreenState();
}

class _StudentRegistryScreenState extends State<StudentRegistryScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String _selectedGroup = 'Todos';
  List<String> _groups = ['Todos'];

  @override
  void initState() {
    super.initState();
    _groups = ['Todos', ...MockData.groups.map((g) => g.name)];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    final filteredStudents = _getFilteredStudents();

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Registro de Alumnos',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Registro de Alumnos'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: Column(
          children: [
            _buildHeader(theme),
            _buildFilters(theme),
            Expanded(
              child: _buildStudentsList(theme, filteredStudents),
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
                Text('Directorio de Alumnos', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text('Lista completa de estudiantes', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          AppButton(label: 'Exportar', icon: Icons.download_rounded, variant: ButtonVariant.outlined, onPressed: () {}),
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
          Expanded(
            flex: 2,
            child: AppSearchField(
              controller: _searchController,
              hint: 'Buscar por nombre o código...',
              onChanged: (_) => setState(() {}),
              onClear: () => setState(() {}),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          DropdownButton<String>(
            value: _selectedGroup,
            items: _groups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (value) => setState(() => _selectedGroup = value!),
            underline: const SizedBox(),
            style: Theme.of(context).textTheme.bodyMedium,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList(ThemeData theme, List<User> students) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: AppSpacing.md),
            Text('No se encontraron alumnos', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text('Intenta con otros filtros de búsqueda', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return _buildStudentCard(theme, student);
      },
    );
  }

  List<User> _getFilteredStudents() {
    var filtered = MockData.students;

    if (_selectedGroup != 'Todos') {
      filtered = filtered.where((s) => s.group == _selectedGroup).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((s) =>
        s.fullName.toLowerCase().contains(query) ||
        s.id.toLowerCase().contains(query) ||
        s.curp.toLowerCase().contains(query)
      ).toList();
    }

    return filtered;
  }

  Widget _buildStudentCard(ThemeData theme, User student) {
    final avgGrade = _calculateStudentAverage(student.id);
    final attendanceRate = _calculateStudentAttendance(student.id);

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      onTap: () => context.go('${AppRouter.userProfile}/${student.id}'),
      child: Row(
        children: [
          AppAvatar(name: student.fullName, radius: 28, showBorder: true),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(student.fullName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    const SizedBox(width: AppSpacing.sm),
                    Text(student.id, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontFamily: 'monospace')),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text('${student.career} • ${student.group}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(width: AppSpacing.md),
                    AppChip(label: 'Promedio: ${avgGrade.toStringAsFixed(1)}', icon: Icons.grade_rounded, variant: ChipVariant.standard),
                    const SizedBox(width: AppSpacing.sm),
                    AppChip(label: 'Asistencia: ${attendanceRate.toStringAsFixed(0)}%', icon: Icons.how_to_reg_rounded, variant: ChipVariant.standard),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }

  double _calculateStudentAverage(String studentId) {
    // Mock calculation - in real app would filter by student
    return 8.5;
  }

  double _calculateStudentAttendance(String studentId) {
    // Mock calculation
    return 92.0;
  }
}