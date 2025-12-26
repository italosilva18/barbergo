import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:app/models/service_model.dart';
import 'package:app/services/service_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_loading.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/gradient_background.dart';
import 'service_create_screen.dart';
import 'service_edit_screen.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});
  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final _serviceService = ServiceService();
  List<Service>? _services;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await _serviceService.getServices();
      if (mounted) setState(() { _services = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _deleteService(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardColor,
        title: const Text("Confirmar"),
        content: const Text("Deseja excluir este servico?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Excluir", style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirm == true) {
      await _serviceService.deleteService(id);
      _loadServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GradientBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.screenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Servicos", style: textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: IconButton(
                      icon: const Icon(Iconsax.add, color: Colors.white),
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceCreateScreen()));
                        _loadServices();
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms),
            ),
            AppSpacing.verticalGapMd,
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadServices,
                color: AppColors.primary,
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ShimmerList(itemCount: 5),
      );
    }
    if (_error != null) {
      return ErrorState(message: _error, onRetry: _loadServices);
    }
    if (_services == null || _services!.isEmpty) {
      return NoServicesEmpty(
        onAddPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceCreateScreen()));
          _loadServices();
        },
      );
    }
    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: _services!.length,
      itemBuilder: (ctx, i) {
        final svc = _services![i];
        return ListItemCard(
          title: svc.name,
          subtitle: "${svc.duration} min",
          trailing: "R\$ ${svc.price.toStringAsFixed(2)}",
          leadingIcon: Iconsax.scissor,
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceEditScreen(service: svc)));
            _loadServices();
          },
          onDelete: () => _deleteService(svc.id),
        ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: 50 * i));
      },
    );
  }
}

