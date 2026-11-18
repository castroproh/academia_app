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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _curpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _curpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  _buildRegisterCard(theme, authProvider),
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
          child: Icon(Icons.person_add_rounded, size: 40, color: theme.colorScheme.onPrimary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Crear cuenta',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Regístrate como estudiante',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterCard(ThemeData theme, AuthProvider authProvider) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Información personal',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Completa los campos para crear tu cuenta',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xl),

            AppTextField(
              controller: _nameController,
              label: 'Nombre completo',
              hint: 'Juan Pérez García',
              prefixIcon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu nombre completo';
                }
                if (value.trim().split(RegExp(r'\s+')).length < 2) {
                  return 'Ingresa al menos nombre y apellido';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            AppTextField(
              controller: _curpController,
              label: 'CURP',
              hint: 'AAAA000000HDFLRN00',
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
              hint: 'Mínimo 8 caracteres',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa una contraseña';
                }
                if (value.length < 8) {
                  return 'La contraseña debe tener al menos 8 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            AppPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirmar contraseña',
              hint: 'Repite tu contraseña',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirma tu contraseña';
                }
                if (value != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
              onSubmitted: (_) => _handleRegister(authProvider),
            ),
            const SizedBox(height: AppSpacing.md),

            CheckboxListTile(
              title: Text('Acepto los términos y condiciones', style: theme.textTheme.bodyMedium),
              subtitle: Text(
                'Al registrarte, aceptas nuestra Política de Privacidad y Términos de Servicio.',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              value: _acceptTerms,
              onChanged: (value) => setState(() => _acceptTerms = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.md)),
              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.sm)),
            ),
            const SizedBox(height: AppSpacing.lg),

            AppButton(
              label: 'Crear cuenta',
              onPressed: authProvider.isLoading || !_acceptTerms ? null : () => _handleRegister(authProvider),
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
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          Text(
            '¿Ya tienes cuenta?',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.go(AppRouter.login),
            child: Text('Inicia sesión', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
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

  Future<void> _handleRegister(AuthProvider authProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      await authProvider.register(_nameController.text.trim(), _curpController.text.trim(), _passwordController.text);
      if (authProvider.isAuthenticated && mounted) {
        context.go(AppRouter.studentDashboard);
      }
    }
  }
}