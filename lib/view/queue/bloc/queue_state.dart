import 'package:medgis_app/utils/models/queue_model.dart';
import 'package:medgis_app/utils/services/patient_service.dart';

abstract class QueueState {}

class QueueInitial extends QueueState {}

class QueueLoading extends QueueState {}

class QueueSucces extends QueueState {
  final List<PatientWithMedicalRecords> patients;
  final List<PatientWithMedicalRecords> filteredPatients;
  final Queue? queue;

  QueueSucces(
    this.patients,
    this.filteredPatients,
    this.queue,
  );
}

class QueueFailure extends QueueState {
  final String message;

  QueueFailure(this.message);
}
