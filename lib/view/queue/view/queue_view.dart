import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/view/add/bloc/add_cubit.dart';
import 'package:medgis_app/view/queue/bloc/queue_cubit.dart';
import 'package:medgis_app/view/queue/bloc/queue_state.dart';

class QueueView extends StatefulWidget {
  const QueueView({super.key});

  @override
  State<QueueView> createState() => _QueueViewState();
}

class _QueueViewState extends State<QueueView> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);
    context.read<QueueCubit>().fetchAllPatients();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<QueueCubit>().filterPatients(searchController.text);
  }

  void _showPatientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<QueueCubit>(),
          child: BlocProvider.value(
            value: context.read<AddCubit>(),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: BlocBuilder<QueueCubit, QueueState>(
                  builder: (context, state) {
                    if (state is QueueLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is QueueSucces) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  prefixIcon: const Icon(Icons.search_rounded),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            DataTable(
                                showCheckboxColumn: false,
                                columnSpacing: 30,
                                columns: const [
                                  DataColumn(
                                      label: SizedBox(
                                          width: 20, child: Text("No"))),
                                  DataColumn(
                                      label: SizedBox(
                                    width: 80,
                                    child: Text("Birth Date"),
                                  )),
                                  DataColumn(
                                      label: SizedBox(
                                    width: 200,
                                    child: Text("Name"),
                                  )),
                                  DataColumn(
                                      label: SizedBox(
                                    width: 80,
                                    child: Text("Phone"),
                                  )),
                                  DataColumn(
                                      label: SizedBox(
                                    width: 80,
                                    child: Text("Delete"),
                                  ))
                                ],
                                rows: state.filteredPatients
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  PatientWithMedicalRecords patientRecord =
                                      entry.value;

                                  return DataRow(
                                    onSelectChanged: (value) {
                                      if (value != null && value) {
                                        context
                                            .read<QueueCubit>()
                                            .addQueue(patientRecord.patient.id);
                                        ScaffoldMessenger.of(dialogContext)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Add Patient successfully")),
                                        );
                                      }
                                    },
                                    cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(Text(patientRecord
                                          .patient.birthDate
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0])),
                                      DataCell(
                                          Text(patientRecord.patient.fullName)),
                                      DataCell(
                                          Text(patientRecord.patient.phone)),
                                      DataCell(IconButton(
                                        icon: const Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {},
                                      ))
                                    ],
                                  );
                                }).toList())
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ),
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
        const SizedBox(
          height: 20,
        ),
        Text(
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          width: 20,
        ),
        TextButton(
          onPressed: _showPatientDialog,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded),
              SizedBox(
                width: 5,
              ),
              Text("Add Patient")
            ],
          ),
        ),
        Center(
            child: DataTable(
          columnSpacing: 30,
          columns: const [
            DataColumn(label: SizedBox(width: 20, child: Text("No"))),
            DataColumn(
                label: SizedBox(width: 150, child: Text("Registraion Number"))),
            DataColumn(label: SizedBox(width: 200, child: Text("Name"))),
            DataColumn(
                label: SizedBox(width: 120, child: Text("Blood Pressure"))),
            DataColumn(label: SizedBox(width: 120, child: Text("Delete")))
          ],
          rows: const [],
        )),
      ],
    );
  }
}
