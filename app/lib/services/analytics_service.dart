
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/analytics_model.dart';
import 'package:app/services/auth_service.dart';

class AnalyticsService {
  final String baseUrl = 'http://localhost:8085/api';

  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService().getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<AnalyticsData> getAnalytics() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/analytics'), headers: headers);

    if (response.statusCode == 200) {
      return AnalyticsData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load analytics data');
    }
  }
}
