import 'package:flutter/material.dart';
import 'package:app/models/appointment_model.dart';
import 'package:app/services/appointment_service.dart';
import 'package:app/services/service_service.dart';
import 'package:app/models/service_model.dart';

class AppointmentEditScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentEditScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  _AppointmentEditScreenState createState() => _AppointmentEditScreenState();
}

class _AppointmentEditScreenState extends State<AppointmentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDateTime;
  Service? _selectedService;
  late Future<List<Service>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.appointment.title);
    _descriptionController = TextEditingController(text: widget.appointment.description);
    _selectedDateTime = widget.appointment.dateTime;
    _servicesFuture = ServiceService().getServices();
    _servicesFuture.then((services) {
      setState(() {
        _selectedService = services.firstWhere(
          (service) => service.id == widget.appointment.serviceId,
          orElse: () => services.first, // Fallback if service not found
        );
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      final updatedAppointment = Appointment(
        id: widget.appointment.id,
        title: _titleController.text,
        description: _descriptionController.text,
        dateTime: _selectedDateTime,
        userId: widget.appointment.userId, // Keep existing user ID
        serviceId: _selectedService!.id,
      );

      try {
        await AppointmentService().updateAppointment(updatedAppointment);
        Navigator.pop(context, updatedAppointment); // Pass updated appointment back
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update appointment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              FutureBuilder<List<Service>>(
                future: _servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading services: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No services available.');
                  } else {
                    return DropdownButtonFormField<Service>(
                      decoration: const InputDecoration(labelText: 'Service'),
                      value: _selectedService,
                      onChanged: (Service? newValue) {
                        setState(() {
                          _selectedService = newValue;
                        });
                      },
                      items: snapshot.data!.map<DropdownMenuItem<Service>>((Service service) {
                        return DropdownMenuItem<Service>(
                          value: service,
                          child: Text(service.name),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a service';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              ListTile(
                title: Text(
                  'Date: ${(_selectedDateTime).toLocal().toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text(
                  'Time: ${(_selectedDateTime).toLocal().toString().split(' ')[1].substring(0, 5)}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAppointment,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
