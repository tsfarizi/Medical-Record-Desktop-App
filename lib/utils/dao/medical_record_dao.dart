import 'package:medgis_app/utils/models/medical_record_model.dart';
import 'package:pocketbase/pocketbase.dart';

class MedicalRecordDao {
  final PocketBase pb;

  MedicalRecordDao(String pocketBaseUrl) : pb = PocketBase(pocketBaseUrl);

  Future<List<MedicalRecord>> getAllMedicalRecords() async {
    try {
      final records = await pb
          .collection('medical_record')
          .getFullList()
          .timeout(const Duration(seconds: 2));
      return records
          .map((record) => MedicalRecord.fromJson(record.toJson()))
          .toList();
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<MedicalRecord?> getMedicalRecordById(String id) async {
    try {
      final record = await pb
          .collection('medical_record')
          .getOne(id)
          .timeout(const Duration(seconds: 2));
      return MedicalRecord.fromJson(record.toJson());
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<List<MedicalRecord>> getMedicalRecordsByPatient(
      String patientId) async {
    try {
      final records = await pb
          .collection('medical_record')
          .getFullList(
            filter: 'patient_id="$patientId"',
          )
          .timeout(const Duration(seconds: 2));
      return records
          .map((record) => MedicalRecord.fromJson(record.toJson()))
          .toList();
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<MedicalRecord> insertMedicalRecord(MedicalRecord record) async {
    try {
      final response = await pb
          .collection('medical_record')
          .create(body: record.toJson())
          .timeout(const Duration(seconds: 2));
      final insertedRecord = MedicalRecord.fromJson(response.toJson());
      return insertedRecord;
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> updateMedicalRecord(MedicalRecord record) async {
    try {
      await pb
          .collection('medical_record')
          .update(record.id, body: record.toJson())
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> deleteMedicalRecord(String id) async {
    try {
      await pb
          .collection('medical_record')
          .delete(id)
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }
}
