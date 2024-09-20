import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/bloc/main_cubit.dart';
import 'package:medgis_app/page/bloc/main_state.dart';
import 'package:medgis_app/view/detail/bloc/detail_cubit.dart';
import 'package:medgis_app/view/detail/bloc/detail_state.dart';
import 'package:medgis_app/view/detail/widgets/medical_record_table.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          context.read<MainCubit>().setState(HomeViewState());
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: BlocBuilder<DetailCubit, DetailState>(
        builder: (context, state) {
          if (state is DetailLoaded) {
            final patient = state.patient.patient;
            final birthDate = patient.birthDate.toLocal();
            final birthDateString = birthDate.toString().split(' ')[0];
            final age = _calculateAge(patient.birthDate);

            final detailItems = [
              {
                'label': 'Registration Number',
                'value': patient.registrationNumber.toString(),
                'editable': false,
                'field': null,
                'initialValue': null,
              },
              {
                'label': 'Name',
                'value': patient.fullName,
                'editable': true,
                'field': 'Name',
                'initialValue': patient.fullName,
              },
              {
                'label': 'Birth Date (age)',
                'value': '$birthDateString ($age)',
                'editable': true,
                'field': 'Birth Date',
                'initialValue': birthDateString,
              },
              {
                'label': 'Phone',
                'value': patient.phone,
                'editable': true,
                'field': 'Phone',
                'initialValue': patient.phone,
              },
              {
                'label': 'Address',
                'value': patient.address,
                'editable': true,
                'field': 'Address',
                'initialValue': patient.address,
              },
              {
                'label': 'Gender',
                'value': patient.gender,
                'editable': true,
                'field': 'Gender',
                'initialValue': patient.gender,
              },
            ];

            return Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<MainCubit>().setState(HomeViewState());
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Detail Patient",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: detailItems.sublist(0, 3).map((item) {
                        return buildDetailColumn(
                          context,
                          label: item['label'] as String,
                          value: item['value'] as String,
                          editable: item['editable'] as bool,
                          onEditPressed: item['editable'] as bool
                              ? () => _editField(
                                    context,
                                    item['field'] as String,
                                    item['initialValue'] as String,
                                  )
                              : null,
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: detailItems.sublist(3).map((item) {
                        return buildDetailColumn(
                          context,
                          label: item['label'] as String,
                          value: item['value'] as String,
                          editable: item['editable'] as bool,
                          onEditPressed: item['editable'] as bool
                              ? () => _editField(
                                    context,
                                    item['field'] as String,
                                    item['initialValue'] as String,
                                  )
                              : null,
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                MedicalRecordTable(patientId: patient.id),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget buildDetailColumn(BuildContext context,
      {required String label,
      required String value,
      bool editable = false,
      VoidCallback? onEditPressed}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (editable)
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onEditPressed,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _editField(BuildContext context, String field, String initialValue) {
    if (field == 'Gender') {
      _editGenderField(context, initialValue);
    } else if (field == 'Birth Date') {
      _editDateField(context, initialValue);
    } else {
      _editTextField(context, field, initialValue);
    }
  }

  void _editTextField(BuildContext context, String field, String initialValue) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new $field'),
            keyboardType:
                field == 'Phone' ? TextInputType.number : TextInputType.text,
            inputFormatters: field == 'Phone'
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : null,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<DetailCubit>()
                    .updatePatientData(field, controller.text);
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

  void _editGenderField(BuildContext context, String initialValue) {
    String selectedGender = initialValue;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (alertContext, setState) {
            return AlertDialog(
              title: const Text('Edit Gender'),
              content: DropdownButtonFormField<String>(
                value: selectedGender,
                items: ['Male', 'Female']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue!;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<DetailCubit>()
                        .updatePatientData('Gender', selectedGender);
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('New data successfully saved')),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editDateField(BuildContext context, String initialValue) async {
    DateTime selectedDate = DateTime.parse(initialValue);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      if (!context.mounted) return;
      context
          .read<DetailCubit>()
          .updatePatientData('Birth Date', picked.toIso8601String());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New data successfully saved')),
      );
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
