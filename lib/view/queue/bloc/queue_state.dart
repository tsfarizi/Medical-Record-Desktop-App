import 'package:medgis_app/utils/models/medical_record_model.dart';
import 'package:medgis_app/utils/services/patient_service.dart';

abstract class QueueState {}

class QueueInitial extends QueueState {}

class QueueLoading extends QueueState {}

class QueueSuccess extends QueueState {
  final List<PatientWithMedicalRecords> allPatients;
  final List<QueuePatientData> queuePatients;

  QueueSuccess({
    required this.allPatients,
    required this.queuePatients,
  });
}

class QueueFailure extends QueueState {
  final String message;

  QueueFailure(this.message);
}

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
