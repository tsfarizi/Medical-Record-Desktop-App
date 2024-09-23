class Queue {
  final String id;
  final DateTime dateTime;
  final List<String> patients;

  Queue({required this.id, required this.dateTime, required this.patients});

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
        id: json['id'],
        dateTime: DateTime.parse(json['date']),
        patients: json['patients']);
  }
  Map<String, dynamic> toJson() {
    return {'date': dateTime.toIso8601String(), 'patients': patients};
  }
}
