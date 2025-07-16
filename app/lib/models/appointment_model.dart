class Appointment {
  final String id;
  final String? userId;
  final String serviceId;
  final String title;
  final String description;
  final DateTime dateTime;

  Appointment({
    required this.id,
    this.userId,
    required this.serviceId,
    required this.dateTime,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userId: json['userId'],
      serviceId: json['serviceId'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'serviceId': serviceId,
      'dateTime': dateTime.toIso8601String(),
    };
    if (userId != null) {
      data['userId'] = userId;
    }
    return data;
  }
}
