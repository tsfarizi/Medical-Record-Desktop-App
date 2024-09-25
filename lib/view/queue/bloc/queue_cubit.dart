import 'package:flutter_bloc/flutter_bloc.dart';
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
    await fetchAllPatients();
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
      await fetchAllPatients();
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }
}
