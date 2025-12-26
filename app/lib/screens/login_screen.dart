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
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.login(_emailController.text.trim(), _passwordController.text);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
      }
    } catch (e) {
      if (mounted) _showError("Email ou senha invalidos");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [const Icon(Iconsax.warning_2, color: Colors.white, size: 20), AppSpacing.horizontalGapSm, Expanded(child: Text(message))]),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AuthGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPaddingLarge,
            child: SizedBox(
              height: size.height - MediaQuery.of(context).padding.top - 48,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 1),
                    _buildLogo().animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
                    const Spacer(flex: 1),
                    Text("Bem-vindo de volta", style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
                    AppSpacing.verticalGapXs,
                    Text("Entre para gerenciar sua barbearia", style: textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), textAlign: TextAlign.center).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                    AppSpacing.verticalGapXl,
                    AppEmailField(controller: _emailController, label: "Email", validator: (value) { if (value == null || value.isEmpty) return "Digite seu email"; if (!value.contains("@")) return "Email invalido"; return null; }).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideX(begin: -0.1, end: 0),
                    AppSpacing.verticalGapMd,
                    AppPasswordField(controller: _passwordController, label: "Senha", validator: (value) { if (value == null || value.isEmpty) return "Digite sua senha"; if (value.length < 6) return "Senha muito curta"; return null; }).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideX(begin: -0.1, end: 0),
                    AppSpacing.verticalGapSm,
                    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())); }, child: Text("Esqueceu a senha?", style: textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)))).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                    AppSpacing.verticalGapLg,
                    AppButton(text: "Entrar", onPressed: _isLoading ? null : _login, isLoading: _isLoading, icon: Iconsax.login).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideY(begin: 0.2, end: 0),
                    const Spacer(flex: 2),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Nao tem uma conta? ", style: textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)), GestureDetector(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())); }, child: Text("Criar conta", style: textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)))]).animate().fadeIn(duration: 600.ms, delay: 800.ms),
                    AppSpacing.verticalGapMd,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(children: [
      Container(width: 100, height: 100, decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: AppSpacing.borderRadiusXl, boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))]), child: const Icon(Iconsax.scissor, size: 48, color: Colors.white)),
      AppSpacing.verticalGapMd,
      Text("BarberGo", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1)),
    ]);
  }
}
