
import 'package:flutter/material.dart';
import 'package:app/models/customer_model.dart';
import 'package:app/services/customer_service.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/custom_text_field.dart';

class CustomerEditScreen extends StatefulWidget {
  final Customer customer;

  const CustomerEditScreen({super.key, required this.customer});

  @override
  State<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _emailController = TextEditingController(text: widget.customer.email);
    _phoneController = TextEditingController(text: widget.customer.phone);
    _notesController = TextEditingController(text: widget.customer.notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Customer Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone',
                keyboardType: TextInputType.phone,
              ),
              CustomTextField(
                controller: _notesController,
                labelText: 'Notes',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Update Customer',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedCustomer = Customer(
                      id: widget.customer.id,
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      notes: _notesController.text,
                    );

                    try {
                      await CustomerService().updateCustomer(updatedCustomer);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Customer updated successfully')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update customer: ${e.toString()}')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
