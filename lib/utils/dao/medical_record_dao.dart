import 'package:drift/drift.dart';
import 'package:medgis_app/database.dart';
import 'package:medgis_app/utils/models/patient_model.dart';

part 'medical_record_dao.g.dart';

@DriftAccessor(tables: [MedicalRecords])
class MedicalRecordDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalRecordDaoMixin {
  final AppDatabase db;

  MedicalRecordDao(this.db) : super(db);

  Future<List<MedicalRecord>> getAllMedicalRecords() =>
      select(medicalRecords).get();

  Future<MedicalRecord?> getMedicalRecordById(String id) {
    return (select(medicalRecords)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<MedicalRecord>> getMedicalRecordsByPatient(
      String registrationNumber) {
    return (select(medicalRecords)
          ..where((tbl) =>
              tbl.patientRegistrationNumber.equals(registrationNumber)))
        .get();
  }

  Future<void> insertMedicalRecord(MedicalRecordsCompanion medicalRecord) =>
      into(medicalRecords).insert(medicalRecord);

  Future<void> updateMedicalRecord(MedicalRecordsCompanion medicalRecord) =>
      update(medicalRecords).replace(medicalRecord);

  Future<void> deleteMedicalRecord(String id) {
    return (delete(medicalRecords)..where((tbl) => tbl.id.equals(id))).go();
  }
}
