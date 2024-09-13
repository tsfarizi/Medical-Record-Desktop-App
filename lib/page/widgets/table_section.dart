import 'package:flutter/material.dart';
import 'package:medgis_app/database.dart';
import 'package:medgis_app/utils/services/pateint_service.dart';
import 'package:medgis_app/view/home/widgets/main_table.dart';

class TableSection extends StatelessWidget {
  const TableSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("A. Table", style: Theme.of(context).textTheme.headlineSmall),
        Center(
          child: Card(
            child: MainTable(initialized: true, patients: [
              PatientWithMedicalRecords(
                  lastVisited: DateTime(2024, 8, 21),
                  registered: DateTime(2008, 5, 21),
                  patient: Patient(
                      registrationNumber: '123',
                      fullName: 'John doe',
                      address: 'Jl. John doe',
                      gender: 'Male',
                      birthDate: DateTime(1998, 5, 21),
                      phone: '081234567890'),
                  medicalRecords: [
                    MedicalRecord(
                        id: '1',
                        patientRegistrationNumber: '123',
                        date: DateTime(2008, 5, 21),
                        therapyAndDiagnosis: 'therapyAndDiagnosis',
                        anamnesaAndExamination: 'anamnesaAndExamination'),
                    MedicalRecord(
                        id: '2',
                        patientRegistrationNumber: '123',
                        date: DateTime(2024, 8, 21),
                        therapyAndDiagnosis: 'therapyAndDiagnosis',
                        anamnesaAndExamination: 'anamnesaAndExamination')
                  ]),
              PatientWithMedicalRecords(
                  registered: DateTime(2008, 5, 21),
                  lastVisited: DateTime(2024, 8, 21),
                  patient: Patient(
                      registrationNumber: '123',
                      fullName: 'Jane doe',
                      address: 'Jl. Jane doe',
                      gender: 'Female',
                      birthDate: DateTime(1998, 5, 21),
                      phone: '081234567890'),
                  medicalRecords: [
                    MedicalRecord(
                        id: '1',
                        patientRegistrationNumber: '123',
                        date: DateTime(2008, 5, 21),
                        therapyAndDiagnosis: 'therapyAndDiagnosis',
                        anamnesaAndExamination: 'anamnesaAndExamination'),
                    MedicalRecord(
                        id: '2',
                        patientRegistrationNumber: '123',
                        date: DateTime(2024, 8, 21),
                        therapyAndDiagnosis: 'therapyAndDiagnosis',
                        anamnesaAndExamination: 'anamnesaAndExamination')
                  ])
            ]),
          ),
        ),
        const Text(
            "Bagian utama ini akan menampilkan semua data yang dimiliki,ketik baris data di tekan makan akan menampilkan data secara lengkap, dan ikon tempat sampah ketika di tekan akan memunculkan jendela yang meminta konfirmasi apakah benar data baris tersebut akan di hapus."),
        const Text(""),
        const Text(""),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
