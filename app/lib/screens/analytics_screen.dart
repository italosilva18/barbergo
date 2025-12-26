import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:app/models/analytics_model.dart';
import 'package:app/services/analytics_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_loading.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/gradient_background.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _analyticsService = AnalyticsService();
  AnalyticsData? _analytics;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await _analyticsService.getAnalytics();
      if (mounted) setState(() { _analytics = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
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
                Text("Analytics", style: textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)).animate().fadeIn(duration: 600.ms),
                AppSpacing.verticalGapSm,
                Text("Metricas do seu negocio", style: textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                AppSpacing.verticalGapXl,
                _buildContent(textTheme, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(TextTheme textTheme, bool isDark) {
    if (_isLoading) {
      return Column(
        children: [
          const Row(children: [Expanded(child: ShimmerStatsCard()), SizedBox(width: 16), Expanded(child: ShimmerStatsCard())]),
          AppSpacing.verticalGapMd,
          const ShimmerStatsCard(),
        ],
      );
    }
    if (_error != null) {
      return ErrorState(message: _error, onRetry: _loadAnalytics);
    }
    if (_analytics == null) {
      return const EmptyState(icon: Iconsax.chart, title: "Sem dados", description: "Nenhuma metrica disponivel");
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: "Agendamentos",
                value: "${_analytics!.totalAppointments}",
                icon: Iconsax.calendar_1,
                iconColor: AppColors.info,
              ),
            ),
            AppSpacing.horizontalGapMd,
            Expanded(
              child: StatsCard(
                title: "Clientes",
                value: "${_analytics!.totalCustomers}",
                icon: Iconsax.people,
                iconColor: AppColors.success,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
        AppSpacing.verticalGapMd,
        StatsCard(
          title: "Receita Total",
          value: "R\$ ${_analytics!.totalRevenue.toStringAsFixed(2)}",
          icon: Iconsax.money_recive,
          iconColor: AppColors.primary,
          subtitle: "+12%",
        ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
        AppSpacing.verticalGapXl,
        Text("Resumo", style: textTheme.titleLarge).animate().fadeIn(duration: 600.ms, delay: 400.ms),
        AppSpacing.verticalGapMd,
        AppCard(
          variant: AppCardVariant.outlined,
          padding: AppSpacing.paddingLg,
          child: Column(
            children: [
              _buildMetricRow("Media por cliente", _analytics!.totalCustomers > 0 ? "R\$ ${(_analytics!.totalRevenue / _analytics!.totalCustomers).toStringAsFixed(2)}" : "R\$ 0.00", AppColors.info, isDark),
              AppSpacing.verticalGapMd,
              _buildMetricRow("Ticket medio", _analytics!.totalAppointments > 0 ? "R\$ ${(_analytics!.totalRevenue / _analytics!.totalAppointments).toStringAsFixed(2)}" : "R\$ 0.00", AppColors.primary, isDark),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
        AppSpacing.verticalGapXl,
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, Color color, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

