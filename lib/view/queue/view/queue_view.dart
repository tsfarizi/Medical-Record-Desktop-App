import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/utils/models/medical_record_model.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/utils/theme/color_scheme.dart';
import 'package:medgis_app/view/shared/add/bloc/add_cubit.dart';
import 'package:medgis_app/view/queue/bloc/queue_cubit.dart';
import 'package:medgis_app/view/queue/bloc/queue_state.dart';
import 'package:intl/intl.dart';
import 'package:medgis_app/view/queue/widgets/patient_dialog.dart';
import 'package:medgis_app/view/shared/widgets/medical_record_form.dart';

class QueueView extends StatefulWidget {
  const QueueView({super.key});

  @override
  State<QueueView> createState() => _QueueViewState();
}

class _QueueViewState extends State<QueueView> {
  @override
  void initState() {
    super.initState();
    context.read<QueueCubit>().fetchAllPatients();
  }

  void _showPatientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<AddCubit>(),
          child: BlocProvider.value(
            value: context.read<QueueCubit>(),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const PatientDialogContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQueueTable(QueueSuccess state) {
    final List<PatientWithMedicalRecords> queuePatients = state.queuePatients;

    return queuePatients.isEmpty
        ? const Center(child: Text("No patients in the queue."))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => colorScheme.primaryContainer),
              columns: const [
                DataColumn(label: Text("No")),
                DataColumn(label: Text("Registration Number")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Phone Number")),
                DataColumn(label: Text("Blood Pressure Now")),
                DataColumn(label: Text("Remove")),
              ],
              rows: queuePatients.asMap().entries.map((entry) {
                int index = entry.key;
                PatientWithMedicalRecords patientRecord = entry.value;

                return DataRow(
                  onSelectChanged: (selected) {
                    if (selected == true) {
                      if (patientRecord.patient.bloodPressureNow == null ||
                          patientRecord.patient.bloodPressureNow!.isEmpty) {
                        _inputBloodPressureNow(context, patientRecord);
                      } else {
                        _handleMedicalRecord(context, patientRecord);
                      }
                    }
                  },
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(
                        patientRecord.patient.registrationNumber.toString())),
                    DataCell(Text(patientRecord.patient.fullName)),
                    DataCell(Text(patientRecord.patient.phone)),
                    DataCell(
                        Text(patientRecord.patient.bloodPressureNow ?? '')),
                    DataCell(IconButton(
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        context
                            .read<QueueCubit>()
                            .removeFromQueue(patientRecord.patient.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Patient removed from queue")),
                        );
                      },
                    )),
                  ],
                );
              }).toList(),
            ),
          );
  }

  void _inputBloodPressureNow(
      BuildContext context, PatientWithMedicalRecords patientRecord) {
    TextEditingController bpController = TextEditingController(
        text: patientRecord.patient.bloodPressureNow ?? '');

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Input Blood Pressure Now'),
          content: TextField(
            controller: bpController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Blood Pressure Now',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<QueueCubit>().updateBloodPressureNow(
                      patientRecord.patient.id,
                      bpController.text,
                    );
                Navigator.of(dialogContext).pop();
                _handleMedicalRecord(context, patientRecord);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _handleMedicalRecord(
      BuildContext context, PatientWithMedicalRecords patientRecord) async {
    MedicalRecord? existingRecord;
    if (patientRecord.patient.medicalRecordNow!.isNotEmpty) {
      existingRecord = await context
          .read<QueueCubit>()
          .getExistingMedicalRecord(patientRecord.patient.medicalRecordNow!);
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return MedicalRecordForm(
          patientId: patientRecord.patient.id,
          record: existingRecord,
          onRecordSaved: (therapy, anamnesa) {
            final newRecord = MedicalRecord(
              id: existingRecord?.id ?? '',
              patientId: patientRecord.patient.id,
              date: DateTime.now(),
              therapyAndDiagnosis: therapy,
              anamnesaAndExamination: anamnesa,
            );
            context.read<QueueCubit>().setMedicalRecord(
                  patientRecord.patient,
                  newRecord,
                );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(existingRecord == null
                      ? 'Medical record added successfully'
                      : 'Medical record updated successfully')),
            );
          },
        );
      },
    );
  }

  void _closeQueue() {
    context.read<QueueCubit>().closeQueue().then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Queue closed")),
        );
      }
    }).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error closing queue: $e")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Queue",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 20),
        Text(
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: _showPatientDialog,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded),
              SizedBox(width: 5),
              Text("Add Patient")
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<QueueCubit, QueueState>(
            builder: (context, state) {
              if (state is QueueLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is QueueSuccess) {
                return _buildQueueTable(state);
              } else if (state is QueueFailure) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _closeQueue,
          child: const Text("Close Queue"),
        ),
      ],
    );
  }
}
