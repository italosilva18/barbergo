import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }
enum AppButtonSize { small, medium, large }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconData? suffixIcon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.suffixIcon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  double get _height {
    switch (widget.size) {
      case AppButtonSize.small:
        return AppSpacing.buttonHeightSm;
      case AppButtonSize.medium:
        return AppSpacing.buttonHeightMd;
      case AppButtonSize.large:
        return AppSpacing.buttonHeightLg;
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.md);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.xl);
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case AppButtonSize.small:
        return 12;
      case AppButtonSize.medium:
        return 14;
      case AppButtonSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: AppSpacing.durationFast,
        child: AnimatedContainer(
          duration: AppSpacing.durationFast,
          width: widget.isFullWidth ? double.infinity : null,
          height: _height,
          decoration: _getDecoration(isDark),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: AppSpacing.borderRadiusMd,
              child: Padding(
                padding: _padding,
                child: _buildContent(isDark),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(bool isDark) {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          gradient: widget.onPressed != null
              ? AppColors.primaryGradient
              : null,
          color: widget.onPressed == null
              ? AppColors.primary.withValues(alpha: 0.5)
              : null,
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: widget.onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        );
      case AppButtonVariant.secondary:
        return BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceVariant
              : AppColors.lightSurfaceVariant,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        );
      case AppButtonVariant.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: AppColors.primary,
            width: 1.5,
          ),
        );
      case AppButtonVariant.ghost:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppSpacing.borderRadiusMd,
        );
    }
  }

  Color _getTextColor(bool isDark) {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.darkBackground;
      case AppButtonVariant.secondary:
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return AppColors.primary;
    }
  }

  Widget _buildContent(bool isDark) {
    final textColor = _getTextColor(isDark);

    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1000.ms, color: textColor.withValues(alpha: 0.3));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: _fontSize + 4, color: textColor),
          AppSpacing.horizontalGapSm,
        ],
        Text(
          widget.text,
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
        if (widget.suffixIcon != null) ...[
          AppSpacing.horizontalGapSm,
          Icon(widget.suffixIcon, size: _fontSize + 4, color: textColor),
        ],
      ],
    );
  }
}

// Convenience constructors
class PrimaryButton extends AppButton {
  const PrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading,
    super.icon,
  }) : super(variant: AppButtonVariant.primary);
}

class SecondaryButton extends AppButton {
  const SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading,
    super.icon,
  }) : super(variant: AppButtonVariant.secondary);
}

class OutlineButton extends AppButton {
  const OutlineButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading,
    super.icon,
  }) : super(variant: AppButtonVariant.outline);
}

class GhostButton extends AppButton {
  const GhostButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading,
    super.icon,
  }) : super(variant: AppButtonVariant.ghost);
}
