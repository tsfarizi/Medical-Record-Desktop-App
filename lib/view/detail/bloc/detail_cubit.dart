import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/utils/dao/medical_record_dao.dart';
import 'package:medgis_app/utils/dao/patients_dao.dart';
import 'package:medgis_app/utils/models/patient_model.dart';
import 'package:medgis_app/utils/models/medical_record_model.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/view/detail/bloc/detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final PatientDao patientDao;
  final MedicalRecordDao medicalRecordDao;

  DetailCubit(this.patientDao, this.medicalRecordDao) : super(DetailInitial());

  void setPatient(PatientWithMedicalRecords patient) async {
    final medicalRecords =
        await medicalRecordDao.getMedicalRecordsByPatient(patient.patient.id);
    final updatedPatient = PatientWithMedicalRecords(
      patient: patient.patient,
      medicalRecords: medicalRecords,
    );
    emit(DetailLoaded(updatedPatient));
  }

  void updatePatientData(String field, String newValue) async {
    if (state is DetailLoaded) {
      final patientWithRecords = (state as DetailLoaded).patient;

      final updatedPatient = patientWithRecords.patient.copyWith(
        fullName:
            field == 'Name' ? newValue : patientWithRecords.patient.fullName,
        birthDate: field == 'Birth Date'
            ? DateTime.parse(newValue)
            : patientWithRecords.patient.birthDate,
        phone: field == 'Phone' ? newValue : patientWithRecords.patient.phone,
        address:
            field == 'Address' ? newValue : patientWithRecords.patient.address,
        gender:
            field == 'Gender' ? newValue : patientWithRecords.patient.gender,
      );

      await patientDao.updatePatient(updatedPatient);

      final updatedPatientRecord = PatientWithMedicalRecords(
        patient: updatedPatient,
        medicalRecords: patientWithRecords.medicalRecords,
      );

      emit(DetailLoaded(updatedPatientRecord));
    }
  }

  void addMedicalRecord(String patientId, String therapyAndDiagnosis,
      String anamnesaAndExamination) async {
    try {
      final newRecord = MedicalRecord(
        id: '',
        patientId: patientId,
        date: DateTime.now(),
        therapyAndDiagnosis: therapyAndDiagnosis,
        anamnesaAndExamination: anamnesaAndExamination,
      );
      await medicalRecordDao.insertMedicalRecord(newRecord);

      final updatedMedicalRecords =
          await medicalRecordDao.getMedicalRecordsByPatient(patientId);

      final updatedPatientRecord = PatientWithMedicalRecords(
        patient: (state as DetailLoaded).patient.patient,
        medicalRecords: updatedMedicalRecords,
      );

      emit(DetailLoaded(updatedPatientRecord));
    } catch (e) {
      emit(DetailFailure("Gagal menambahkan rekam medis: ${e.toString()}"));
    }
  }

  void deleteMedicalRecord(String recordId) async {
    await medicalRecordDao.deleteMedicalRecord(recordId);

    final patientWithRecords = (state as DetailLoaded).patient;
    final updatedMedicalRecords = await medicalRecordDao
        .getMedicalRecordsByPatient(patientWithRecords.patient.id);

    final updatedPatientRecord = PatientWithMedicalRecords(
      patient: patientWithRecords.patient,
      medicalRecords: updatedMedicalRecords,
    );

    emit(DetailLoaded(updatedPatientRecord));
  }

  void updateMedicalRecord(String recordId, String therapyAndDiagnosis,
      String anamnesaAndExamination) async {
    if (state is DetailLoaded) {
      final patientWithRecords = (state as DetailLoaded).patient;

      final recordToUpdate = patientWithRecords.medicalRecords
          .firstWhere((record) => record.id == recordId);

      final updatedRecord = recordToUpdate.copyWith(
        therapyAndDiagnosis: therapyAndDiagnosis,
        anamnesaAndExamination: anamnesaAndExamination,
      );

      await medicalRecordDao.updateMedicalRecord(updatedRecord);

      final updatedMedicalRecords = await medicalRecordDao
          .getMedicalRecordsByPatient(patientWithRecords.patient.id);

      final updatedPatientRecord = PatientWithMedicalRecords(
        patient: patientWithRecords.patient,
        medicalRecords: updatedMedicalRecords,
      );

      emit(DetailLoaded(updatedPatientRecord));
    }
  }
}

extension PatientCopyWith on Patient {
  Patient copyWith({
    String? id,
    int? registrationNumber,
    String? fullName,
    String? address,
    String? gender,
    DateTime? birthDate,
    String? phone,
  }) {
    return Patient(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
    );
  }
}

extension MedicalRecordCopyWith on MedicalRecord {
  MedicalRecord copyWith({
    String? id,
    String? patientId,
    DateTime? date,
    String? therapyAndDiagnosis,
    String? anamnesaAndExamination,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      date: date ?? this.date,
      therapyAndDiagnosis: therapyAndDiagnosis ?? this.therapyAndDiagnosis,
      anamnesaAndExamination:
          anamnesaAndExamination ?? this.anamnesaAndExamination,
    );
  }
}
