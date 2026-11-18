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

class EvaluationManagementScreen extends StatefulWidget {
  const EvaluationManagementScreen({super.key});

  @override
  State<EvaluationManagementScreen> createState() => _EvaluationManagementScreenState();
}

class _EvaluationManagementScreenState extends State<EvaluationManagementScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedSubject = 'Todas';
  String _selectedPeriod = '2024-1';
  List<String> _subjects = ['Todas'];

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

    final teacherEvaluations = MockData.evaluations.where((e) => e.teacherId == user.id).toList();
    final filteredEvaluations = _selectedSubject == 'Todas'
        ? teacherEvaluations
        : teacherEvaluations.where((e) {
            final subject = MockData.subjects.firstWhere((s) => s.id == e.subjectId);
            return subject.name == _selectedSubject;
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
                title: 'Gestión de Evaluaciones',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Gestión de Evaluaciones'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: Column(
          children: [
            _buildHeader(theme),
            _buildFilters(theme),
            Expanded(
              child: _buildEvaluationsList(theme, filteredEvaluations),
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
                Text('Evaluaciones', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text('Crea y gestiona evaluaciones para tus materias', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          AppButton(label: 'Nueva evaluación', icon: Icons.add_rounded, variant: ButtonVariant.filled, onPressed: () => _showCreateEvaluationDialog(context)),
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
            value: _selectedPeriod,
            items: ['2024-1', '2023-2', '2023-1'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (value) => setState(() => _selectedPeriod = value!),
            underline: const SizedBox(),
            style: theme.textTheme.bodyMedium,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationsList(ThemeData theme, List<Evaluation> evaluations) {
    if (evaluations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: AppSpacing.md),
            Text('Sin evaluaciones', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text('Crea tu primera evaluación', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.md),
            AppButton(label: 'Crear evaluación', icon: Icons.add_rounded, variant: ButtonVariant.filled, onPressed: () => _showCreateEvaluationDialog(context)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: evaluations.length,
      itemBuilder: (context, index) {
        final evaluation = evaluations[index];
        final subject = MockData.subjects.firstWhere((s) => s.id == evaluation.subjectId);
        return _buildEvaluationCard(theme, evaluation, subject);
      },
    );
  }

  Widget _buildEvaluationCard(ThemeData theme, Evaluation evaluation, Subject subject) {
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
                child: Icon(Icons.assignment_rounded, color: subject.color, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(evaluation.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    Text(subject.name, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppBadge(
                    text: evaluation.type.name.toUpperCase(),
                    variant: _getTypeBadgeVariant(evaluation.type),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Peso: ${(evaluation.weight * 100).toInt()}%', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(evaluation.description, style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppChip(label: 'Máx: ${evaluation.maxScore.toInt()}', icon: Icons.star_outline, variant: ChipVariant.standard),
              const SizedBox(width: AppSpacing.sm),
              AppChip(label: 'Criterios: ${evaluation.criteria.length}', icon: Icons.list_alt_outlined, variant: ChipVariant.standard),
              const Spacer(),
              Text(_formatDate(evaluation.date), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppButton(label: 'Ver detalles', icon: Icons.visibility_outlined, variant: ButtonVariant.text, onPressed: () {}),
              AppButton(label: 'Editar', icon: Icons.edit_outlined, variant: ButtonVariant.text, onPressed: () {}),
              AppButton(label: 'Calificar', icon: Icons.grade_outlined, variant: ButtonVariant.filled, onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  BadgeVariant _getTypeBadgeVariant(EvaluationType type) {
    switch (type) {
      case EvaluationType.exam: return BadgeVariant.standard;
      case EvaluationType.homework: return BadgeVariant.info;
      case EvaluationType.project: return BadgeVariant.success;
      case EvaluationType.participation: return BadgeVariant.warning;
      case EvaluationType.quiz: return BadgeVariant.neutral;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showCreateEvaluationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear evaluación'),
        content: const Text('Esta es una funcionalidad de demostración. En la versión final, podrás crear nuevas evaluaciones con criterios, ponderaciones y fechas.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido')),
        ],
      ),
    );
  }
}