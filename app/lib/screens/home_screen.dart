import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../models/analytics_model.dart';
import '../services/analytics_service.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_loading.dart';
import '../widgets/common/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _analyticsService = AnalyticsService();
  AnalyticsData? _analytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final data = await _analyticsService.getAnalytics();
      if (mounted) setState(() { _analytics = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GradientBackground(
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAnalytics,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.verticalGapMd,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ola!", style: textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                        Text("BarberGo", style: textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      padding: AppSpacing.paddingSm,
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: AppSpacing.borderRadiusMd),
                      child: const Icon(Iconsax.scissor, color: AppColors.primary, size: 28),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms),
                AppSpacing.verticalGapXl,
                Text("Resumo", style: textTheme.titleLarge).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                AppSpacing.verticalGapMd,
                if (_isLoading) ...[
                  const Row(children: [Expanded(child: ShimmerStatsCard()), SizedBox(width: 16), Expanded(child: ShimmerStatsCard())]),
                  AppSpacing.verticalGapMd,
                  const ShimmerStatsCard(),
                ] else ...[
                  Row(
                    children: [
                      Expanded(child: StatsCard(title: "Agendamentos", value: "${_analytics?.totalAppointments ?? 0}", icon: Iconsax.calendar_1, iconColor: AppColors.info)),
                      AppSpacing.horizontalGapMd,
                      Expanded(child: StatsCard(title: "Clientes", value: "${_analytics?.totalCustomers ?? 0}", icon: Iconsax.people, iconColor: AppColors.success)),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                  AppSpacing.verticalGapMd,
                  StatsCard(
                    title: "Receita Total",
                    value: "R\$ ${(_analytics?.totalRevenue ?? 0).toStringAsFixed(2)}",
                    icon: Iconsax.money_recive,
                    iconColor: AppColors.primary,
                    subtitle: "+12%",
                  ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                ],
                AppSpacing.verticalGapXl,
                Text("Acoes Rapidas", style: textTheme.titleLarge).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                AppSpacing.verticalGapMd,
                Row(
                  children: [
                    Expanded(child: _QuickActionCard(icon: Iconsax.calendar_add, title: "Novo Agendamento", color: AppColors.info, onTap: () {})),
                    AppSpacing.horizontalGapMd,
                    Expanded(child: _QuickActionCard(icon: Iconsax.user_add, title: "Novo Cliente", color: AppColors.success, onTap: () {})),
                    AppSpacing.horizontalGapMd,
                    Expanded(child: _QuickActionCard(icon: Iconsax.add_circle, title: "Novo Servico", color: AppColors.warning, onTap: () {})),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
                AppSpacing.verticalGapXl,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionCard({required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppCard(
      variant: AppCardVariant.outlined,
      onTap: onTap,
      padding: AppSpacing.paddingMd,
      child: Column(
        children: [
          Container(
            padding: AppSpacing.paddingSm,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: AppSpacing.borderRadiusSm),
            child: Icon(icon, color: color, size: 24),
          ),
          AppSpacing.verticalGapSm,
          Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
