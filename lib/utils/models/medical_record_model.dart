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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'date': date.toIso8601String(),
      'therapyAndDiagnosis': therapyAndDiagnosis,
      'anamnesaAndExamination': anamnesaAndExamination,
    };
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      patientId: json['patientId'],
      date: DateTime.parse(json['date']),
      therapyAndDiagnosis: json['therapyAndDiagnosis'],
      anamnesaAndExamination: json['anamnesaAndExamination'],
    );
  }
}
