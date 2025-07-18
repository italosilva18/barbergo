
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/customer_model.dart';
import 'package:app/services/auth_service.dart';

class CustomerService {
  final String baseUrl = 'http://YOUR_API_HOST:8080/api';

  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService().getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Customer>> getCustomers() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/customers'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> customersJson = jsonDecode(response.body)['customers'];
      return customersJson.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<Customer> createCustomer(Customer customer) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: headers,
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 201) {
      return Customer.fromJson(jsonDecode(response.body)['customer']);
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<Customer> updateCustomer(Customer customer) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/customers/${customer.id}'),
      headers: headers,
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 200) {
      return Customer.fromJson(jsonDecode(response.body)['customer']);
    } else {
      throw Exception('Failed to update customer');
    }
  }

  Future<void> deleteCustomer(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/customers/$id'), headers: headers);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete customer');
    }
  }
}
