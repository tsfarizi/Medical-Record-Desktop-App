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
}
