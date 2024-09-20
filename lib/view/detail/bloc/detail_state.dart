import 'package:medgis_app/utils/services/patient_service.dart';

abstract class DetailState {}

class DetailInitial extends DetailState {}

class DetailLoaded extends DetailState {
  final PatientWithMedicalRecords patient;

  DetailLoaded(this.patient);
}

class DetailFailure extends DetailState {
  final String message;

  DetailFailure(this.message);
}
