import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../features/authentication/presentation/providers/auth_provider.dart';
import '../../../../models/academic_models.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../../../../shared/widgets/app_sidebar.dart';
import '../../../../shared/widgets/app_bottom_navigation.dart';
import '../../../../shared/widgets/responsive_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Settings state
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _gradeNotifications = true;
  bool _attendanceNotifications = true;
  bool _sessionNotifications = true;
  bool _privacyProfile = true;
  bool _privacyActivity = false;
  bool _privacyGrades = false;
  String _language = 'Español';
  String _theme = 'Sistema';

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
                title: 'Configuración',
                onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : AppTopBar(title: 'Configuración'),
        drawer: context.isMobile ? AppSidebar(isCollapsed: false) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAccountSection(theme, user),
                const SizedBox(height: AppSpacing.xl),
                _buildAppearanceSection(theme),
                const SizedBox(height: AppSpacing.xl),
                _buildNotificationsSection(theme),
                const SizedBox(height: AppSpacing.xl),
                _buildPrivacySection(theme),
                const SizedBox(height: AppSpacing.xl),
                _buildHelpSection(theme),
                const SizedBox(height: AppSpacing.xl),
                _buildLogoutButton(theme, authProvider),
                const SizedBox(height: AppSpacing.xl),
                _buildVersionInfo(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(ThemeData theme, User user) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cuenta', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          _buildAccountItem(theme, Icons.person_outline, 'Nombre', user.fullName, onTap: () {}),
          _buildAccountItem(theme, Icons.email_outlined, 'Correo', user.email, onTap: () {}),
          _buildAccountItem(theme, Icons.phone_outlined, 'Teléfono', user.phone.isNotEmpty ? user.phone : 'No configurado', onTap: () {}),
          _buildAccountItem(theme, Icons.badge_outlined, 'CURP', user.curp, readOnly: true),
          _buildAccountItem(theme, Icons.school_outlined, 'Institución', user.institution, readOnly: true),
          _buildAccountItem(theme, Icons.menu_book_outlined, 'Carrera', user.career, readOnly: true),
          _buildAccountItem(theme, Icons.group_outlined, 'Grupo', user.group, readOnly: true),
        ],
      ),
    );
  }

  Widget _buildAccountItem(ThemeData theme, IconData icon, String label, String value, {bool readOnly = false, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: readOnly ? null : onTap,
      leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      title: Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      subtitle: Text(value, style: theme.textTheme.bodyMedium),
      trailing: readOnly ? null : Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildAppearanceSection(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Apariencia', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          _buildSettingTile(
            theme,
            Icons.dark_mode_outlined,
            'Tema oscuro',
            'Activa el modo oscuro en la aplicación',
            trailing: Switch(
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
            ),
          ),
          _buildSettingTile(
            theme,
            Icons.palette_outlined,
            'Tema de color',
            'Selecciona el tema de color de la app',
            trailing: DropdownButton<String>(
              value: _theme,
              items: ['Sistema', 'Claro', 'Oscuro'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (value) => setState(() => _theme = value!),
              underline: const SizedBox(),
            ),
          ),
          _buildSettingTile(
            theme,
            Icons.language_outlined,
            'Idioma',
            'Cambia el idioma de la interfaz',
            trailing: DropdownButton<String>(
              value: _language,
              items: ['Español', 'English'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (value) => setState(() => _language = value!),
              underline: const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notificaciones', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          _buildSettingTile(
            theme,
            Icons.notifications_outlined,
            'Notificaciones activas',
            'Recibe notificaciones de la aplicación',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
            ),
          ),
          if (_notificationsEnabled) ...[
            _buildSettingTile(
              theme,
              Icons.email_outlined,
              'Notificaciones por correo',
              'Recibe actualizaciones importantes por email',
              trailing: Switch(
                value: _emailNotifications,
                onChanged: (value) => setState(() => _emailNotifications = value),
              ),
            ),
            _buildSettingTile(
              theme,
              Icons.phone_android_outlined,
              'Notificaciones push',
              'Recibe alertas en tiempo real en tu dispositivo',
              trailing: Switch(
                value: _pushNotifications,
                onChanged: (value) => setState(() => _pushNotifications = value),
              ),
            ),
            const Divider(),
            Text('Tipos de notificaciones', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
            _buildSettingTile(
              theme,
              Icons.grade_outlined,
              'Calificaciones',
              'Nuevas calificaciones publicadas',
              trailing: Switch(
                value: _gradeNotifications,
                onChanged: (value) => setState(() => _gradeNotifications = value),
              ),
            ),
            _buildSettingTile(
              theme,
              Icons.how_to_reg_outlined,
              'Asistencia',
              'Alertas de ausencias y retardos',
              trailing: Switch(
                value: _attendanceNotifications,
                onChanged: (value) => setState(() => _attendanceNotifications = value),
              ),
            ),
            _buildSettingTile(
              theme,
              Icons.video_call_outlined,
              'Sesiones de clase',
              'Recordatorios de clases programadas',
              trailing: Switch(
                value: _sessionNotifications,
                onChanged: (value) => setState(() => _sessionNotifications = value),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivacySection(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Privacidad', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          _buildSettingTile(
            theme,
            Icons.person_outline,
            'Perfil visible',
            'Permite que otros usuarios vean tu perfil',
            trailing: Switch(
              value: _privacyProfile,
              onChanged: (value) => setState(() => _privacyProfile = value),
            ),
          ),
          _buildSettingTile(
            theme,
            Icons.analytics_outlined,
            'Actividad académica',
            'Comparte tu progreso y estadísticas',
            trailing: Switch(
              value: _privacyActivity,
              onChanged: (value) => setState(() => _privacyActivity = value),
            ),
          ),
          _buildSettingTile(
            theme,
            Icons.grade_outlined,
            'Calificaciones',
            'Permite ver tus calificaciones a compañeros',
            trailing: Switch(
              value: _privacyGrades,
              onChanged: (value) => setState(() => _privacyGrades = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ayuda y soporte', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.md),
          _buildSettingTile(
            theme,
            Icons.help_outline,
            'Centro de ayuda',
            'Preguntas frecuentes y guías de uso',
            onTap: () => _showHelpDialog(context),
          ),
          _buildSettingTile(
            theme,
            Icons.bug_report_outlined,
            'Reportar un problema',
            'Envía un reporte de error o sugerencia',
            onTap: () => _showReportDialog(context),
          ),
          _buildSettingTile(
            theme,
            Icons.info_outline,
            'Acerca de la app',
            'Versión ${AppConstants.appVersion} • ${AppConstants.contestName}',
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(ThemeData theme, IconData icon, String title, String subtitle, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      title: Text(title, style: theme.textTheme.bodyMedium),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant) : null),
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

  Widget _buildVersionInfo(ThemeData theme) {
    return Center(
      child: Text(
        'Versión ${AppConstants.appVersion} • ${AppConstants.contestName}',
        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Centro de ayuda'),
        content: const Text('Esta es una funcionalidad de demostración. En la versión final, aquí encontrarás guías, preguntas frecuentes y tutoriales.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido'))],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reportar problema'),
        content: const Text('Esta es una funcionalidad de demostración. En la versión final, podrás enviar reportes de errores y sugerencias.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido'))],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppConstants.appName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versión ${AppConstants.appVersion}'),
            const SizedBox(height: AppSpacing.sm),
            Text(AppConstants.appTagline),
            const SizedBox(height: AppSpacing.sm),
            Text(AppConstants.contestName),
            const SizedBox(height: AppSpacing.md),
            Text('Prototipo visual desarrollado con Flutter y Material Design 3.'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
      ),
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