import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/utils/dao/queue_dao.dart';
import 'package:medgis_app/view/queue/bloc/queue_state.dart';
import 'package:medgis_app/utils/models/medical_record_model.dart';

class QueueCubit extends Cubit<QueueState> {
  final PatientService patientService;
  final QueueDao queueDao;
  List<QueuePatientData> localQueuePatients = [];

  QueueCubit(this.patientService, this.queueDao) : super(QueueInitial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadLocalQueue();
    await fetchAllPatients();
  }

  Future<void> _loadLocalQueue() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? queuePatientJsonList =
        prefs.getStringList('localQueuePatients');
    if (queuePatientJsonList != null) {
      localQueuePatients = queuePatientJsonList
          .map((jsonStr) => QueuePatientData.fromJson(jsonDecode(jsonStr)))
          .toList();
    }
  }

  Future<void> _saveLocalQueue() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> queuePatientJsonList =
        localQueuePatients.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('localQueuePatients', queuePatientJsonList);
  }

  Future<void> fetchAllPatients() async {
    emit(QueueLoading());
    try {
      final allPatients = await patientService.getAllPatientsWithRecords();
      emit(QueueSuccess(
        allPatients: allPatients,
        queuePatients: localQueuePatients,
      ));
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  void addToLocalQueue(String patientId) {
    if (!localQueuePatients.any((p) => p.patientId == patientId)) {
      localQueuePatients.add(QueuePatientData(patientId: patientId));
      _saveLocalQueue();
      _emitSuccessState();
    }
  }

  void removeFromLocalQueue(String patientId) {
    localQueuePatients.removeWhere((p) => p.patientId == patientId);
    _saveLocalQueue();
    _emitSuccessState();
  }

  void updateBloodPressure(String patientId, String bloodPressure) {
    final queuePatientIndex =
        localQueuePatients.indexWhere((p) => p.patientId == patientId);
    QueuePatientData queuePatient;

    if (queuePatientIndex != -1) {
      queuePatient = localQueuePatients[queuePatientIndex];
    } else {
      queuePatient = QueuePatientData(patientId: patientId);
      localQueuePatients.add(queuePatient);
    }

    queuePatient.bloodPressure = bloodPressure;
    _saveLocalQueue();
    _emitSuccessState();
  }

  void setMedicalRecord(String patientId, MedicalRecord record) {
    final queuePatientIndex =
        localQueuePatients.indexWhere((p) => p.patientId == patientId);
    QueuePatientData queuePatient;

    if (queuePatientIndex != -1) {
      queuePatient = localQueuePatients[queuePatientIndex];
    } else {
      queuePatient = QueuePatientData(patientId: patientId);
      localQueuePatients.add(queuePatient);
    }

    // Menggunakan hanya satu rekam medis per pasien
    if (queuePatient.medicalRecords.isEmpty) {
      queuePatient.medicalRecords.add(record);
    } else {
      queuePatient.medicalRecords[0] = record;
    }

    _saveLocalQueue();
    _emitSuccessState();
  }

  Future<void> submitQueueToDatabase() async {
    if (localQueuePatients.isEmpty) return;
    emit(QueueLoading());
    try {
      for (var queuePatient in localQueuePatients) {
        if (queuePatient.bloodPressure != null) {
          await patientService.updatePatientBloodPressure(
              queuePatient.patientId, queuePatient.bloodPressure!);
        }
        if (queuePatient.medicalRecords.isNotEmpty) {
          for (var record in queuePatient.medicalRecords) {
            await patientService.addMedicalRecordToPatient(
                queuePatient.patientId, record);
          }
        }
      }
      await queueDao
          .insertQueue(localQueuePatients.map((p) => p.patientId).toList());
      localQueuePatients.clear();
      await _saveLocalQueue();
      await fetchAllPatients();
    } catch (e) {
      emit(QueueFailure(e.toString()));
    }
  }

  void _emitSuccessState() {
    if (state is QueueSuccess || state is QueueInitial) {
      emit(QueueSuccess(
        allPatients:
            state is QueueSuccess ? (state as QueueSuccess).allPatients : [],
        queuePatients: localQueuePatients,
      ));
    }
  }

  PatientWithMedicalRecords? getMostRecentPatient() {
    if (state is QueueSuccess) {
      final patients = (state as QueueSuccess).allPatients;
      if (patients.isNotEmpty) {
        return patients.last;
      }
    }
    return null;
  }
}
