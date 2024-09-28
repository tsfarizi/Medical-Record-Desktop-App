import 'package:medgis_app/utils/models/medical_record_model.dart';

class QueuePatientData {
  final String patientId;
  String? bloodPressure;
  List<MedicalRecord> medicalRecords;

  QueuePatientData({
    required this.patientId,
    this.bloodPressure,
    List<MedicalRecord>? medicalRecords,
  }) : medicalRecords = medicalRecords ?? [];

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'bloodPressure': bloodPressure,
      'medicalRecords': medicalRecords.map((mr) => mr.toJson()).toList(),
    };
  }

  factory QueuePatientData.fromJson(Map<String, dynamic> json) {
    return QueuePatientData(
      patientId: json['patientId'],
      bloodPressure: json['bloodPressure'],
      medicalRecords: (json['medicalRecords'] as List<dynamic>)
          .map((mrJson) => MedicalRecord.fromJson(mrJson))
          .toList(),
    );
  }
}
