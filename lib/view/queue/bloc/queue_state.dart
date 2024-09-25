import 'package:medgis_app/utils/services/patient_service.dart';

abstract class QueueState {}

class QueueInitial extends QueueState {}

class QueueLoading extends QueueState {}

class QueueSuccess extends QueueState {
  final List<PatientWithMedicalRecords> allPatients;
  final List<String> queuePatientIds;

  QueueSuccess({
    required this.allPatients,
    required this.queuePatientIds,
  });
}

class QueueFailure extends QueueState {
  final String message;

  QueueFailure(this.message);
}
