import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../services/auth_service.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_text_field.dart';
import '../widgets/common/gradient_background.dart';
import 'main_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.signup(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao criar conta")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSpacing.verticalGapMd,
                  Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Iconsax.arrow_left, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))).animate().fadeIn(duration: 400.ms),
                  AppSpacing.verticalGapLg,
                  Text("Criar Conta", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(begin: 0.2, end: 0),
                  AppSpacing.verticalGapXs,
                  Text("Preencha os dados para comecar", style: textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                  AppSpacing.verticalGapXl,
                  AppTextField(controller: _nameController, label: "Nome Completo", hint: "Digite seu nome", prefixIcon: Iconsax.user, validator: (v) => v == null || v.isEmpty ? "Digite seu nome" : null).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                  AppSpacing.verticalGapMd,
                  AppEmailField(controller: _emailController, label: "Email", validator: (v) => v == null || v.isEmpty ? "Digite seu email" : (!v.contains("@") ? "Email invalido" : null)).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                  AppSpacing.verticalGapMd,
                  AppPasswordField(controller: _passwordController, label: "Senha", hint: "Minimo 6 caracteres", validator: (v) => v == null || v.length < 6 ? "Senha deve ter no minimo 6 caracteres" : null).animate().fadeIn(duration: 600.ms, delay: 500.ms),
                  AppSpacing.verticalGapXl,
                  AppButton(text: "Criar Conta", onPressed: _isLoading ? null : _signup, isLoading: _isLoading, icon: Iconsax.user_add).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                  AppSpacing.verticalGapLg,
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Ja tem uma conta? ", style: textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)), GestureDetector(onTap: () => Navigator.pop(context), child: Text("Entrar", style: textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)))]).animate().fadeIn(duration: 600.ms, delay: 700.ms),
                  AppSpacing.verticalGapXl,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
