
class AnalyticsData {
  final int totalAppointments;
  final int totalCustomers;
  final double totalRevenue;

  AnalyticsData({
    required this.totalAppointments,
    required this.totalCustomers,
    required this.totalRevenue,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      totalAppointments: json['total_appointments'],
      totalCustomers: json['total_customers'],
      totalRevenue: json['total_revenue'].toDouble(),
    );
  }
}
