import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/appointment_model.dart';
import 'package:app/services/auth_service.dart';

class AppointmentService {
  final String baseUrl = 'http://YOUR_API_HOST:8080/api';

  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService().getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Appointment>> getAppointments() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/appointments'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> appointmentsJson = jsonDecode(response.body);
      return appointmentsJson.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: headers,
      body: jsonEncode(appointment.toJson()),
    );

    if (response.statusCode == 201) {
      return Appointment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create appointment');
    }
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/appointments/${appointment.id}'),
      headers: headers,
      body: jsonEncode(appointment.toJson()),
    );

    if (response.statusCode == 200) {
      return Appointment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update appointment');
    }
  }

  Future<void> deleteAppointment(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/appointments/$id'), headers: headers);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete appointment');
    }
  }
}
