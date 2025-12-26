import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../services/auth_service.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_text_field.dart';
import '../widgets/common/gradient_background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() { _emailController.dispose(); super.dispose(); }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.forgotPassword(_emailController.text.trim());
      if (mounted) setState(() { _emailSent = true; _isLoading = false; });
    } catch (e) {
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao enviar email"))); setState(() => _isLoading = false); }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: AuthGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPaddingLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSpacing.verticalGapMd,
                Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Iconsax.arrow_left, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))).animate().fadeIn(duration: 400.ms),
                AppSpacing.verticalGapXl,
                if (_emailSent) ...[
                  Container(width: 100, height: 100, decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), shape: BoxShape.circle), child: const Icon(Iconsax.tick_circle, size: 50, color: AppColors.success)).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
                  AppSpacing.verticalGapLg,
                  Text("Email Enviado!", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                  AppSpacing.verticalGapSm,
                  Text("Verifique sua caixa de entrada", style: textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), textAlign: TextAlign.center).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                  AppSpacing.verticalGapXl,
                  AppButton(text: "Voltar para o Login", onPressed: () => Navigator.pop(context), icon: Iconsax.login).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                ] else ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle), child: const Icon(Iconsax.lock, size: 40, color: AppColors.primary)).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                        AppSpacing.verticalGapLg,
                        Text("Esqueceu a Senha?", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                        AppSpacing.verticalGapSm,
                        Text("Digite seu email e enviaremos instrucoes para redefinir sua senha", style: textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), textAlign: TextAlign.center).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                        AppSpacing.verticalGapXl,
                        AppEmailField(controller: _emailController, label: "Email", validator: (v) => v == null || v.isEmpty ? "Digite seu email" : (!v.contains("@") ? "Email invalido" : null)).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                        AppSpacing.verticalGapXl,
                        AppButton(text: "Enviar Instrucoes", onPressed: _isLoading ? null : _resetPassword, isLoading: _isLoading, icon: Iconsax.send_2).animate().fadeIn(duration: 600.ms, delay: 500.ms),
                        AppSpacing.verticalGapLg,
                        TextButton(onPressed: () => Navigator.pop(context), child: Text("Voltar para o Login", style: textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600))).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}


