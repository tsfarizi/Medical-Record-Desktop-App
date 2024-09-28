import 'dart:io';
import 'package:flutter/services.dart';
import 'package:medgis_app/utils/dao/medical_record_dao.dart';
import 'package:medgis_app/utils/dao/patients_dao.dart';
import 'package:medgis_app/utils/models/medical_record_model.dart';
import 'package:medgis_app/utils/models/patient_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PatientWithMedicalRecords {
  final Patient patient;
  final List<MedicalRecord> medicalRecords;
  final DateTime? registered;
  final DateTime? lastVisited;

  PatientWithMedicalRecords({
    required this.patient,
    required this.medicalRecords,
    this.registered,
    this.lastVisited,
  });
}

class PatientService {
  final PatientDao patientDao;
  final MedicalRecordDao medicalRecordDao;

  PatientService(this.patientDao, this.medicalRecordDao);

  Future<List<PatientWithMedicalRecords>> getAllPatientsWithRecords() async {
    final patients = await patientDao.getAllPatients();
    final List<PatientWithMedicalRecords> result = [];

    for (final patient in patients) {
      final medicalRecords =
          await medicalRecordDao.getMedicalRecordsByPatient(patient.id);
      final registered =
          medicalRecords.isNotEmpty ? medicalRecords.first.date : null;
      final lastVisited =
          medicalRecords.isNotEmpty ? medicalRecords.last.date : null;

      result.add(PatientWithMedicalRecords(
        patient: patient,
        medicalRecords: medicalRecords,
        registered: registered,
        lastVisited: lastVisited,
      ));
    }
    return result;
  }

  Future<List<PatientWithMedicalRecords>> getPatientsWithRecordsByIds(
      List<String> ids) async {
    if (ids.isEmpty) return [];
    final patients = await patientDao.getPatientsByIds(ids);
    final List<PatientWithMedicalRecords> result = [];

    for (final patient in patients) {
      final medicalRecords =
          await medicalRecordDao.getMedicalRecordsByPatient(patient.id);
      final registered =
          medicalRecords.isNotEmpty ? medicalRecords.first.date : null;
      final lastVisited =
          medicalRecords.isNotEmpty ? medicalRecords.last.date : null;

      result.add(PatientWithMedicalRecords(
        patient: patient,
        medicalRecords: medicalRecords,
        registered: registered,
        lastVisited: lastVisited,
      ));
    }
    return result;
  }

  Future<void> deletePatient(String patientId) async {
    await patientDao.deletePatient(patientId);
  }

  Future<void> printSinglePatientData(
      PatientWithMedicalRecords patientRecord, String filePath) async {
    final pdf = pw.Document();

    final fontBold =
        pw.Font.ttf(await rootBundle.load('assets/Roboto-Bold.ttf'));
    final fontRegular =
        pw.Font.ttf(await rootBundle.load('assets/Roboto-Regular.ttf'));

    final imageData = await rootBundle.load('assets/medgis.jpg');
    final logo = pw.MemoryImage(imageData.buffer.asUint8List());

    final headerTextStyle =
        pw.TextStyle(font: fontBold, fontSize: 16, color: PdfColors.blue);

    final tableHeaderStyle =
        pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.white);

    final tableRowStyle = pw.TextStyle(font: fontRegular, fontSize: 11);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ),
        ),
        header: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.centerLeft,
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(logo, width: 50),
              pw.SizedBox(width: 10),
              pw.Text(
                'Clinic',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 20,
                  color: PdfColors.blueGrey800,
                ),
              ),
            ],
          ),
        ),
        footer: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 20),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
          ),
        ),
        build: (pw.Context context) => [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 16),
            child: pw.Text(
              'Patient Information',
              style: headerTextStyle,
            ),
          ),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
              color: PdfColors.grey100,
            ),
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildPatientInfoRow('Full Name:',
                    patientRecord.patient.fullName, fontBold, fontRegular),
                _buildPatientInfoRow('Phone:', patientRecord.patient.phone,
                    fontBold, fontRegular),
                _buildPatientInfoRow(
                    'Birth Date:',
                    _formatDate(patientRecord.patient.birthDate),
                    fontBold,
                    fontRegular),
                _buildPatientInfoRow('Address:', patientRecord.patient.address,
                    fontBold, fontRegular),
                _buildPatientInfoRow('Gender:', patientRecord.patient.gender,
                    fontBold, fontRegular),
                _buildPatientInfoRow(
                    'Registered:',
                    _formatDate(patientRecord.registered),
                    fontBold,
                    fontRegular),
                _buildPatientInfoRow(
                    'Last Visited:',
                    _formatDate(patientRecord.lastVisited),
                    fontBold,
                    fontRegular),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 16),
            child: pw.Text(
              'Medical Records',
              style: headerTextStyle,
            ),
          ),
          pw.Divider(),
          pw.SizedBox(height: 10),
          _buildMedicalRecordsTable(
              patientRecord, tableHeaderStyle, tableRowStyle),
        ],
      ),
    );

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }

  pw.Widget _buildPatientInfoRow(
      String label, String? value, pw.Font fontBold, pw.Font fontRegular) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              label,
              style: pw.TextStyle(font: fontBold),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value ?? '',
              style: pw.TextStyle(font: fontRegular),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMedicalRecordsTable(
    PatientWithMedicalRecords patientRecord,
    pw.TextStyle headerStyle,
    pw.TextStyle rowStyle,
  ) {
    final headers = [
      'Date',
      'Therapy and Diagnosis',
      'Anamnesa and Examination',
    ];
    final data = patientRecord.medicalRecords.map((record) {
      return [
        _formatDate(record.date),
        record.therapyAndDiagnosis,
        record.anamnesaAndExamination,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: headerStyle,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellStyle: rowStyle,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
      },
      border: pw.TableBorder.all(color: PdfColors.grey300),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> updatePatientBloodPressure(
      String patientId, String bloodPressure) async {
    await patientDao.updatePatientBloodPressure(patientId, bloodPressure);
  }

  Future<void> addMedicalRecordToPatient(
      String patientId, MedicalRecord record) async {
    await medicalRecordDao.insertMedicalRecord(record);
  }
}
