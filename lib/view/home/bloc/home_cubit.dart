import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/utils/services/pateint_service.dart';
import 'package:medgis_app/view/home/bloc/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final PatientService patientService;
  List<PatientWithMedicalRecords> _allPatients = [];

  HomeCubit(this.patientService) : super(HomeInitial());

  void fetchAllPatients() async {
    try {
      emit(HomeLoading());

      _allPatients = await patientService.getAllPatientsWithRecords();
      _emitSuccessState(_allPatients);
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  void filterPatients(String query) {
    if (query.isEmpty) {
      _emitSuccessState(_allPatients);
    } else {
      final filteredPatients = _allPatients.where((patient) {
        final queryLower = query.toLowerCase();

        final nameMatch =
            patient.patient.fullName.toLowerCase().contains(queryLower);
        final phoneMatch =
            patient.patient.phone.toLowerCase().contains(queryLower);
        final birthDateMatch = patient.patient.birthDate
            .toString()
            .toLowerCase()
            .contains(queryLower);
        final registeredMatch =
            patient.registered?.toString().toLowerCase().contains(queryLower) ??
                false;
        final lastVisitedMatch = patient.lastVisited
                ?.toString()
                .toLowerCase()
                .contains(queryLower) ??
            false;

        return nameMatch ||
            phoneMatch ||
            birthDateMatch ||
            registeredMatch ||
            lastVisitedMatch;
      }).toList();

      _emitSuccessState(_allPatients, filteredPatients);
    }
  }

  void deletePatient(PatientWithMedicalRecords patientRecord) async {
    try {
      emit(HomeLoading());

      await patientService.deletePatient(patientRecord.patient);

      _allPatients = await patientService.getAllPatientsWithRecords();
      _emitSuccessState(_allPatients);
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  void _emitSuccessState(List<PatientWithMedicalRecords> allPatients,
      [List<PatientWithMedicalRecords>? filteredPatients]) {
    filteredPatients ??= allPatients;

    final int totalPatients = allPatients.length;
    final int malePatients =
        filteredPatients.where((p) => p.patient.gender == 'Male').length;
    final int femalePatients =
        filteredPatients.where((p) => p.patient.gender == 'Female').length;

    emit(HomeSuccess(allPatients, filteredPatients, totalPatients, malePatients,
        femalePatients));
  }

  Future<void> printSinglePatientAsPdf(
      PatientWithMedicalRecords patientRecord, String filePath) async {
    try {
      await patientService.printSinglePatientData(patientRecord, filePath);

      final int totalPatients = _allPatients.length;
      final int malePatients =
          _allPatients.where((p) => p.patient.gender == 'Male').length;
      final int femalePatients =
          _allPatients.where((p) => p.patient.gender == 'Female').length;

      emit(HomeSuccess(_allPatients, _allPatients, totalPatients, malePatients,
          femalePatients));
    } catch (e) {
      emit(HomeFailure("Failed to print patient data: ${e.toString()}"));
    }
  }
}
