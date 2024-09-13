import 'package:medgis_app/utils/services/pateint_service.dart';

abstract class DetailState {}

class DetailInitial extends DetailState {}

class DetailLoaded extends DetailState {
  final PatientWithMedicalRecords patient;

  DetailLoaded(this.patient);
}
