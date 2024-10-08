import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/utils/models/patient_model.dart';
import 'package:medgis_app/utils/models/queue_model.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/utils/dao/queue_dao.dart';
import 'package:medgis_app/view/queue/bloc/queue_state.dart';
import 'package:medgis_app/utils/models/medical_record_model.dart';

class QueueCubit extends Cubit<QueueState> {
  final PatientService patientService;
  final QueueDao queueDao;
  late StreamSubscription<Queue> _queueSubscription;

  QueueCubit(this.patientService, this.queueDao) : super(QueueInitial()) {
    _queueSubscription = queueDao.queueStream.listen((queueData) {
      fetchAllPatients();
    });
  }

  @override
  Future<void> close() {
    _queueSubscription.cancel();
    return super.close();
  }

  Future<void> fetchAllPatients() async {
    emit(QueueLoading());
    try {
      final allPatients = await patientService.getAllPatientsWithRecords();
      final queue = await queueDao.getCurrentQueue();
      final queuePatientsIds = queue?.patients ?? [];

      final queuePatients = allPatients
          .where((p) => queuePatientsIds.contains(p.patient.id))
          .toList();

      emit(QueueSuccess(
        allPatients: allPatients,
        queuePatients: queuePatients,
      ));
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  Future<void> addToQueue(String patientId) async {
    try {
      await queueDao.addPatientToQueue(patientId);
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  Future<void> removeFromQueue(String patientId) async {
    try {
      await queueDao.removePatientFromQueue(patientId);
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  Future<void> updateBloodPressureNow(
      String patientId, String bloodPressureNow) async {
    emit(QueueLoading());
    try {
      await patientService.updatePatientBloodPressureNow(
          patientId, bloodPressureNow);
      await fetchAllPatients();
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  Future<void> setMedicalRecord(Patient patient, MedicalRecord record) async {
    emit(QueueLoading());
    try {
      if (patient.medicalRecordNow!.isNotEmpty) {
        await patientService.updateMedicalRecord(patient.id, record);
      } else {
        final insertedRecord =
            await patientService.addMedicalRecordToPatient(patient.id, record);
        await patientService.addMedicalRecordNow(patient.id, insertedRecord.id);
      }
      await fetchAllPatients();
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  Future<void> deleteAllMedicalRecordNow(Queue queue) async {
    for (var patient in queue.patients) {
      await patientService.deleteMedicalRecordNow(patient);
    }
  }

  Future<MedicalRecord?> getExistingMedicalRecord(String medrecId) async {
    return patientService.getMedicalRecordNow(medrecId);
  }

  Future<void> closeQueue() async {
    emit(QueueLoading());
    try {
      final queue = await queueDao.getCurrentQueue();
      if (queue != null) {
        for (String patientId in queue.patients) {
          await patientService.updatePatientBloodPressureFromNow(patientId);
        }
      }
      deleteAllMedicalRecordNow(queue!);
      await queueDao.closeQueue();
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  PatientWithMedicalRecords? getMostRecentPatient() {
    if (state is QueueSuccess) {
      final patients = (state as QueueSuccess).queuePatients;
      if (patients.isNotEmpty) {
        return patients.last;
      }
    }
    return null;
  }
}
