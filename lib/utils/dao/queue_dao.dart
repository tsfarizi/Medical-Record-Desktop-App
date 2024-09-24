import 'package:medgis_app/utils/models/queue_model.dart';
import 'package:pocketbase/pocketbase.dart';

class QueueDao {
  final PocketBase pb;
  QueueDao(String pocketBaseUrl) : pb = PocketBase(pocketBaseUrl);

  Future<void> insertQueue(String patientId) async {
    final Queue queue =
        Queue(id: '', dateTime: DateTime.now(), patients: [patientId]);

    await pb.collection('queue').create(body: queue.toJson());
  }

  Future<Queue?> getQueueByToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final response = await pb.collection('queue').getFullList(
          filter:
              "date >= '${startOfDay.toIso8601String()}' && date < '${endOfDay.toIso8601String()}'",
        );
    if (response.isNotEmpty) {
      return Queue.fromJson(response.first.data);
    }
    return null;
  }

  Future<List<Queue>> getAllQueues() async {
    final response = await pb.collection('queue').getFullList();
    return response.map((item) => Queue.fromJson(item.data)).toList();
  }

  Future<void> deleteQueue(String id) async {
    await pb.collection('queue').delete(id);
  }
}
