
import 'package:flutter/material.dart';
import 'package:app/models/customer_model.dart';
import 'package:app/services/customer_service.dart';
import 'package:app/screens/customer_create_screen.dart';
import 'package:app/screens/customer_edit_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  late Future<List<Customer>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _customersFuture = CustomerService().getCustomers();
  }

  void _refreshCustomers() {
    setState(() {
      _customersFuture = CustomerService().getCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomerCreateScreen()),
              );
              _refreshCustomers();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Customer>>(
        future: _customersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No customers found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final customer = snapshot.data![index];
                return ListTile(
                  title: Text(customer.name),
                  subtitle: Text(customer.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CustomerEditScreen(customer: customer)),
                          );
                          _refreshCustomers();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await CustomerService().deleteCustomer(customer.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Customer deleted')),
                            );
                            _refreshCustomers();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete customer: ${e.toString()}')),
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
