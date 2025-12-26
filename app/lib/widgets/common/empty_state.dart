import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
            AppSpacing.verticalGapLg,
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              AppSpacing.verticalGapSm,
              Text(
                description!,
                style: textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              AppSpacing.verticalGapXl,
              AppButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                isFullWidth: false,
                icon: Iconsax.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Predefined empty states
class NoAppointmentsEmpty extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const NoAppointmentsEmpty({
    super.key,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Iconsax.calendar,
      title: 'Nenhum agendamento',
      description: 'Você ainda não tem agendamentos.\nComece adicionando o primeiro!',
      buttonText: 'Novo Agendamento',
      onButtonPressed: onAddPressed,
    );
  }
}

class NoServicesEmpty extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const NoServicesEmpty({
    super.key,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Iconsax.scissor,
      title: 'Nenhum serviço',
      description: 'Cadastre os serviços oferecidos\npela sua barbearia.',
      buttonText: 'Novo Serviço',
      onButtonPressed: onAddPressed,
    );
  }
}

class NoCustomersEmpty extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const NoCustomersEmpty({
    super.key,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Iconsax.people,
      title: 'Nenhum cliente',
      description: 'Sua lista de clientes está vazia.\nAdicione seu primeiro cliente!',
      buttonText: 'Novo Cliente',
      onButtonPressed: onAddPressed,
    );
  }
}

// Error state
class ErrorState extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.title,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.warning_2,
                size: 64,
                color: AppColors.error.withValues(alpha: 0.7),
              ),
            ),
            AppSpacing.verticalGapLg,
            Text(
              title ?? 'Algo deu errado',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalGapSm,
            Text(
              message ?? 'Não foi possível carregar os dados.\nTente novamente.',
              style: textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.verticalGapXl,
              AppButton(
                text: 'Tentar novamente',
                onPressed: onRetry,
                variant: AppButtonVariant.outline,
                isFullWidth: false,
                icon: Iconsax.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
