
class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String notes;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.notes,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'notes': notes,
    };
  }
}
