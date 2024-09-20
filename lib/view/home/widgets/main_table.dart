import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/bloc/main_cubit.dart';
import 'package:medgis_app/page/bloc/main_state.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/view/detail/bloc/detail_cubit.dart';
import 'package:medgis_app/view/home/bloc/home_cubit.dart';
import 'package:file_selector/file_selector.dart';

class MainTable extends StatefulWidget {
  final bool initialized;
  final List<PatientWithMedicalRecords> patients;

  const MainTable({
    super.key,
    required this.initialized,
    required this.patients,
  });

  @override
  State<MainTable> createState() => _MainTableState();
}

class _MainTableState extends State<MainTable> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _isInitialized = widget.initialized;

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const CircularProgressIndicator();
    }

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text('No')),
            DataColumn(label: Text('Birth Date')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Registered')),
            DataColumn(label: Text('Last Visited')),
            DataColumn(label: Text('Delete')),
            DataColumn(label: Text('Export')),
          ],
          rows: widget.patients.asMap().entries.map((entry) {
            int index = entry.key;
            PatientWithMedicalRecords patientRecord = entry.value;

            return DataRow(
              onSelectChanged: (value) {
                if (value != null && value) {
                  context.read<DetailCubit>().setPatient(patientRecord);
                  context.read<MainCubit>().setState(DetailPatientViewState());
                }
              },
              cells: [
                DataCell(Text((index + 1).toString())),
                DataCell(Text(patientRecord.patient.birthDate
                    .toLocal()
                    .toString()
                    .split(' ')[0])),
                DataCell(Text(patientRecord.patient.fullName)),
                DataCell(Text(patientRecord.patient.phone)),
                DataCell(Text(patientRecord.registered
                        ?.toLocal()
                        .toString()
                        .split(' ')[0] ??
                    '')),
                DataCell(Text(patientRecord.lastVisited
                        ?.toLocal()
                        .toString()
                        .split(' ')[0] ??
                    '')),
                DataCell(IconButton(
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () => _confirmDelete(context, patientRecord),
                )),
                DataCell(IconButton(
                  icon: const Icon(Icons.download_rounded),
                  onPressed: () => _exportPatientData(context, patientRecord),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, PatientWithMedicalRecords patientRecord) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                    'Are you sure you want to delete ${patientRecord.patient.fullName}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                _deletePatient(context, patientRecord);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePatient(
      BuildContext context, PatientWithMedicalRecords patientRecord) {
    context.read<HomeCubit>().deletePatient(patientRecord);

    setState(() {
      widget.patients.remove(patientRecord);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Patient ${patientRecord.patient.fullName} deleted successfully'),
        ),
      );
    });
  }

  Future<void> _exportPatientData(
      BuildContext context, PatientWithMedicalRecords patientRecord) async {
    final homeCubit = context.read<HomeCubit>();
    final messenger = ScaffoldMessenger.of(context);

    final String fileName = '${patientRecord.patient.fullName}.pdf';
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'PDF',
      extensions: ['pdf'],
    );

    final file = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: [typeGroup],
    );

    if (file != null) {
      try {
        await homeCubit.patientService
            .printSinglePatientData(patientRecord, file.path);

        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                'Patient ${patientRecord.patient.fullName} PDF exported successfully',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text('Failed to export PDF: $e'),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Export canceled'),
          ),
        );
      }
    }
  }
}
