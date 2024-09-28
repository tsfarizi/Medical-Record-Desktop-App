import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/view/detail/bloc/detail_cubit.dart';
import 'package:medgis_app/utils/models/medical_record_model.dart';
import 'package:medgis_app/view/detail/bloc/detail_state.dart';
import 'package:medgis_app/view/shared/widgets/medical_record_form.dart';

class MedicalRecordTable extends StatelessWidget {
  final String patientId;

  const MedicalRecordTable({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetailCubit>().state;
    if (state is DetailLoaded) {
      return Column(
        children: [
          const Text(
            "Medical Records",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 150,
            child: TextButton(
              onPressed: () => _showMedicalRecordForm(context),
              child: const Row(
                children: [
                  Icon(Icons.add_rounded),
                  SizedBox(width: 5),
                  Text("Add Record")
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Therapy & Diagnosis')),
                DataColumn(label: Text('Anamnesa & Examination')),
                DataColumn(label: Text("Action"))
              ],
              rows: state.patient.medicalRecords.map((record) {
                return DataRow(
                  cells: [
                    DataCell(
                        Text(record.date.toLocal().toString().split(' ')[0])),
                    DataCell(Text(_truncateText(record.therapyAndDiagnosis))),
                    DataCell(
                        Text(_truncateText(record.anamnesaAndExamination))),
                    DataCell(
                      IconButton(
                        onPressed: () {
                          context
                              .read<DetailCubit>()
                              .deleteMedicalRecord(record.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Medical record deleted successfully'),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                  onSelectChanged: (selected) {
                    if (selected == true) {
                      _showMedicalRecordForm(context, record: record);
                    }
                  },
                );
              }).toList(),
            ),
          )
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  String _truncateText(String text, {int maxLength = 30}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  void _showMedicalRecordForm(BuildContext context, {MedicalRecord? record}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<DetailCubit>(),
          child: MedicalRecordForm(
            patientId: patientId,
            record: record,
          ),
        );
      },
    );
  }
}
