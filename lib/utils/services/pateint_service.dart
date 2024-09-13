import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:medgis_app/database.dart';
import 'package:medgis_app/utils/dao/medical_record_dao.dart';
import 'package:medgis_app/utils/dao/patients_dao.dart';

class PatientService {
  final PatientDao patientDao;
  final MedicalRecordDao medicalRecordDao;

  PatientService(this.patientDao, this.medicalRecordDao);

  Future<List<PatientWithMedicalRecords>> getAllPatientsWithRecords() async {
    final patients = await patientDao.getAllPatients();
    final List<PatientWithMedicalRecords> result = [];

    for (final patient in patients) {
      final medicalRecords = await medicalRecordDao
          .getMedicalRecordsByPatient(patient.registrationNumber);
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

  Future<void> deletePatient(Patient patient) async {
    await patientDao.deletePatient(patient.registrationNumber);
  }

  Future<void> printSinglePatientData(
      PatientWithMedicalRecords patientRecord, String downloadPath) async {
    final pdf = pw.Document();

    final imageData = await rootBundle.load('assets/medgis.jpg');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Image(image, width: 60, height: 60),
                  pw.SizedBox(width: 10),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Patient Information",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Divider(
                height: 45,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Full Name: ${patientRecord.patient.fullName}"),
                  pw.SizedBox(height: 25),
                  pw.Text("Phone: ${patientRecord.patient.phone}"),
                  pw.SizedBox(height: 25),
                  pw.Text(
                      "Birth Date: ${patientRecord.patient.birthDate.toString().split(' ')[0]}"),
                  pw.SizedBox(height: 25),
                  pw.Text("Address: ${patientRecord.patient.address}"),
                  pw.SizedBox(height: 25),
                  pw.Text("Gender: ${patientRecord.patient.gender}"),
                  pw.SizedBox(height: 25),
                  pw.Text(
                      "Registered: ${patientRecord.registered?.toString().split(' ')[0] ?? ''}"),
                  pw.SizedBox(height: 25),
                  pw.Text(
                      "Last Visited: ${patientRecord.lastVisited?.toString().split(' ')[0] ?? ''}"),
                ],
              ),
              pw.SizedBox(height: 45),
              pw.Text(
                "Medical Records",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: [
                  'Date',
                  'Therapy and Diagnosis',
                  'Anamnesa and Examination'
                ],
                data: patientRecord.medicalRecords.map((record) {
                  return [
                    record.date.toString().split(' ')[0],
                    record.therapyAndDiagnosis,
                    record.anamnesaAndExamination,
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    final file = File('$downloadPath/${patientRecord.patient.fullName}.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}

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
