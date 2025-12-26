import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:app/models/appointment_model.dart';
import 'package:app/services/appointment_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_loading.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/gradient_background.dart';
import 'appointment_create_screen.dart';
import 'appointment_edit_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});
  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final _appointmentService = AppointmentService();
  List<Appointment>? _appointments;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await _appointmentService.getAppointments();
      if (mounted) setState(() { _appointments = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _deleteAppointment(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardColor,
        title: const Text("Confirmar"),
        content: const Text("Deseja excluir este agendamento?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Excluir", style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirm == true) {
      await _appointmentService.deleteAppointment(id);
      _loadAppointments();
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
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
                  Text("Agendamentos", style: textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: IconButton(
                      icon: const Icon(Iconsax.add, color: Colors.white),
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentCreateScreen()));
                        _loadAppointments();
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms),
            ),
            AppSpacing.verticalGapMd,
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadAppointments,
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
      return ErrorState(message: _error, onRetry: _loadAppointments);
    }
    if (_appointments == null || _appointments!.isEmpty) {
      return NoAppointmentsEmpty(
        onAddPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentCreateScreen()));
          _loadAppointments();
        },
      );
    }
    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: _appointments!.length,
      itemBuilder: (ctx, i) {
        final apt = _appointments![i];
        return ListItemCard(
          title: apt.title,
          subtitle: apt.description,
          trailing: _formatDate(apt.dateTime),
          leadingIcon: Iconsax.calendar_tick,
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => AppointmentEditScreen(appointment: apt)));
            _loadAppointments();
          },
          onDelete: () => _deleteAppointment(apt.id),
        ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: 50 * i));
      },
    );
  }
}


