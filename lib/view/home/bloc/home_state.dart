import 'package:medgis_app/utils/services/patient_service.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<PatientWithMedicalRecords> patients;
  final List<PatientWithMedicalRecords> filteredPatients;
  final int totalPatients;
  final int malePatients;
  final int femalePatients;

  HomeSuccess(this.patients, this.filteredPatients, this.totalPatients,
      this.malePatients, this.femalePatients);
}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}
