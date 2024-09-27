import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/utils/dao/patients_dao.dart';
import 'package:medgis_app/utils/models/patient_model.dart';
import 'package:medgis_app/view/shared/add/bloc/add_state.dart';

class AddCubit extends Cubit<AddState> {
  final PatientDao patientDao;

  AddCubit(this.patientDao) : super(AddInitial());

  void savePatient(
    Patient patient,
  ) async {
    emit(AddLoading());
    try {
      await patientDao.insertPatient(patient);
      emit(AddSuccess());
    } catch (e) {
      emit(AddFailure(e.toString()));
    }
  }
}
