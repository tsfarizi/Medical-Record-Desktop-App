import 'package:flutter/material.dart';
import 'package:medgis_app/utils/models/medical_record_model.dart';

class MedicalRecordForm extends StatefulWidget {
  final String patientId;
  final MedicalRecord? record;
  final void Function(
      String therapyAndDiagnosis, String anamnesaAndExamination)? onRecordSaved;

  const MedicalRecordForm({
    super.key,
    required this.patientId,
    this.record,
    this.onRecordSaved,
  });

  @override
  State<MedicalRecordForm> createState() => _MedicalRecordFormState();
}

class _MedicalRecordFormState extends State<MedicalRecordForm> {
  late TextEditingController therapyController;
  late TextEditingController anamnesaController;

  @override
  void initState() {
    super.initState();
    therapyController = TextEditingController(
      text: widget.record?.therapyAndDiagnosis ?? '',
    );
    anamnesaController = TextEditingController(
      text: widget.record?.anamnesaAndExamination ?? '',
    );
  }

  @override
  void dispose() {
    therapyController.dispose();
    anamnesaController.dispose();
    super.dispose();
  }

  void _saveRecord() {
    final therapy = therapyController.text.trim();
    final anamnesa = anamnesaController.text.trim();

    if (therapy.isEmpty || anamnesa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (widget.onRecordSaved != null) {
      widget.onRecordSaved!(therapy, anamnesa);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.record == null ? 'Add Medical Record' : 'Edit Medical Record',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: therapyController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Therapy & Diagnosis',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: anamnesaController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Anamnesa & Examination',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveRecord,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
