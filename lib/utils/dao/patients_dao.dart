import 'package:pocketbase/pocketbase.dart';
import 'package:medgis_app/utils/models/patient_model.dart';

class PatientDao {
  final PocketBase pb;

  PatientDao(String pocketBaseUrl) : pb = PocketBase(pocketBaseUrl);

  Future<List<Patient>> getAllPatients() async {
    try {
      final records = await pb
          .collection('patient')
          .getFullList()
          .timeout(const Duration(seconds: 2));
      return records
          .map((record) => Patient.fromJson(record.toJson()))
          .toList();
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<Patient?> getPatientById(String id) async {
    try {
      final record = await pb
          .collection('patient')
          .getOne(id)
          .timeout(const Duration(seconds: 2));
      return Patient.fromJson(record.toJson());
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<List<Patient>> getPatientsByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) return [];
      final filter = 'id IN (${ids.map((id) => "'$id'").join(',')})';
      final records = await pb
          .collection('patient')
          .getFullList(filter: filter)
          .timeout(const Duration(seconds: 2));
      return records
          .map((record) => Patient.fromJson(record.toJson()))
          .toList();
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> insertPatient(Patient patient) async {
    try {
      int nextRegistrationNumber = await _getNextRegistrationNumber()
          .timeout(const Duration(seconds: 2));
      Map<String, dynamic> patientData = patient.toJson();
      patientData['registration_number'] = nextRegistrationNumber;
      await pb
          .collection('patient')
          .create(body: patientData)
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<int> _getNextRegistrationNumber() async {
    try {
      final result = await pb.collection('patient').getList(
            sort: '-registration_number',
            perPage: 1,
          );
      if (result.items.isNotEmpty) {
        int maxRegNum = result.items.first.data['registration_number'];
        return maxRegNum + 1;
      } else {
        return 1;
      }
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> updatePatient(Patient patient) async {
    try {
      await pb
          .collection('patient')
          .update(patient.id, body: patient.toJson())
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> updatePatientBloodPressureNow(
      String patientId, String bloodPressureNow) async {
    try {
      await pb.collection('patient').update(patientId, body: {
        'blood_pressure_now': bloodPressureNow,
      }).timeout(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> updatePatientBloodPressureFromNow(String patientId) async {
    try {
      final record = await pb
          .collection('patient')
          .getOne(patientId)
          .timeout(const Duration(seconds: 2));
      final bloodPressureNow = record.data['blood_pressure_now'];
      await pb.collection('patient').update(patientId, body: {
        'blood_pressure': bloodPressureNow,
        'blood_pressure_now': '',
      }).timeout(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> insertMedicalRecordNow(String patientId, String medrecId) async {
    try {
      await pb.collection('patient').update(patientId, body: {
        'medical_record_now': medrecId
      }).timeout(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> deleteMedicalRecordNow(String patientId) async {
    try {
      await pb.collection('patient').update(patientId,
          body: {'medical_record_now': ''}).timeout(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      await pb
          .collection('patient')
          .delete(id)
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(
          'There is an error in the database, please make sure the server ID is correct or turn on the server.');
    }
  }
}
