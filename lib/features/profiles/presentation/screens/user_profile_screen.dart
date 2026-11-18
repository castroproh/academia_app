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

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final allUsers = [...MockData.students, ...MockData.teachers];
    try {
      _user = allUsers.firstWhere((u) => u.id == widget.userId);
    } catch (e) {
      _user = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_user == null) {
      return Scaffold(
        appBar: AppTopBar(title: 'Perfil no encontrado'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
              const SizedBox(height: AppSpacing.md),
              Text('Usuario no encontrado', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: 'Volver', icon: Icons.arrow_back_rounded, onPressed: () => context.pop()),
            ],
          ),
        ),
      );
    }

    final user = _user!;
    final isCurrentUser = context.read<AuthProvider>().currentUser?.id == user.id;

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: user.fullName,
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: user.fullName),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(theme, user, isCurrentUser),
                const SizedBox(height: AppSpacing.xl),
                _buildInfoSection(theme, user),
                const SizedBox(height: AppSpacing.xl),
                if (user.role == UserRole.student) ...[
                  _buildAcademicInfoCard(theme, user),
                  const SizedBox(height: AppSpacing.xl),
                ],
                _buildDescriptionCard(theme, user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, User user, bool isCurrentUser) {
    return AppCard(
      child: Column(
        children: [
          AppAvatar(name: user.fullName, radius: 60),
          const SizedBox(height: AppSpacing.md),
          Text(user.fullName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBadge(
                text: user.role == UserRole.student ? 'Alumno' : 'Docente',
                variant: user.role == UserRole.student ? BadgeVariant.info : BadgeVariant.standard,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(user.institution, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          if (user.role == UserRole.student) ...[
            const SizedBox(height: AppSpacing.xs),
            Text('${user.career} • ${user.group}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          ] else ...[
            const SizedBox(height: AppSpacing.xs),
            Text(user.career, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          ],
          if (!isCurrentUser) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Enviar mensaje',
              icon: Icons.message_outlined,
              variant: ButtonVariant.filled,
              onPressed: () {},
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, User user) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información de contacto', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(theme, Icons.email_outlined, 'Correo electrónico', user.email),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(theme, Icons.phone_outlined, 'Teléfono', user.phone.isNotEmpty ? user.phone : 'No registrado'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(theme, Icons.badge_outlined, 'CURP', user.curp),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(theme, Icons.person_outline, 'Código único', user.id),
        ],
      ),
    );
  }

  Widget _buildInfoItem(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicInfoCard(ThemeData theme, User user) {
    final subjects = MockData.subjects.where((s) => s.group == user.group).toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información académica', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(theme, Icons.menu_book_outlined, 'Carrera', user.career),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(theme, Icons.group_outlined, 'Grupo', user.group),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(theme, Icons.calendar_today_outlined, 'Semestre', _getSemesterFromGroup(user.group)),
          const SizedBox(height: AppSpacing.lg),
          Text('Materias inscritas (${subjects.length})', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: subjects.map((s) => AppChip(
              label: s.name,
              icon: Icons.book_outlined,
              variant: ChipVariant.standard,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(ThemeData theme, User user) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Descripción', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          Text(
            user.description.isNotEmpty ? user.description : 'Sin descripción disponible',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: user.description.isNotEmpty ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
              fontStyle: user.description.isNotEmpty ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _getSemesterFromGroup(String group) {
    final match = RegExp(r'(\d+)°').firstMatch(group);
    return match != null ? '${match.group(1)}° Semestre' : 'Desconocido';
  }
}