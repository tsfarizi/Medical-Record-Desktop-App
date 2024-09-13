import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart';
import 'package:medgis_app/database.dart';
import 'package:medgis_app/utils/dao/medical_record_dao.dart';
import 'package:medgis_app/utils/dao/patients_dao.dart';
import 'package:medgis_app/utils/services/pateint_service.dart';
import 'package:medgis_app/view/detail/bloc/detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final PatientDao patientDao;
  final MedicalRecordDao medicalRecordDao;

  DetailCubit(this.patientDao, this.medicalRecordDao) : super(DetailInitial());

  void setPatient(PatientWithMedicalRecords patient) async {
    // Load medical records for the patient
    final medicalRecords = await medicalRecordDao.getMedicalRecordsByPatient(
      patient.patient.registrationNumber,
    );
    final updatedPatient = PatientWithMedicalRecords(
      patient: patient.patient,
      medicalRecords: medicalRecords,
    );
    emit(DetailLoaded(updatedPatient));
  }

  void updatePatientData(String field, String newValue) async {
    if (state is DetailLoaded) {
      final patient = (state as DetailLoaded).patient;

      // Membuat salinan baru dari patient dengan nilai yang diubah
      final updatedPatient = patient.patient.copyWith(
        fullName: field == 'Name' ? newValue : patient.patient.fullName,
        birthDate: field == 'Birth Date'
            ? DateTime.parse(newValue)
            : patient.patient.birthDate,
        phone: field == 'Phone' ? newValue : patient.patient.phone,
        address: field == 'Address' ? newValue : patient.patient.address,
        gender: field == 'Gender' ? newValue : patient.patient.gender,
      );

      // Menyimpan perubahan ke database
      await patientDao.updatePatient(PatientsCompanion(
        registrationNumber: Value(updatedPatient.registrationNumber),
        fullName: Value(updatedPatient.fullName),
        birthDate: Value(updatedPatient.birthDate),
        phone: Value(updatedPatient.phone),
        address: Value(updatedPatient.address),
        gender: Value(updatedPatient.gender),
      ));

      // Mengupdate state dengan pasien yang sudah diperbarui
      final updatedPatientRecord = PatientWithMedicalRecords(
        patient: updatedPatient,
        medicalRecords: patient.medicalRecords,
      );

      emit(DetailLoaded(updatedPatientRecord)); // Emit the updated state
    }
  }

  void addMedicalRecord(String patientRegistrationNumber,
      String therapyAndDiagnosis, String anamnesaAndExamination) async {
    final newRecord = MedicalRecordsCompanion(
      patientRegistrationNumber: Value(patientRegistrationNumber),
      date: Value(DateTime.now()),
      therapyAndDiagnosis: Value(therapyAndDiagnosis),
      anamnesaAndExamination: Value(anamnesaAndExamination),
    );

    await medicalRecordDao.insertMedicalRecord(newRecord);

    // Reload the patient's medical records
    final patient = (state as DetailLoaded).patient;
    final updatedMedicalRecords = await medicalRecordDao
        .getMedicalRecordsByPatient(patient.patient.registrationNumber);

    final updatedPatientRecord = PatientWithMedicalRecords(
      patient: patient.patient,
      medicalRecords: updatedMedicalRecords,
    );

    emit(DetailLoaded(updatedPatientRecord)); // Emit the updated state
  }

  void deleteMedicalRecord(String recordId) async {
    await medicalRecordDao.deleteMedicalRecord(recordId);

    // Reload the patient's medical records
    final patient = (state as DetailLoaded).patient;
    final updatedMedicalRecords = await medicalRecordDao
        .getMedicalRecordsByPatient(patient.patient.registrationNumber);

    final updatedPatientRecord = PatientWithMedicalRecords(
      patient: patient.patient,
      medicalRecords: updatedMedicalRecords,
    );

    emit(DetailLoaded(updatedPatientRecord)); // Emit the updated state
  }

  void updateMedicalRecord(String recordId, String therapyAndDiagnosis,
      String anamnesaAndExamination) async {
    if (state is DetailLoaded) {
      final patient = (state as DetailLoaded).patient;

      // Ambil catatan medis yang ingin diperbarui
      final recordToUpdate =
          patient.medicalRecords.firstWhere((record) => record.id == recordId);

      // Buat salinan baru dari catatan medis dengan nilai yang diperbarui
      final updatedRecord = MedicalRecordsCompanion(
        id: Value(recordId),
        patientRegistrationNumber:
            Value(recordToUpdate.patientRegistrationNumber),
        date: Value(recordToUpdate.date),
        therapyAndDiagnosis: Value(therapyAndDiagnosis),
        anamnesaAndExamination: Value(anamnesaAndExamination),
      );

      // Perbarui catatan medis di database
      await medicalRecordDao.updateMedicalRecord(updatedRecord);

      // Muat ulang catatan medis untuk pasien
      final updatedMedicalRecords = await medicalRecordDao
          .getMedicalRecordsByPatient(patient.patient.registrationNumber);

      // Emit state dengan data yang diperbarui
      final updatedPatientRecord = PatientWithMedicalRecords(
        patient: patient.patient,
        medicalRecords: updatedMedicalRecords,
      );

      emit(DetailLoaded(updatedPatientRecord)); // Emit the updated state
    }
  }
}
