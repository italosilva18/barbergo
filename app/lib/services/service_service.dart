import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/service_model.dart';
import 'package:app/services/auth_service.dart';

class ServiceService {
  final String baseUrl = 'http://localhost:8085/api';

  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService().getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Service>> getServices() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/services'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> servicesJson = jsonDecode(response.body);
      return servicesJson.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<Service> createService(Service service) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/services'),
      headers: headers,
      body: jsonEncode(service.toJson()),
    );

    if (response.statusCode == 201) {
      return Service.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create service');
    }
  }

  Future<Service> updateService(Service service) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/services/${service.id}'),
      headers: headers,
      body: jsonEncode(service.toJson()),
    );

    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update service');
    }
  }

  Future<void> deleteService(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/services/$id'), headers: headers);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete service');
    }
  }
}

