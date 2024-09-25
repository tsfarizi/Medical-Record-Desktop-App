import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/view/queue/bloc/queue_cubit.dart';
import 'package:medgis_app/view/queue/bloc/queue_state.dart';
import 'package:intl/intl.dart';
import 'package:medgis_app/view/queue/widgets/patient_dialog.dart';

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
          value: context.read<QueueCubit>(),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const PatientDialogContent(),
          ),
        );
      },
    );
  }

  Widget _buildQueueTable(QueueSuccess state) {
    final queuePatientIds = state.queuePatientIds;
    final queuePatients = state.allPatients
        .where((patient) => queuePatientIds.contains(patient.patient.id))
        .toList();

    return queuePatients.isEmpty
        ? const Center(child: Text("No patients in the queue."))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => Colors.blueGrey.shade100),
              columns: const [
                DataColumn(label: Text("No")),
                DataColumn(label: Text("Registration Number")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Phone Number")),
                DataColumn(label: Text("Remove")),
              ],
              rows: queuePatients.asMap().entries.map((entry) {
                int index = entry.key;
                PatientWithMedicalRecords patientRecord = entry.value;

                return DataRow(
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(
                        patientRecord.patient.registrationNumber.toString())),
                    DataCell(Text(patientRecord.patient.fullName)),
                    DataCell(Text(patientRecord.patient.phone)),
                    DataCell(IconButton(
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        context
                            .read<QueueCubit>()
                            .removeFromLocalQueue(patientRecord.patient.id);
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
              isQueueEmpty = state.queuePatientIds.isEmpty;
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
