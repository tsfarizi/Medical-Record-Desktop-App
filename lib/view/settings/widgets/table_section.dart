import 'package:flutter/material.dart';
import 'package:medgis_app/utils/models/medical_record_model.dart';
import 'package:medgis_app/utils/models/patient_model.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
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
            child: MainTable(
              patients: [
                PatientWithMedicalRecords(
                    lastVisited: DateTime(2024, 8, 21),
                    registered: DateTime(2008, 5, 21),
                    patient: Patient(
                        id: '12',
                        registrationNumber: 13,
                        fullName: 'John doe',
                        address: 'Jl. John doe',
                        gender: 'Male',
                        birthDate: DateTime(1998, 5, 21),
                        phone: '081234567890'),
                    medicalRecords: [
                      MedicalRecord(
                          id: '1',
                          patientId: '3',
                          date: DateTime(2008, 5, 21),
                          therapyAndDiagnosis: 'therapyAndDiagnosis',
                          anamnesaAndExamination: 'anamnesaAndExamination'),
                      MedicalRecord(
                          id: '2',
                          patientId: '2',
                          date: DateTime(2024, 8, 21),
                          therapyAndDiagnosis: 'therapyAndDiagnosis',
                          anamnesaAndExamination: 'anamnesaAndExamination')
                    ]),
                PatientWithMedicalRecords(
                    registered: DateTime(2008, 5, 21),
                    lastVisited: DateTime(2024, 8, 21),
                    patient: Patient(
                        id: '1',
                        registrationNumber: 1,
                        fullName: 'Jane doe',
                        address: 'Jl. Jane doe',
                        gender: 'Female',
                        birthDate: DateTime(1998, 5, 21),
                        phone: '081234567890'),
                    medicalRecords: [
                      MedicalRecord(
                          id: '1',
                          patientId: '12',
                          date: DateTime(2008, 5, 21),
                          therapyAndDiagnosis: 'therapyAndDiagnosis',
                          anamnesaAndExamination: 'anamnesaAndExamination'),
                      MedicalRecord(
                          id: '2',
                          patientId: '12',
                          date: DateTime(2024, 8, 21),
                          therapyAndDiagnosis: 'therapyAndDiagnosis',
                          anamnesaAndExamination: 'anamnesaAndExamination')
                    ])
              ],
              initialized: true,
            ),
          ),
        ),
        const Text(
            "This main section will display all the data owned, type the data row and press it, it will display the complete data, and when the trash icon is pressed, a window will appear asking for confirmation whether the row data will be deleted."),
        const Text(""),
        const Text(""),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
