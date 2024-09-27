import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/view/add/bloc/add_cubit.dart';
import 'package:medgis_app/view/add/widgets/add_patient_form.dart';
import 'package:medgis_app/view/queue/bloc/queue_cubit.dart';
import 'package:medgis_app/view/queue/bloc/queue_state.dart';

class PatientDialogContent extends StatefulWidget {
  const PatientDialogContent({super.key});

  @override
  State<PatientDialogContent> createState() => _PatientDialogContentState();
}

class _PatientDialogContentState extends State<PatientDialogContent> {
  late TextEditingController searchController;
  String query = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildAvailablePatientsTable(QueueSuccess state) {
    final queuePatientIds = state.queuePatientIds.toSet();
    List<PatientWithMedicalRecords> availablePatients = state.allPatients
        .where((patient) => !queuePatientIds.contains(patient.patient.id))
        .toList();

    if (query.isNotEmpty) {
      availablePatients = availablePatients.where((patient) {
        final name = patient.patient.fullName.toLowerCase();
        final phone = patient.patient.phone.toLowerCase();
        final regNum = patient.patient.registrationNumber.toString();
        return name.contains(query) ||
            phone.contains(query) ||
            regNum.contains(query);
      }).toList();
    }

    return availablePatients.isEmpty
        ? const Center(child: Text("No available patients to add."))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => Colors.blueGrey.shade100),
              columns: const [
                DataColumn(label: Text("No")),
                DataColumn(label: Text("Registration Number")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Phone Number")),
                DataColumn(label: Text("Add")),
              ],
              rows: availablePatients.asMap().entries.map((entry) {
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
                        Icons.add_circle_rounded,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        context
                            .read<QueueCubit>()
                            .addToLocalQueue(patientRecord.patient.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Patient added to queue")),
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
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: BlocBuilder<QueueCubit, QueueState>(
        builder: (context, state) {
          if (state is QueueLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QueueSuccess) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText:
                        "Search by Name, Registration Number, or Phone Number",
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      query = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildAvailablePatientsTable(state),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _showAddPatientDialog,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add New Patient'),
                ),
              ],
            );
          } else if (state is QueueFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }

  void _showAddPatientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<AddCubit>(),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: AddPatientForm(
              onPatientAdded: () async {
                await context.read<QueueCubit>().fetchAllPatients();
                if (mounted) {
                  final newPatient =
                      context.read<QueueCubit>().getMostRecentPatient();
                  if (newPatient != null) {
                    context
                        .read<QueueCubit>()
                        .addToLocalQueue(newPatient.patient.id);
                  }
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
            ),
          ),
        );
      },
    );
  }
}
