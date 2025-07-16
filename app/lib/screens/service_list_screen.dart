import 'package:flutter/material.dart';
import 'package:app/models/service_model.dart';
import 'package:app/services/service_service.dart';
import 'package:app/screens/service_create_screen.dart';
import 'package:app/screens/service_edit_screen.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  late Future<List<Service>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = ServiceService().getServices();
  }

  void _refreshServices() {
    setState(() {
      _servicesFuture = ServiceService().getServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServiceCreateScreen()),
              );
              _refreshServices();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Service>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No services found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final service = snapshot.data![index];
                return ListTile(
                  title: Text(service.name),
                  subtitle: Text('Price: \$${service.price.toStringAsFixed(2)} - Duration: ${service.duration} min'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ServiceEditScreen(service: service)),
                          );
                          _refreshServices();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await ServiceService().deleteService(service.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Service deleted')),
                            );
                            _refreshServices();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete service: ${e.toString()}')),
                            );
                          }
                        },
                      ),
                    ],
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