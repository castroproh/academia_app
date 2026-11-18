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

class MyClassesScreen extends StatefulWidget {
  const MyClassesScreen({super.key});

  @override
  State<MyClassesScreen> createState() => _MyClassesScreenState();
}

class _MyClassesScreenState extends State<MyClassesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);

    final studentSubjects = MockData.subjects.where((s) => s.group == user.group).toList();

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Mis Clases',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Mis Clases'),
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
                if (studentSubjects.isEmpty)
                  _buildEmptyState(theme)
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.isMobile ? 1 : context.isTablet ? 2 : 3,
                      crossAxisSpacing: AppSpacing.lg,
                      mainAxisSpacing: AppSpacing.lg,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: studentSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = studentSubjects[index];
                      return _buildSubjectCard(theme, subject);
                    },
                  ),
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
              Text('Mis Clases', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Text('Tus materias del semestre actual', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(ThemeData theme, Subject subject) {
    return AppCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [subject.color, subject.color.withValues(alpha: 0.7)],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppBorderRadius.lg)),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  subject.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subject.code,
                  style: theme.textTheme.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(theme, Icons.person_outline, subject.teacherName),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(theme, Icons.group_outlined, subject.group),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(theme, Icons.schedule_outlined, subject.schedule),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(theme, Icons.meeting_room_outlined, subject.classroom),
          const Spacer(),
          Row(
            children: [
              AppChip(
                label: '${subject.credits} créditos',
                icon: Icons.star_outline,
                variant: ChipVariant.standard,
              ),
              const Spacer(),
              AppButton(
                label: 'Entrar',
                icon: Icons.arrow_forward_rounded,
                variant: ButtonVariant.tonal,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              Icon(Icons.class_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
              const SizedBox(height: AppSpacing.md),
              Text('No tienes materias asignadas', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.xs),
              Text('Las materias aparecerán aquí cuando estés inscrito', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}