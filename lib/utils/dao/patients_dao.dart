import 'package:drift/drift.dart';
import 'package:medgis_app/database.dart';
import 'package:medgis_app/utils/models/patient_model.dart';

part 'patients_dao.g.dart';

@DriftAccessor(tables: [Patients])
class PatientDao extends DatabaseAccessor<AppDatabase> with _$PatientDaoMixin {
  final AppDatabase db;

  PatientDao(this.db) : super(db);

  Future<List<Patient>> getAllPatients() => select(patients).get();

  Future<Patient?> getPatientById(String registrationNumber) {
    return (select(patients)
          ..where((tbl) => tbl.registrationNumber.equals(registrationNumber)))
        .getSingleOrNull();
  }

  Future<void> insertPatient(PatientsCompanion patient) =>
      into(patients).insert(patient);

  Future<void> updatePatient(PatientsCompanion patient) =>
      update(patients).replace(patient);

  Future<void> deletePatient(String registrationNumber) {
    return (delete(patients)
          ..where((tbl) => tbl.registrationNumber.equals(registrationNumber)))
        .go();
  }
}
