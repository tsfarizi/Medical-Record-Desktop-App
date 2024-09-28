import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final Map<String, PatientWithMedicalRecords> allPatientsMap = {
      for (var p in state.allPatients) p.patient.id: p
    };

    final List<Map<String, dynamic>> queueDisplayData =
        state.queuePatients.map((queuePatient) {
      final patientRecord = allPatientsMap[queuePatient.patientId];
      return {
        'patientRecord': patientRecord,
        'queuePatient': queuePatient,
      };
    }).toList();

    return queueDisplayData.isEmpty
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
                DataColumn(label: Text("Blood Pressure")),
                DataColumn(label: Text("Remove")),
              ],
              rows: queueDisplayData.asMap().entries.map((entry) {
                int index = entry.key;
                var data = entry.value;

                PatientWithMedicalRecords? patientRecord =
                    data['patientRecord'] as PatientWithMedicalRecords?;
                QueuePatientData queuePatient =
                    data['queuePatient'] as QueuePatientData;

                return DataRow(
                  onSelectChanged: (selected) {
                    if (selected == true) {
                      if (queuePatient.bloodPressure == null ||
                          queuePatient.bloodPressure!.isEmpty) {
                        _inputBloodPressure(context, queuePatient);
                      } else {
                        _addMedicalRecord(context, queuePatient);
                      }
                    }
                  },
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(
                        patientRecord?.patient.registrationNumber.toString() ??
                            '')),
                    DataCell(Text(patientRecord?.patient.fullName ?? '')),
                    DataCell(Text(patientRecord?.patient.phone ?? '')),
                    DataCell(Text(queuePatient.bloodPressure ?? '')),
                    DataCell(IconButton(
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        context
                            .read<QueueCubit>()
                            .removeFromLocalQueue(queuePatient.patientId);
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

  void _inputBloodPressure(
      BuildContext context, QueuePatientData queuePatient) {
    TextEditingController bpController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Input Blood Pressure'),
          content: TextField(
            controller: bpController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Blood Pressure',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<QueueCubit>().updateBloodPressure(
                      queuePatient.patientId,
                      bpController.text,
                    );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addMedicalRecord(BuildContext context, QueuePatientData queuePatient) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return MedicalRecordForm(
          patientId: queuePatient.patientId,
          onRecordSaved: (therapy, anamnesa) {
            context.read<QueueCubit>().addMedicalRecord(
                  queuePatient.patientId,
                  therapy,
                  anamnesa,
                );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Medical record saved successfully')),
            );
          },
        );
      },
    );
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
        BlocBuilder<QueueCubit, QueueState>(
          builder: (context, state) {
            bool isQueueEmpty = true;
            if (state is QueueSuccess) {
              isQueueEmpty = state.queuePatients.isEmpty;
            }
            return ElevatedButton(
              onPressed: isQueueEmpty
                  ? null
                  : () {
                      context.read<QueueCubit>().submitQueueToDatabase();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Queue submitted to database")),
                      );
                    },
              child: const Text("Close and Submit Queue"),
            );
          },
        ),
      ],
    );
  }
}
