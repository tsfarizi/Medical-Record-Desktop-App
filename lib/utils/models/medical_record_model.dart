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

  MedicalRecord copyWith({
    String? id,
    String? patientId,
    DateTime? date,
    String? therapyAndDiagnosis,
    String? anamnesaAndExamination,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      date: date ?? this.date,
      therapyAndDiagnosis: therapyAndDiagnosis ?? this.therapyAndDiagnosis,
      anamnesaAndExamination:
          anamnesaAndExamination ?? this.anamnesaAndExamination,
    );
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      date: DateTime.parse(json['date'] as String),
      therapyAndDiagnosis: json['therapy_and_diagnosis'] as String,
      anamnesaAndExamination: json['anamnesa_and_examination'] as String,
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
