import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Patients extends Table {
  TextColumn get registrationNumber => text()
      .clientDefault(() => const Uuid().v4())
      .withLength(min: 1, max: 100)
      .customConstraint('UNIQUE NOT NULL')
      .named('registration_number')();

  TextColumn get fullName =>
      text().withLength(min: 1, max: 255).named('full_name')();
  TextColumn get address =>
      text().withLength(min: 1, max: 300).named('address')();
  TextColumn get gender => text().withLength(min: 1, max: 10).named('gender')();
  DateTimeColumn get birthDate => dateTime().named('birth_date')();
  TextColumn get phone => text().withLength(min: 1, max: 15).named('phone')();

  @override
  Set<Column> get primaryKey => {registrationNumber};
}

class MedicalRecords extends Table {
  TextColumn get id => text()
      .clientDefault(() => const Uuid().v4())
      .withLength(min: 1, max: 100)
      .customConstraint('UNIQUE NOT NULL')
      .named('id')();

  TextColumn get patientRegistrationNumber => text()
      .customConstraint('REFERENCES patients(registration_number) NOT NULL')
      .named('patient_registration_number')();

  DateTimeColumn get date =>
      dateTime().clientDefault(() => DateTime.now()).named('date')();
  TextColumn get therapyAndDiagnosis => text().named('therapy_and_diagnosis')();
  TextColumn get anamnesaAndExamination =>
      text().named('anamnesa_and_examination')();

  @override
  Set<Column> get primaryKey => {id};
}
