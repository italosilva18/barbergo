import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:app/models/customer_model.dart';
import 'package:app/services/customer_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_loading.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/gradient_background.dart';
import 'customer_create_screen.dart';
import 'customer_edit_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});
  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final _customerService = CustomerService();
  List<Customer>? _customers;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await _customerService.getCustomers();
      if (mounted) setState(() { _customers = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _deleteCustomer(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardColor,
        title: const Text("Confirmar"),
        content: const Text("Deseja excluir este cliente?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Excluir", style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirm == true) {
      await _customerService.deleteCustomer(id);
      _loadCustomers();
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _buildAvatar(String name) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: Center(
        child: Text(
          _getInitials(name),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
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
                  Text("Clientes", style: textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: IconButton(
                      icon: const Icon(Iconsax.add, color: Colors.white),
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerCreateScreen()));
                        _loadCustomers();
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms),
            ),
            AppSpacing.verticalGapMd,
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadCustomers,
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
      return ErrorState(message: _error, onRetry: _loadCustomers);
    }
    if (_customers == null || _customers!.isEmpty) {
      return NoCustomersEmpty(
        onAddPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerCreateScreen()));
          _loadCustomers();
        },
      );
    }
    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: _customers!.length,
      itemBuilder: (ctx, i) {
        final cust = _customers![i];
        return ListItemCard(
          title: cust.name,
          subtitle: cust.phone,
          trailing: cust.email.length > 15 ? '${cust.email.substring(0, 12)}...' : cust.email,
          leading: _buildAvatar(cust.name),
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerEditScreen(customer: cust)));
            _loadCustomers();
          },
          onDelete: () => _deleteCustomer(cust.id),
        ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: 50 * i));
      },
    );
  }
}

