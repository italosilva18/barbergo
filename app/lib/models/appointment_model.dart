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
    required this.title,
    required this.description,
    required this.dateTime,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userId: json['userId'],
      serviceId: json['serviceId'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'serviceId': serviceId,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
    if (userId != null) {
      data['userId'] = userId;
    }
    return data;
  }
}
