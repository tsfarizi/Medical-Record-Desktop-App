import 'package:medgis_app/utils/models/medical_record_model.dart';
import 'package:pocketbase/pocketbase.dart';

class MedicalRecordDao {
  final PocketBase pb;

  MedicalRecordDao(String pocketBaseUrl) : pb = PocketBase(pocketBaseUrl);

  Future<List<MedicalRecord>> getAllMedicalRecords() async {
    final records = await pb.collection('medical_record').getFullList();
    return records
        .map((record) => MedicalRecord.fromJson(record.toJson()))
        .toList();
  }

  Future<MedicalRecord?> getMedicalRecordById(String id) async {
    final record = await pb.collection('medical_record').getOne(id);
    return MedicalRecord.fromJson(record.toJson());
  }

  Future<List<MedicalRecord>> getMedicalRecordsByPatient(
      String patientId) async {
    final records = await pb.collection('medical_record').getFullList(
          filter: 'patient_id="$patientId"',
        );
    return records
        .map((record) => MedicalRecord.fromJson(record.toJson()))
        .toList();
  }

  Future<MedicalRecord> insertMedicalRecord(MedicalRecord record) async {
    final response =
        await pb.collection('medical_record').create(body: record.toJson());
    final insertedRecord = MedicalRecord.fromJson(response.toJson());
    return insertedRecord;
  }

  Future<void> updateMedicalRecord(MedicalRecord record) async {
    await pb
        .collection('medical_record')
        .update(record.id, body: record.toJson());
  }

  Future<void> deleteMedicalRecord(String id) async {
    await pb.collection('medical_record').delete(id);
  }
}
