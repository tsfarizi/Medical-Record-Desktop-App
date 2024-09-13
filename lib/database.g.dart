// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: invalid_use_of_internal_member

part of 'database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String> registrationNumber =
      GeneratedColumn<String>('registration_number', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 1, maxTextLength: 100),
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          $customConstraints: 'UNIQUE NOT NULL',
          clientDefault: () => const Uuid().v4());
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 300),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _birthDateMeta =
      const VerificationMeta('birthDate');
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
      'birth_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [registrationNumber, fullName, address, gender, birthDate, phone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(Insertable<Patient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('registration_number')) {
      context.handle(
          _registrationNumberMeta,
          registrationNumber.isAcceptableOrUnknown(
              data['registration_number']!, _registrationNumberMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(_birthDateMeta,
          birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta));
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {registrationNumber};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      registrationNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}registration_number'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      birthDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birth_date'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final String registrationNumber;
  final String fullName;
  final String address;
  final String gender;
  final DateTime birthDate;
  final String phone;
  const Patient(
      {required this.registrationNumber,
      required this.fullName,
      required this.address,
      required this.gender,
      required this.birthDate,
      required this.phone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['registration_number'] = Variable<String>(registrationNumber);
    map['full_name'] = Variable<String>(fullName);
    map['address'] = Variable<String>(address);
    map['gender'] = Variable<String>(gender);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['phone'] = Variable<String>(phone);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      registrationNumber: Value(registrationNumber),
      fullName: Value(fullName),
      address: Value(address),
      gender: Value(gender),
      birthDate: Value(birthDate),
      phone: Value(phone),
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      registrationNumber:
          serializer.fromJson<String>(json['registrationNumber']),
      fullName: serializer.fromJson<String>(json['fullName']),
      address: serializer.fromJson<String>(json['address']),
      gender: serializer.fromJson<String>(json['gender']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      phone: serializer.fromJson<String>(json['phone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'registrationNumber': serializer.toJson<String>(registrationNumber),
      'fullName': serializer.toJson<String>(fullName),
      'address': serializer.toJson<String>(address),
      'gender': serializer.toJson<String>(gender),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'phone': serializer.toJson<String>(phone),
    };
  }

  Patient copyWith(
          {String? registrationNumber,
          String? fullName,
          String? address,
          String? gender,
          DateTime? birthDate,
          String? phone}) =>
      Patient(
        registrationNumber: registrationNumber ?? this.registrationNumber,
        fullName: fullName ?? this.fullName,
        address: address ?? this.address,
        gender: gender ?? this.gender,
        birthDate: birthDate ?? this.birthDate,
        phone: phone ?? this.phone,
      );
  Patient copyWithCompanion(PatientsCompanion data) {
    return Patient(
      registrationNumber: data.registrationNumber.present
          ? data.registrationNumber.value
          : this.registrationNumber,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      address: data.address.present ? data.address.value : this.address,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      phone: data.phone.present ? data.phone.value : this.phone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('fullName: $fullName, ')
          ..write('address: $address, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      registrationNumber, fullName, address, gender, birthDate, phone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.registrationNumber == this.registrationNumber &&
          other.fullName == this.fullName &&
          other.address == this.address &&
          other.gender == this.gender &&
          other.birthDate == this.birthDate &&
          other.phone == this.phone);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<String> registrationNumber;
  final Value<String> fullName;
  final Value<String> address;
  final Value<String> gender;
  final Value<DateTime> birthDate;
  final Value<String> phone;
  final Value<int> rowid;
  const PatientsCompanion({
    this.registrationNumber = const Value.absent(),
    this.fullName = const Value.absent(),
    this.address = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.phone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    this.registrationNumber = const Value.absent(),
    required String fullName,
    required String address,
    required String gender,
    required DateTime birthDate,
    required String phone,
    this.rowid = const Value.absent(),
  })  : fullName = Value(fullName),
        address = Value(address),
        gender = Value(gender),
        birthDate = Value(birthDate),
        phone = Value(phone);
  static Insertable<Patient> custom({
    Expression<String>? registrationNumber,
    Expression<String>? fullName,
    Expression<String>? address,
    Expression<String>? gender,
    Expression<DateTime>? birthDate,
    Expression<String>? phone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (fullName != null) 'full_name': fullName,
      if (address != null) 'address': address,
      if (gender != null) 'gender': gender,
      if (birthDate != null) 'birth_date': birthDate,
      if (phone != null) 'phone': phone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith(
      {Value<String>? registrationNumber,
      Value<String>? fullName,
      Value<String>? address,
      Value<String>? gender,
      Value<DateTime>? birthDate,
      Value<String>? phone,
      Value<int>? rowid}) {
    return PatientsCompanion(
      registrationNumber: registrationNumber ?? this.registrationNumber,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (registrationNumber.present) {
      map['registration_number'] = Variable<String>(registrationNumber.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('fullName: $fullName, ')
          ..write('address: $address, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('phone: $phone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicalRecordsTable extends MedicalRecords
    with TableInfo<$MedicalRecordsTable, MedicalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'UNIQUE NOT NULL',
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _patientRegistrationNumberMeta =
      const VerificationMeta('patientRegistrationNumber');
  @override
  late final GeneratedColumn<String> patientRegistrationNumber =
      GeneratedColumn<String>('patient_registration_number', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          $customConstraints:
              'REFERENCES patients(registration_number) NOT NULL');
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _therapyAndDiagnosisMeta =
      const VerificationMeta('therapyAndDiagnosis');
  @override
  late final GeneratedColumn<String> therapyAndDiagnosis =
      GeneratedColumn<String>('therapy_and_diagnosis', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _anamnesaAndExaminationMeta =
      const VerificationMeta('anamnesaAndExamination');
  @override
  late final GeneratedColumn<String> anamnesaAndExamination =
      GeneratedColumn<String>('anamnesa_and_examination', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientRegistrationNumber,
        date,
        therapyAndDiagnosis,
        anamnesaAndExamination
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_records';
  @override
  VerificationContext validateIntegrity(Insertable<MedicalRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_registration_number')) {
      context.handle(
          _patientRegistrationNumberMeta,
          patientRegistrationNumber.isAcceptableOrUnknown(
              data['patient_registration_number']!,
              _patientRegistrationNumberMeta));
    } else if (isInserting) {
      context.missing(_patientRegistrationNumberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('therapy_and_diagnosis')) {
      context.handle(
          _therapyAndDiagnosisMeta,
          therapyAndDiagnosis.isAcceptableOrUnknown(
              data['therapy_and_diagnosis']!, _therapyAndDiagnosisMeta));
    } else if (isInserting) {
      context.missing(_therapyAndDiagnosisMeta);
    }
    if (data.containsKey('anamnesa_and_examination')) {
      context.handle(
          _anamnesaAndExaminationMeta,
          anamnesaAndExamination.isAcceptableOrUnknown(
              data['anamnesa_and_examination']!, _anamnesaAndExaminationMeta));
    } else if (isInserting) {
      context.missing(_anamnesaAndExaminationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientRegistrationNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}patient_registration_number'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      therapyAndDiagnosis: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}therapy_and_diagnosis'])!,
      anamnesaAndExamination: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}anamnesa_and_examination'])!,
    );
  }

  @override
  $MedicalRecordsTable createAlias(String alias) {
    return $MedicalRecordsTable(attachedDatabase, alias);
  }
}

class MedicalRecord extends DataClass implements Insertable<MedicalRecord> {
  final String id;
  final String patientRegistrationNumber;
  final DateTime date;
  final String therapyAndDiagnosis;
  final String anamnesaAndExamination;
  const MedicalRecord(
      {required this.id,
      required this.patientRegistrationNumber,
      required this.date,
      required this.therapyAndDiagnosis,
      required this.anamnesaAndExamination});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_registration_number'] =
        Variable<String>(patientRegistrationNumber);
    map['date'] = Variable<DateTime>(date);
    map['therapy_and_diagnosis'] = Variable<String>(therapyAndDiagnosis);
    map['anamnesa_and_examination'] = Variable<String>(anamnesaAndExamination);
    return map;
  }

  MedicalRecordsCompanion toCompanion(bool nullToAbsent) {
    return MedicalRecordsCompanion(
      id: Value(id),
      patientRegistrationNumber: Value(patientRegistrationNumber),
      date: Value(date),
      therapyAndDiagnosis: Value(therapyAndDiagnosis),
      anamnesaAndExamination: Value(anamnesaAndExamination),
    );
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalRecord(
      id: serializer.fromJson<String>(json['id']),
      patientRegistrationNumber:
          serializer.fromJson<String>(json['patientRegistrationNumber']),
      date: serializer.fromJson<DateTime>(json['date']),
      therapyAndDiagnosis:
          serializer.fromJson<String>(json['therapyAndDiagnosis']),
      anamnesaAndExamination:
          serializer.fromJson<String>(json['anamnesaAndExamination']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientRegistrationNumber':
          serializer.toJson<String>(patientRegistrationNumber),
      'date': serializer.toJson<DateTime>(date),
      'therapyAndDiagnosis': serializer.toJson<String>(therapyAndDiagnosis),
      'anamnesaAndExamination':
          serializer.toJson<String>(anamnesaAndExamination),
    };
  }

  MedicalRecord copyWith(
          {String? id,
          String? patientRegistrationNumber,
          DateTime? date,
          String? therapyAndDiagnosis,
          String? anamnesaAndExamination}) =>
      MedicalRecord(
        id: id ?? this.id,
        patientRegistrationNumber:
            patientRegistrationNumber ?? this.patientRegistrationNumber,
        date: date ?? this.date,
        therapyAndDiagnosis: therapyAndDiagnosis ?? this.therapyAndDiagnosis,
        anamnesaAndExamination:
            anamnesaAndExamination ?? this.anamnesaAndExamination,
      );
  MedicalRecord copyWithCompanion(MedicalRecordsCompanion data) {
    return MedicalRecord(
      id: data.id.present ? data.id.value : this.id,
      patientRegistrationNumber: data.patientRegistrationNumber.present
          ? data.patientRegistrationNumber.value
          : this.patientRegistrationNumber,
      date: data.date.present ? data.date.value : this.date,
      therapyAndDiagnosis: data.therapyAndDiagnosis.present
          ? data.therapyAndDiagnosis.value
          : this.therapyAndDiagnosis,
      anamnesaAndExamination: data.anamnesaAndExamination.present
          ? data.anamnesaAndExamination.value
          : this.anamnesaAndExamination,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalRecord(')
          ..write('id: $id, ')
          ..write('patientRegistrationNumber: $patientRegistrationNumber, ')
          ..write('date: $date, ')
          ..write('therapyAndDiagnosis: $therapyAndDiagnosis, ')
          ..write('anamnesaAndExamination: $anamnesaAndExamination')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientRegistrationNumber, date,
      therapyAndDiagnosis, anamnesaAndExamination);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalRecord &&
          other.id == this.id &&
          other.patientRegistrationNumber == this.patientRegistrationNumber &&
          other.date == this.date &&
          other.therapyAndDiagnosis == this.therapyAndDiagnosis &&
          other.anamnesaAndExamination == this.anamnesaAndExamination);
}

class MedicalRecordsCompanion extends UpdateCompanion<MedicalRecord> {
  final Value<String> id;
  final Value<String> patientRegistrationNumber;
  final Value<DateTime> date;
  final Value<String> therapyAndDiagnosis;
  final Value<String> anamnesaAndExamination;
  final Value<int> rowid;
  const MedicalRecordsCompanion({
    this.id = const Value.absent(),
    this.patientRegistrationNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.therapyAndDiagnosis = const Value.absent(),
    this.anamnesaAndExamination = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicalRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String patientRegistrationNumber,
    this.date = const Value.absent(),
    required String therapyAndDiagnosis,
    required String anamnesaAndExamination,
    this.rowid = const Value.absent(),
  })  : patientRegistrationNumber = Value(patientRegistrationNumber),
        therapyAndDiagnosis = Value(therapyAndDiagnosis),
        anamnesaAndExamination = Value(anamnesaAndExamination);
  static Insertable<MedicalRecord> custom({
    Expression<String>? id,
    Expression<String>? patientRegistrationNumber,
    Expression<DateTime>? date,
    Expression<String>? therapyAndDiagnosis,
    Expression<String>? anamnesaAndExamination,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientRegistrationNumber != null)
        'patient_registration_number': patientRegistrationNumber,
      if (date != null) 'date': date,
      if (therapyAndDiagnosis != null)
        'therapy_and_diagnosis': therapyAndDiagnosis,
      if (anamnesaAndExamination != null)
        'anamnesa_and_examination': anamnesaAndExamination,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicalRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientRegistrationNumber,
      Value<DateTime>? date,
      Value<String>? therapyAndDiagnosis,
      Value<String>? anamnesaAndExamination,
      Value<int>? rowid}) {
    return MedicalRecordsCompanion(
      id: id ?? this.id,
      patientRegistrationNumber:
          patientRegistrationNumber ?? this.patientRegistrationNumber,
      date: date ?? this.date,
      therapyAndDiagnosis: therapyAndDiagnosis ?? this.therapyAndDiagnosis,
      anamnesaAndExamination:
          anamnesaAndExamination ?? this.anamnesaAndExamination,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientRegistrationNumber.present) {
      map['patient_registration_number'] =
          Variable<String>(patientRegistrationNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (therapyAndDiagnosis.present) {
      map['therapy_and_diagnosis'] =
          Variable<String>(therapyAndDiagnosis.value);
    }
    if (anamnesaAndExamination.present) {
      map['anamnesa_and_examination'] =
          Variable<String>(anamnesaAndExamination.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('patientRegistrationNumber: $patientRegistrationNumber, ')
          ..write('date: $date, ')
          ..write('therapyAndDiagnosis: $therapyAndDiagnosis, ')
          ..write('anamnesaAndExamination: $anamnesaAndExamination, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $MedicalRecordsTable medicalRecords = $MedicalRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [patients, medicalRecords];
}

typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({
  Value<String> registrationNumber,
  required String fullName,
  required String address,
  required String gender,
  required DateTime birthDate,
  required String phone,
  Value<int> rowid,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<String> registrationNumber,
  Value<String> fullName,
  Value<String> address,
  Value<String> gender,
  Value<DateTime> birthDate,
  Value<String> phone,
  Value<int> rowid,
});

final class $$PatientsTableReferences
    extends BaseReferences<_$AppDatabase, $PatientsTable, Patient> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicalRecordsTable, List<MedicalRecord>>
      _medicalRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.medicalRecords,
              aliasName: $_aliasNameGenerator(db.patients.registrationNumber,
                  db.medicalRecords.patientRegistrationNumber));

  $$MedicalRecordsTableProcessedTableManager get medicalRecordsRefs {
    final manager = $$MedicalRecordsTableTableManager($_db, $_db.medicalRecords)
        .filter((f) => f.patientRegistrationNumber
            .registrationNumber($_item.registrationNumber));

    final cache = $_typedResult.readTableOrNull(_medicalRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PatientsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer(super.$state);
  ColumnFilters<String> get registrationNumber => $state.composableBuilder(
      column: $state.table.registrationNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fullName => $state.composableBuilder(
      column: $state.table.fullName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get birthDate => $state.composableBuilder(
      column: $state.table.birthDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter medicalRecordsRefs(
      ComposableFilter Function($$MedicalRecordsTableFilterComposer f) f) {
    final $$MedicalRecordsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.registrationNumber,
        referencedTable: $state.db.medicalRecords,
        getReferencedColumn: (t) => t.patientRegistrationNumber,
        builder: (joinBuilder, parentComposers) =>
            $$MedicalRecordsTableFilterComposer(ComposerState($state.db,
                $state.db.medicalRecords, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get registrationNumber => $state.composableBuilder(
      column: $state.table.registrationNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fullName => $state.composableBuilder(
      column: $state.table.fullName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get address => $state.composableBuilder(
      column: $state.table.address,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get birthDate => $state.composableBuilder(
      column: $state.table.birthDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$PatientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, $$PatientsTableReferences),
    Patient,
    PrefetchHooks Function({bool medicalRecordsRefs})> {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PatientsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PatientsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> registrationNumber = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<DateTime> birthDate = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion(
            registrationNumber: registrationNumber,
            fullName: fullName,
            address: address,
            gender: gender,
            birthDate: birthDate,
            phone: phone,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> registrationNumber = const Value.absent(),
            required String fullName,
            required String address,
            required String gender,
            required DateTime birthDate,
            required String phone,
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion.insert(
            registrationNumber: registrationNumber,
            fullName: fullName,
            address: address,
            gender: gender,
            birthDate: birthDate,
            phone: phone,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PatientsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({medicalRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicalRecordsRefs) db.medicalRecords
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicalRecordsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PatientsTableReferences
                            ._medicalRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .medicalRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.patientRegistrationNumber ==
                                    item.registrationNumber),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PatientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, $$PatientsTableReferences),
    Patient,
    PrefetchHooks Function({bool medicalRecordsRefs})>;
typedef $$MedicalRecordsTableCreateCompanionBuilder = MedicalRecordsCompanion
    Function({
  Value<String> id,
  required String patientRegistrationNumber,
  Value<DateTime> date,
  required String therapyAndDiagnosis,
  required String anamnesaAndExamination,
  Value<int> rowid,
});
typedef $$MedicalRecordsTableUpdateCompanionBuilder = MedicalRecordsCompanion
    Function({
  Value<String> id,
  Value<String> patientRegistrationNumber,
  Value<DateTime> date,
  Value<String> therapyAndDiagnosis,
  Value<String> anamnesaAndExamination,
  Value<int> rowid,
});

final class $$MedicalRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicalRecordsTable, MedicalRecord> {
  $$MedicalRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientRegistrationNumberTable(_$AppDatabase db) =>
      db.patients.createAlias($_aliasNameGenerator(
          db.medicalRecords.patientRegistrationNumber,
          db.patients.registrationNumber));

  $$PatientsTableProcessedTableManager? get patientRegistrationNumber {
    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.registrationNumber($_item.patientRegistrationNumber));
    final item =
        $_typedResult.readTableOrNull(_patientRegistrationNumberTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MedicalRecordsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MedicalRecordsTable> {
  $$MedicalRecordsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get therapyAndDiagnosis => $state.composableBuilder(
      column: $state.table.therapyAndDiagnosis,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get anamnesaAndExamination => $state.composableBuilder(
      column: $state.table.anamnesaAndExamination,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PatientsTableFilterComposer get patientRegistrationNumber {
    final $$PatientsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientRegistrationNumber,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.registrationNumber,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableFilterComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$MedicalRecordsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MedicalRecordsTable> {
  $$MedicalRecordsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get therapyAndDiagnosis => $state.composableBuilder(
      column: $state.table.therapyAndDiagnosis,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get anamnesaAndExamination =>
      $state.composableBuilder(
          column: $state.table.anamnesaAndExamination,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PatientsTableOrderingComposer get patientRegistrationNumber {
    final $$PatientsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientRegistrationNumber,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.registrationNumber,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableOrderingComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$MedicalRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicalRecordsTable,
    MedicalRecord,
    $$MedicalRecordsTableFilterComposer,
    $$MedicalRecordsTableOrderingComposer,
    $$MedicalRecordsTableCreateCompanionBuilder,
    $$MedicalRecordsTableUpdateCompanionBuilder,
    (MedicalRecord, $$MedicalRecordsTableReferences),
    MedicalRecord,
    PrefetchHooks Function({bool patientRegistrationNumber})> {
  $$MedicalRecordsTableTableManager(
      _$AppDatabase db, $MedicalRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MedicalRecordsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MedicalRecordsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientRegistrationNumber = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> therapyAndDiagnosis = const Value.absent(),
            Value<String> anamnesaAndExamination = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicalRecordsCompanion(
            id: id,
            patientRegistrationNumber: patientRegistrationNumber,
            date: date,
            therapyAndDiagnosis: therapyAndDiagnosis,
            anamnesaAndExamination: anamnesaAndExamination,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String patientRegistrationNumber,
            Value<DateTime> date = const Value.absent(),
            required String therapyAndDiagnosis,
            required String anamnesaAndExamination,
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicalRecordsCompanion.insert(
            id: id,
            patientRegistrationNumber: patientRegistrationNumber,
            date: date,
            therapyAndDiagnosis: therapyAndDiagnosis,
            anamnesaAndExamination: anamnesaAndExamination,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicalRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientRegistrationNumber = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientRegistrationNumber) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientRegistrationNumber,
                    referencedTable: $$MedicalRecordsTableReferences
                        ._patientRegistrationNumberTable(db),
                    referencedColumn: $$MedicalRecordsTableReferences
                        ._patientRegistrationNumberTable(db)
                        .registrationNumber,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MedicalRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicalRecordsTable,
    MedicalRecord,
    $$MedicalRecordsTableFilterComposer,
    $$MedicalRecordsTableOrderingComposer,
    $$MedicalRecordsTableCreateCompanionBuilder,
    $$MedicalRecordsTableUpdateCompanionBuilder,
    (MedicalRecord, $$MedicalRecordsTableReferences),
    MedicalRecord,
    PrefetchHooks Function({bool patientRegistrationNumber})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$MedicalRecordsTableTableManager get medicalRecords =>
      $$MedicalRecordsTableTableManager(_db, _db.medicalRecords);
}
