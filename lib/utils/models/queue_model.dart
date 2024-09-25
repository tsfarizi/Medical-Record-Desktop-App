class Queue {
  final String id;
  final DateTime date;
  final List<String> patients;

  Queue({
    required this.id,
    required this.date,
    required this.patients,
  });

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      id: json['id'],
      date: DateTime.parse(json['date']),
      patients:
          json['patients'] != null ? List<String>.from(json['patients']) : [],
    );
  }
}
