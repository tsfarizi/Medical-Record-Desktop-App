import 'package:medgis_app/utils/services/patient_service.dart';

abstract class QueueState {}

class QueueInitial extends QueueState {}

class QueueLoading extends QueueState {}

class QueueSucces extends QueueState {
  final List<PatientWithMedicalRecords> patients;
  final List<PatientWithMedicalRecords> filteredPatients;

  QueueSucces(
    this.patients,
    this.filteredPatients,
  );
}

class QueueFailure extends QueueState {
  final String message;

  QueueFailure(this.message);
}
