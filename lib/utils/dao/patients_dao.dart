import 'package:pocketbase/pocketbase.dart';
import 'package:medgis_app/utils/models/patient_model.dart';

class PatientDao {
  final PocketBase pb;

  PatientDao(String pocketBaseUrl) : pb = PocketBase(pocketBaseUrl);

  Future<List<Patient>> getAllPatients() async {
    final records = await pb.collection('patient').getFullList();
    return records.map((record) => Patient.fromJson(record.toJson())).toList();
  }

  Future<Patient?> getPatientById(String id) async {
    final record = await pb.collection('patient').getOne(id);
    return Patient.fromJson(record.toJson());
  }

  Future<List<Patient>> getPatientsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final filter = 'id in ["${ids.join('","')}"]';
    final records = await pb.collection('patient').getFullList(filter: filter);
    return records.map((record) => Patient.fromJson(record.toJson())).toList();
  }

  Future<void> insertPatient(Patient patient) async {
    int nextRegistrationNumber = await _getNextRegistrationNumber();
    Map<String, dynamic> patientData = patient.toJson();
    patientData['registration_number'] = nextRegistrationNumber;
    await pb.collection('patient').create(body: patientData);
  }

  Future<int> _getNextRegistrationNumber() async {
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
  }

  Future<void> updatePatient(Patient patient) async {
    await pb.collection('patient').update(patient.id, body: patient.toJson());
  }

  Future<void> deletePatient(String id) async {
    await pb.collection('patient').delete(id);
  }
}
