import 'package:flutter/material.dart';
import 'package:app/screens/appointment_list_screen.dart';
import 'package:app/screens/service_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppointmentListScreen()),
                );
              },
              child: const Text('Manage Appointments'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServiceListScreen()),
                );
              },
              child: const Text('Manage Services'),
            ),
          ],
        ),
      ),
    );
  }
}