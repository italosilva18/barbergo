import 'package:app/screens/appointment_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/models/appointment_model.dart';
import 'package:app/services/appointment_service.dart';
import 'package:app/screens/appointment_create_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  late Future<List<Appointment>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = AppointmentService().getAppointments();
  }

  void _refreshAppointments() {
    setState(() {
      _appointmentsFuture = AppointmentService().getAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppointmentCreateScreen()),
              );
              _refreshAppointments();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Appointment>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final appointment = snapshot.data![index];
                return ListTile(
                  title: Text('Appointment ID: ${appointment.id}'),
                  subtitle: Text('Date: ${appointment.dateTime.toLocal().toString().split(' ')[0]}'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentEditScreen(appointment: appointment),
                      ),
                    );
                    _refreshAppointments();
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await AppointmentService().deleteAppointment(appointment.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Appointment deleted')),
                        );
                        _refreshAppointments();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to delete appointment: ${e.toString()}')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}