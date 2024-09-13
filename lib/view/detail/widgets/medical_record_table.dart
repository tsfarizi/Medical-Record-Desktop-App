import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/view/detail/bloc/detail_cubit.dart';
import 'package:medgis_app/database.dart';
import 'package:medgis_app/view/detail/bloc/detail_state.dart';

class MedicalRecordTable extends StatelessWidget {
  final String patientRegistrationNumber;

  const MedicalRecordTable(
      {super.key, required this.patientRegistrationNumber});

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
                onPressed: () => _addMedicalRecord(context),
                child: const Row(
                  children: [
                    Icon(Icons.add_rounded),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Add Record")
                  ],
                )),
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
                    DataCell(IconButton(
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
                        )))
                  ],
                  onSelectChanged: (selected) {
                    if (selected == true) {
                      _editMedicalRecord(context, record);
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

  void _addMedicalRecord(BuildContext context) {
    TextEditingController therapyController = TextEditingController();
    TextEditingController anamnesaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add Medical Record'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                Expanded(
                  child: _buildScrollableTextField(
                    context,
                    controller: therapyController,
                    hintText: 'Therapy & Diagnosis',
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildScrollableTextField(
                    context,
                    controller: anamnesaController,
                    hintText: 'Anamnesa & Examination',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<DetailCubit>().addMedicalRecord(
                      patientRegistrationNumber,
                      therapyController.text,
                      anamnesaController.text,
                    );
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Medical record saved successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editMedicalRecord(BuildContext context, MedicalRecord record) {
    TextEditingController therapyController =
        TextEditingController(text: record.therapyAndDiagnosis);
    TextEditingController anamnesaController =
        TextEditingController(text: record.anamnesaAndExamination);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Medical Record'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                Expanded(
                  child: _buildScrollableTextField(
                    context,
                    controller: therapyController,
                    hintText: 'Therapy & Diagnosis',
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildScrollableTextField(
                    context,
                    controller: anamnesaController,
                    hintText: 'Anamnesa & Examination',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<DetailCubit>().updateMedicalRecord(
                      record.id,
                      therapyController.text,
                      anamnesaController.text,
                    );
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New data successfully saved')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScrollableTextField(BuildContext context,
      {required TextEditingController controller, required String hintText}) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50,
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        child: TextField(
          controller: controller,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
