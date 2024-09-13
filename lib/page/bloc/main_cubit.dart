import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:csv/csv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/bloc/main_state.dart';
import 'package:medgis_app/utils/dao/patients_dao.dart';
import 'package:medgis_app/utils/dao/medical_record_dao.dart';

class MainCubit extends Cubit<MainState> {
  final PatientDao patientDao;
  final MedicalRecordDao medicalRecordDao;

  MainCubit(this.patientDao, this.medicalRecordDao) : super(HomeViewState());

  void setState(MainState state) {
    emit(state);
  }

  Future<void> extractDataToCSVAndZip() async {
    try {
      final List<List<String>> patientsCsvData = await _extractPatientsToCsv();
      final List<List<String>> medicalRecordsCsvData =
          await _extractMedicalRecordsToCsv();

      final Directory downloadsDirectory = await getDownloadsDirectory();
      final String patientsCsvFilePath =
          '${downloadsDirectory.path}/patients.csv';
      final String medicalRecordsCsvFilePath =
          '${downloadsDirectory.path}/medical_records.csv';

      await _saveCsvToFile(patientsCsvData, patientsCsvFilePath);
      await _saveCsvToFile(medicalRecordsCsvData, medicalRecordsCsvFilePath);

      final String zipFilePath = '${downloadsDirectory.path}/data_export.zip';
      await _createZipFile(
          [patientsCsvFilePath, medicalRecordsCsvFilePath], zipFilePath);

      emit(HomeViewState());
    } catch (e) {
      emit(MainFailure('Error during extraction: $e'));
    }
  }

  Future<List<List<String>>> _extractPatientsToCsv() async {
    final patients = await patientDao.getAllPatients();
    List<List<String>> rows = [
      [
        'Registration Number',
        'Full Name',
        'Address',
        'Gender',
        'Birth Date',
        'Phone'
      ]
    ];

    for (var patient in patients) {
      rows.add([
        patient.registrationNumber,
        patient.fullName,
        patient.address,
        patient.gender,
        patient.birthDate.toIso8601String(),
        patient.phone,
      ]);
    }

    return rows;
  }

  Future<List<List<String>>> _extractMedicalRecordsToCsv() async {
    final medicalRecords = await medicalRecordDao.getAllMedicalRecords();
    List<List<String>> rows = [
      [
        'ID',
        'Patient Registration Number',
        'Date',
        'Therapy and Diagnosis',
        'Anamnesa and Examination'
      ]
    ];

    for (var record in medicalRecords) {
      rows.add([
        record.id,
        record.patientRegistrationNumber,
        record.date.toIso8601String(),
        record.therapyAndDiagnosis,
        record.anamnesaAndExamination,
      ]);
    }

    return rows;
  }

  Future<void> _saveCsvToFile(
      List<List<String>> csvData, String filePath) async {
    String csv = const ListToCsvConverter().convert(csvData);
    final File file = File(filePath);
    await file.writeAsString(csv);
  }

  Future<void> _createZipFile(
      List<String> filePaths, String zipFilePath) async {
    final archive = Archive();

    for (String path in filePaths) {
      final file = File(path);
      final bytes = await file.readAsBytes();
      final fileName = path.split('/').last;
      archive.addFile(ArchiveFile(fileName, bytes.length, bytes));
    }

    final zipData = ZipEncoder().encode(archive);
    final zipFile = File(zipFilePath);
    await zipFile.writeAsBytes(zipData!);
  }

  Future<Directory> getDownloadsDirectory() async {
    if (Platform.isWindows) {
      final directory = await getDownloadsDirectory();
      return directory;
    } else {
      throw UnsupportedError("This feature is only supported on Windows.");
    }
  }
}
