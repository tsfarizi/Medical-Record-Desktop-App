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

  void _initialize() async {
    pb.collection('queue_now').subscribe('*', (e) async {
      final queue = await getCurrentQueue();
      if (queue != null) {
        _queueStreamController.add(queue);
      } else {
        _queueStreamController
            .add(Queue(id: '', date: DateTime.now(), patients: []));
      }
    });

    final queue = await getCurrentQueue();
    if (queue != null) {
      _queueStreamController.add(queue);
    } else {
      _queueStreamController
          .add(Queue(id: '', date: DateTime.now(), patients: []));
    }
  }

  Stream<Queue> get queueStream => _queueStreamController.stream;

  Future<RecordModel?> _getCurrentQueueRecord() async {
    try {
      final result = await pb.collection('queue_now').getList(perPage: 1);
      if (result.items.isNotEmpty) {
        return result.items.first;
      }
      return null;
    } catch (e) {
      print('Error in _getCurrentQueueRecord: $e');
      return null;
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
      print('Error in getCurrentQueue: $e');
      return null;
    }
  }

  Future<void> createCurrentQueue() async {
    try {
      final todayDate = DateTime.now().toIso8601String().substring(0, 10);
      final newRecord = await pb.collection('queue_now').create(body: {
        'date': todayDate,
        'patients': [],
      });
      _queueStreamController.add(Queue.fromRecord(newRecord));
    } catch (e) {
      print('Error in createCurrentQueue: $e');
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
          });
          _queueStreamController.add(queue);
        }
      }
    } catch (e) {
      print('Error in addPatientToQueue: $e');
    }
  }

  Future<void> removePatientFromQueue(String patientId) async {
    try {
      final queue = await getCurrentQueue();
      if (queue != null && queue.patients.contains(patientId)) {
        queue.patients.remove(patientId);
        await pb.collection('queue_now').update(queue.id, body: {
          'patients': queue.patients,
        });
        _queueStreamController.add(queue);
      }
    } catch (e) {
      print('Error in removePatientFromQueue: $e');
      rethrow;
    }
  }

  Future<void> closeQueue() async {
    try {
      final queue = await getCurrentQueue();
      if (queue != null) {
        await pb.collection('queue').create(body: {
          'date': queue.date.toIso8601String(),
          'patients': queue.patients,
        });
        final records = await pb.collection('queue_now').getFullList();
        for (var record in records) {
          await pb.collection('queue_now').delete(record.id);
        }
        _queueStreamController
            .add(Queue(id: '', date: DateTime.now(), patients: []));
      }
    } catch (e, stacktrace) {
      print('Error in closeQueue: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  void dispose() {
    pb.collection('queue_now').unsubscribe('*');
    _queueStreamController.close();
  }
}
