import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/utils/dao/queue_dao.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/view/queue/bloc/queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final PatientService patientService;
  final QueueDao queueDao;
  List<PatientWithMedicalRecords> _allPatients = [];

  QueueCubit(this.patientService, this.queueDao) : super(QueueInitial()) {
    fetchAllPatients();
  }

  void fetchAllPatients() async {
    try {
      emit(QueueLoading());

      _allPatients = await patientService.getAllPatientsWithRecords();
      _emitSuccessState(_allPatients);
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  void _emitSuccessState(List<PatientWithMedicalRecords> allPatients,
      [List<PatientWithMedicalRecords>? filteredPatients]) {
    filteredPatients ??= allPatients;

    emit(QueueSucces(allPatients, filteredPatients));
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
            .toIso8601String()
            .toLowerCase()
            .contains(queryLower);
        final registeredMatch =
            patient.registered?.toString().toLowerCase().contains(queryLower) ??
                false;
        final lastVisitedMatch = patient.lastVisited
                ?.toIso8601String()
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

  Future<void> addQueue(String patientId) async {
    try {
      await queueDao.insertQueue(patientId);
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }
}
