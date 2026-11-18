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

class TeacherGroupsScreen extends StatefulWidget {
  const TeacherGroupsScreen({super.key});

  @override
  State<TeacherGroupsScreen> createState() => _TeacherGroupsScreenState();
}

class _TeacherGroupsScreenState extends State<TeacherGroupsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);

    final teacherGroups = MockData.groups.where((g) => g.tutorId == user.id).toList();
    final allGroups = MockData.groups;

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Mis Grupos',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Mis Grupos'),
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
                _buildMyGroupsSection(theme, teacherGroups),
                const SizedBox(height: AppSpacing.xl),
                _buildAllGroupsSection(theme, allGroups),
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
              Text('Grupos', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Text('Gestiona tus grupos y tutorías', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        AppButton(label: 'Nuevo grupo', icon: Icons.add_rounded, variant: ButtonVariant.filled, onPressed: () {}),
      ],
    );
  }

  Widget _buildMyGroupsSection(ThemeData theme, List<Group> groups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Grupos a mi cargo', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.md),
        if (groups.isEmpty)
          AppCard(child: Center(child: Padding(padding: const EdgeInsets.all(AppSpacing.xl), child: Column(children: [Icon(Icons.groups_rounded, size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)), const SizedBox(height: AppSpacing.md), Text('No tienes grupos asignados', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))]))))
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: context.isMobile ? 1 : context.isTablet ? 2 : 3, crossAxisSpacing: AppSpacing.lg, mainAxisSpacing: AppSpacing.lg, childAspectRatio: 1.4),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return _buildGroupCard(theme, group, true);
            },
          ),
      ],
    );
  }

  Widget _buildAllGroupsSection(ThemeData theme, List<Group> groups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Todos los grupos', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groups.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final group = groups[index];
            return _buildGroupCard(theme, group, false);
          },
        ),
      ],
    );
  }

  Widget _buildGroupCard(ThemeData theme, Group group, bool isMyGroup) {
    final tutor = MockData.teachers.firstWhere((t) => t.id == group.tutorId);
    final subjects = MockData.subjects.where((s) => group.subjectIds.contains(s.id)).toList();

    return AppCard(
      onTap: () => context.go('${AppRouter.teacherGroups}/${group.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                ),
                child: Center(child: Text(group.name.split('°').first, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(group.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(width: AppSpacing.sm),
                        if (isMyGroup) AppBadge(text: 'Tutor', variant: BadgeVariant.success),
                      ],
                    ),
                    Text(group.career, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${group.studentCount} alumnos', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  Text('Semestre ${group.semester}', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _buildInfoChip(theme, Icons.person_outline, 'Tutor', tutor.fullName)),
              Expanded(child: _buildInfoChip(theme, Icons.class_outlined, 'Materias', '${subjects.length}')),
            ],
          ),
          if (subjects.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: subjects.map((s) => AppChip(label: s.name, icon: Icons.book_outlined, variant: ChipVariant.standard)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            Text(value, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}