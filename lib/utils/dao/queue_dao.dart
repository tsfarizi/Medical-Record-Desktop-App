import 'dart:async';
import 'package:medgis_app/utils/models/queue_model.dart';
import 'package:pocketbase/pocketbase.dart';

class QueueDao {
  final PocketBase pb;
  final StreamController<Queue> _queueStreamController =
      StreamController.broadcast();

  QueueDao(String pocketBaseUrl) : pb = PocketBase(pocketBaseUrl) {
    _initialize();
  }

  void _initialize() {
    pb.collection('queue_now').subscribe('*', (e) async {
      try {
        final queue = await getCurrentQueue();
        if (queue != null) {
          _queueStreamController.add(queue);
        } else {
          _queueStreamController
              .add(Queue(id: '', date: DateTime.now(), patients: []));
        }
      } catch (e) {
        throw Exception(
            'There is an error in the database, please make sure the server ID is correct or turn on the server.');
      }
    });

    getCurrentQueue().then((queue) {
      if (queue != null) {
        _queueStreamController.add(queue);
      } else {
        _queueStreamController
            .add(Queue(id: '', date: DateTime.now(), patients: []));
      }
    }).catchError((e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    });
  }

  Stream<Queue> get queueStream => _queueStreamController.stream;

  Future<RecordModel?> _getCurrentQueueRecord() async {
    try {
      final result = await pb
          .collection('queue_now')
          .getList(perPage: 1)
          .timeout(const Duration(seconds: 2));
      if (result.items.isNotEmpty) {
        return result.items.first;
      }
      return null;
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<Queue?> getCurrentQueue() async {
    try {
      final record = await _getCurrentQueueRecord();
      if (record != null) {
        return Queue.fromRecord(record);
      }
      return null;
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> createCurrentQueue() async {
    try {
      final todayDate = DateTime.now().toIso8601String().substring(0, 10);
      final newRecord = await pb.collection('queue_now').create(body: {
        'date': todayDate,
        'patients': [],
      }).timeout(const Duration(seconds: 2));
      _queueStreamController.add(Queue.fromRecord(newRecord));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> addPatientToQueue(String patientId) async {
    try {
      Queue? queue = await getCurrentQueue();
      if (queue == null) {
        await createCurrentQueue();
        queue = await getCurrentQueue();
      }
      if (queue != null) {
        if (!queue.patients.contains(patientId)) {
          queue.patients.add(patientId);
          await pb.collection('queue_now').update(queue.id, body: {
            'patients': queue.patients,
          }).timeout(const Duration(seconds: 2));
          _queueStreamController.add(queue);
        }
      }
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> removePatientFromQueue(String patientId) async {
    try {
      final queue = await getCurrentQueue();
      if (queue != null && queue.patients.contains(patientId)) {
        queue.patients.remove(patientId);
        await pb.collection('queue_now').update(queue.id, body: {
          'patients': queue.patients,
        }).timeout(const Duration(seconds: 2));
        _queueStreamController.add(queue);
      }
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> closeQueue() async {
    try {
      final queue = await getCurrentQueue();
      if (queue != null) {
        await pb.collection('queue').create(body: {
          'date': queue.date.toIso8601String(),
          'patients': queue.patients,
        }).timeout(const Duration(seconds: 2));
        final records = await pb
            .collection('queue_now')
            .getFullList()
            .timeout(const Duration(seconds: 2));
        for (var record in records) {
          await pb
              .collection('queue_now')
              .delete(record.id)
              .timeout(const Duration(seconds: 2));
        }
        _queueStreamController
            .add(Queue(id: '', date: DateTime.now(), patients: []));
      }
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  void dispose() {
    pb.collection('queue_now').unsubscribe('*');
    _queueStreamController.close();
  }
}
