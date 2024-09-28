class MedicalRecord {
  final String id;
  final String patientId;
  final DateTime date;
  final String therapyAndDiagnosis;
  final String anamnesaAndExamination;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.date,
    required this.therapyAndDiagnosis,
    required this.anamnesaAndExamination,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] ?? '',
      patientId: json['patient_id'],
      date: DateTime.parse(json['date']),
      therapyAndDiagnosis: json['therapy_and_diagnosis'],
      anamnesaAndExamination: json['anamnesa_and_examination'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'date': date.toIso8601String(),
      'therapy_and_diagnosis': therapyAndDiagnosis,
      'anamnesa_and_examination': anamnesaAndExamination,
    };
  }
}
