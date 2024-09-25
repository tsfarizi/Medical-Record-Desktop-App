import 'package:pocketbase/pocketbase.dart';

class QueueDao {
  final PocketBase pb;

  QueueDao(String pocketBaseUrl) : pb = PocketBase(pocketBaseUrl);

  Future<void> insertQueue(List<String> patientIds) async {
    if (patientIds.isEmpty) return;
    final today = DateTime.now().toIso8601String();
    await pb.collection('queue').create(body: {
      'date': today,
      'patients': patientIds,
    });
  }
}
