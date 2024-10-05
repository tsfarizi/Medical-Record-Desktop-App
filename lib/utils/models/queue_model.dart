import 'package:pocketbase/pocketbase.dart';

class Queue {
  final String id;
  final DateTime date;
  List<String> patients;

  Queue({
    required this.id,
    required this.date,
    required this.patients,
  });

  factory Queue.fromRecord(RecordModel record) {
    return Queue(
      id: record.id,
      date: DateTime.parse(record.data['date']),
      patients: record.data['patients'] != null
          ? List<String>.from(record.data['patients'])
          : [],
    );
  }
}
