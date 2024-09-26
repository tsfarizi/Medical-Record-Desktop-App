import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/utils/dao/queue_dao.dart';
import 'package:medgis_app/view/queue/bloc/queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final PatientService patientService;
  final QueueDao queueDao;
  List<String> localQueuePatientIds = [];

  QueueCubit(this.patientService, this.queueDao) : super(QueueInitial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadLocalQueue();
    await fetchAllPatients();
  }

  Future<void> _loadLocalQueue() async {
    final prefs = await SharedPreferences.getInstance();
    localQueuePatientIds = prefs.getStringList('localQueuePatientIds') ?? [];
  }

  Future<void> _saveLocalQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('localQueuePatientIds', localQueuePatientIds);
  }

  Future<void> fetchAllPatients() async {
    try {
      final allPatients = await patientService.getAllPatientsWithRecords();
      emit(QueueSuccess(
        allPatients: allPatients,
        queuePatientIds: localQueuePatientIds,
      ));
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  void addToLocalQueue(String patientId) {
    if (!localQueuePatientIds.contains(patientId)) {
      localQueuePatientIds.add(patientId);
      _saveLocalQueue();
      if (state is QueueSuccess) {
        emit(QueueSuccess(
          allPatients: (state as QueueSuccess).allPatients,
          queuePatientIds: localQueuePatientIds,
        ));
      }
    }
  }

  void removeFromLocalQueue(String patientId) {
    if (localQueuePatientIds.contains(patientId)) {
      localQueuePatientIds.remove(patientId);
      _saveLocalQueue();
      if (state is QueueSuccess) {
        emit(QueueSuccess(
          allPatients: (state as QueueSuccess).allPatients,
          queuePatientIds: localQueuePatientIds,
        ));
      }
    }
  }

  Future<void> submitQueueToDatabase() async {
    if (localQueuePatientIds.isEmpty) return;
    try {
      await queueDao.insertQueue(localQueuePatientIds);
      localQueuePatientIds.clear();
      await _saveLocalQueue();
      await fetchAllPatients();
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  PatientWithMedicalRecords? getMostRecentPatient() {
    if (state is QueueSuccess) {
      final patients = (state as QueueSuccess).allPatients;
      if (patients.isNotEmpty) {
        // Assuming the most recently added patient is the last in the list
        return patients.last;
      }
    }
    return null;
  }
}
