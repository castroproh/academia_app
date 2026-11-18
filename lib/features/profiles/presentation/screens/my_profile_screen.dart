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

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser!;
    _nameController.text = user.fullName;
    _emailController.text = user.email;
    _phoneController.text = user.phone;
    _descriptionController.text = user.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);

    return ResponsiveLayout(
      showSidebar: !context.isMobile,
      showBottomNav: context.isMobile,
      sidebar: AppSidebar(isCollapsed: false),
      bottomNavigation: context.isMobile ? const AppBottomNavigation() : null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: context.isMobile
            ? AppTopBar(
                title: 'Mi Perfil',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Mi Perfil'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(theme, user),
                const SizedBox(height: AppSpacing.xl),
                _buildProfileForm(theme, user),
                const SizedBox(height: AppSpacing.xl),
                _buildLinkedAccountsCard(theme),
                const SizedBox(height: AppSpacing.xl),
                _buildLogoutButton(theme, authProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, User user) {
    return AppCard(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              AppAvatar(name: user.fullName, radius: 60),
              if (_isEditing)
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.surface, width: 3),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt_rounded, color: theme.colorScheme.onPrimary, size: 20),
                    onPressed: () {},
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            user.fullName,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${user.career} • ${user.group}',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            user.institution,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: _isEditing ? 'Guardar cambios' : 'Editar perfil',
            icon: _isEditing ? Icons.save_rounded : Icons.edit_rounded,
            variant: _isEditing ? ButtonVariant.filled : ButtonVariant.outlined,
            onPressed: () {
              setState(() => _isEditing = !_isEditing);
              if (!_isEditing) {
                _saveProfile();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(ThemeData theme, User user) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información personal', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(theme, Icons.badge_outlined, 'CURP', user.curp, readOnly: true),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(theme, Icons.person_outline, 'Código único', user.id, readOnly: true),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _nameController,
            label: 'Nombre completo',
            enabled: _isEditing,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _emailController,
            label: 'Correo electrónico',
            enabled: _isEditing,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _phoneController,
            label: 'Teléfono',
            enabled: _isEditing,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextArea(
            controller: _descriptionController,
            label: 'Descripción personal',
            hint: 'Cuéntanos sobre ti...',
            enabled: _isEditing,
            minLines: 3,
            maxLines: 5,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildInfoCard(theme, 'Institución', user.institution, Icons.school_outlined),
          const SizedBox(height: AppSpacing.md),
          _buildInfoCard(theme, 'Carrera', user.career, Icons.menu_book_outlined),
          const SizedBox(height: AppSpacing.md),
          _buildInfoCard(theme, 'Grupo', user.group, Icons.group_outlined),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String label, String value, {bool readOnly = false}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: readOnly ? FontWeight.w500 : FontWeight.w400)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(ThemeData theme, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedAccountsCard(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cuentas vinculadas', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          _buildLinkedAccountItem(theme, Icons.email_outlined, 'Correo institucional', 'maria.gonzalez@estudiante.edu.mx', true),
          const SizedBox(height: AppSpacing.md),
          _buildLinkedAccountItem(theme, Icons.g_mobiledata, 'Google', 'maria.gonzalez@gmail.com', false),
          const SizedBox(height: AppSpacing.md),
          _buildLinkedAccountItem(theme, Icons.code_outlined, 'GitHub', '@mariagonzalez', false),
        ],
      ),
    );
  }

  Widget _buildLinkedAccountItem(ThemeData theme, IconData icon, String provider, String account, bool isPrimary) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          child: Icon(icon, size: 24, color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(provider, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              Text(account, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        if (isPrimary)
          AppBadge(text: 'Principal', variant: BadgeVariant.standard)
        else
          AppButton(label: 'Vincular', variant: ButtonVariant.text, onPressed: () {}),
      ],
    );
  }

  Widget _buildLogoutButton(ThemeData theme, AuthProvider authProvider) {
    return AppButton(
      label: 'Cerrar sesión',
      icon: Icons.logout_rounded,
      variant: ButtonVariant.outlined,
      isFullWidth: true,
      onPressed: () => _showLogoutDialog(context, authProvider),
    );
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Perfil actualizado correctamente')),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(onPressed: () { Navigator.pop(context); authProvider.logout(); }, child: const Text('Cerrar sesión')),
        ],
      ),
    );
  }
}