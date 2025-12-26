import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/gradient_background.dart';
import '../login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.verticalGapMd,
              // Header
              Text(
                'Configurações',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.verticalGapXs,
              Text(
                'Personalize sua experiência',
                style: textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              AppSpacing.verticalGapXl,

              // Appearance Section
              _SectionHeader(title: 'Aparência'),
              AppSpacing.verticalGapSm,
              AppCard(
                variant: AppCardVariant.outlined,
                padding: AppSpacing.paddingSm,
                child: Row(
                  children: [
                    Container(
                      padding: AppSpacing.paddingSm,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Icon(
                        isDark ? Iconsax.moon5 : Iconsax.sun_15,
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.horizontalGapMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modo Escuro',
                            style: textTheme.titleMedium,
                          ),
                          Text(
                            isDark ? 'Ativado' : 'Desativado',
                            style: textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (_) => themeProvider.toggleTheme(),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              AppSpacing.verticalGapLg,

              // Account Section
              _SectionHeader(title: 'Conta'),
              AppSpacing.verticalGapSm,
              _SettingsItem(
                icon: Iconsax.user,
                title: 'Perfil',
                subtitle: 'Editar informações pessoais',
                onTap: () {
                  // TODO: Navigate to profile
                },
              ),
              _SettingsItem(
                icon: Iconsax.notification,
                title: 'Notificações',
                subtitle: 'Configurar alertas e lembretes',
                onTap: () {
                  // TODO: Navigate to notifications
                },
              ),
              _SettingsItem(
                icon: Iconsax.shield_tick,
                title: 'Privacidade',
                subtitle: 'Configurações de privacidade',
                onTap: () {
                  // TODO: Navigate to privacy
                },
              ),

              AppSpacing.verticalGapLg,

              // About Section
              _SectionHeader(title: 'Sobre'),
              AppSpacing.verticalGapSm,
              _SettingsItem(
                icon: Iconsax.info_circle,
                title: 'Sobre o App',
                subtitle: 'Versão 1.0.0',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),

              const Spacer(),

              // Logout Button
              AppCard(
                variant: AppCardVariant.outlined,
                onTap: () => _showLogoutDialog(context),
                padding: AppSpacing.paddingMd,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.logout,
                      color: AppColors.error,
                    ),
                    AppSpacing.horizontalGapSm,
                    Text(
                      'Sair da Conta',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalGapMd,
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        title: Row(
          children: [
            Container(
              padding: AppSpacing.paddingSm,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: const Icon(
                Iconsax.scissor,
                color: Colors.white,
                size: 24,
              ),
            ),
            AppSpacing.horizontalGapMd,
            const Text('BarberGo'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Versão 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AppSpacing.verticalGapSm,
            Text(
              'Sistema profissional de gerenciamento para barbearias.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
            ),
            AppSpacing.verticalGapMd,
            const GoldAccentLine(width: 40),
            AppSpacing.verticalGapSm,
            Text(
              '© 2024 BarberGo',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('auth_token');
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      variant: AppCardVariant.outlined,
      onTap: onTap,
      padding: AppSpacing.paddingSm,
      child: Row(
        children: [
          Container(
            padding: AppSpacing.paddingSm,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          AppSpacing.horizontalGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Iconsax.arrow_right_3,
            color: isDark ? AppColors.iconDark : AppColors.iconLight,
            size: 20,
          ),
        ],
      ),
    );
  }
}
