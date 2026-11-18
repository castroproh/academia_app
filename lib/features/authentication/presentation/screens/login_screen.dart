import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/routing/app_router.dart';
import '../providers/auth_provider.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_input.dart';
import '../../../../../../shared/widgets/app_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _curpController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _curpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(theme),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildLoginCard(theme, authProvider),
                  const SizedBox(height: AppSpacing.lg),
                  _buildFooter(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.colorScheme.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Icon(Icons.school_rounded, size: 40, color: theme.colorScheme.onPrimary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppConstants.appName,
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Inicia sesión para continuar',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(ThemeData theme, AuthProvider authProvider) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bienvenido de nuevo',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Ingresa tus credenciales para acceder',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xl),

            AppTextField(
              controller: _curpController,
              label: 'CURP',
              hint: 'Ej: AAAA000000HDFLRN00',
              prefixIcon: Icons.badge_outlined,
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu CURP';
                }
                if (value.length != 18) {
                  return 'El CURP debe tener 18 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            AppPasswordField(
              controller: _passwordController,
              label: 'Contraseña',
              hint: 'Ingresa tu contraseña',
              onSubmitted: (_) => _handleLogin(authProvider),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) => setState(() => _rememberMe = value ?? false),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.sm)),
                ),
                Text('Recordarme', style: theme.textTheme.bodyMedium),
                const Spacer(),
                TextButton(
                  onPressed: () => _showForgotPasswordDialog(context),
                  child: Text('¿Olvidaste tu contraseña?', style: theme.textTheme.labelMedium),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            AppButton(
              label: 'Iniciar sesión',
              onPressed: authProvider.isLoading ? null : () => _handleLogin(authProvider),
              isLoading: authProvider.isLoading,
              isFullWidth: true,
              variant: ButtonVariant.filled,
            ),
            const SizedBox(height: AppSpacing.md),

            if (authProvider.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 20, color: theme.colorScheme.error),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        authProvider.errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.lg),
            _buildDemoCredentials(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCredentials(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Credenciales de demostración',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildCredentialRow(theme, 'Alumno:', AppConstants.demoStudentCurp, AppConstants.demoPassword),
          const SizedBox(height: AppSpacing.xs),
          _buildCredentialRow(theme, 'Docente:', AppConstants.demoTeacherCurp, AppConstants.demoPassword),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(ThemeData theme, String label, String curp, String password) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(
            'CURP: $curp | Pass: $password',
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          Text(
            '¿No tienes cuenta?',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.go(AppRouter.register),
            child: Text('Regístrate', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppConstants.contestName,
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      await authProvider.login(_curpController.text.trim(), _passwordController.text);
      if (authProvider.isAuthenticated && mounted) {
        if (authProvider.isStudent) {
          context.go(AppRouter.studentDashboard);
        } else if (authProvider.isTeacher) {
          context.go(AppRouter.teacherDashboard);
        }
      }
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: const Text('Esta es una funcionalidad de demostración. En la versión final, se enviará un correo con instrucciones para restablecer tu contraseña.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido')),
        ],
      ),
    );
  }
}