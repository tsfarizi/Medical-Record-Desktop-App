class Patient {
  final String id;
  final int registrationNumber;
  final String fullName;
  final String address;
  final String gender;
  final DateTime birthDate;
  final String phone;
  String? bloodPressure;
  String? bloodPressureNow;

  Patient(
      {required this.id,
      required this.registrationNumber,
      required this.fullName,
      required this.address,
      required this.gender,
      required this.birthDate,
      required this.phone,
      this.bloodPressure = '',
      this.bloodPressureNow = ''});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
        id: json['id'],
        registrationNumber: int.parse(json['registration_number'].toString()),
        fullName: json['full_name'],
        address: json['address'],
        gender: json['gender'],
        birthDate: DateTime.parse(json['birth_date']),
        phone: json['phone'],
        bloodPressure: json['blood_pressure'],
        bloodPressureNow: json['blood_pressure_now']);
  }

  Map<String, dynamic> toJson() {
    return {
      'registration_number': registrationNumber,
      'full_name': fullName,
      'address': address,
      'gender': gender,
      'birth_date': birthDate.toIso8601String(),
      'phone': phone,
      'blood_pressure': bloodPressure,
      'blood_pressure_now': bloodPressureNow
    };
  }
}
