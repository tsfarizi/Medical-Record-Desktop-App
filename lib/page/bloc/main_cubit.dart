import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/bloc/main_state.dart';
import 'package:medgis_app/utils/dao/patients_dao.dart';
import 'package:medgis_app/utils/dao/medical_record_dao.dart';

class MainCubit extends Cubit<MainState> {
  final PatientDao patientDao;
  final MedicalRecordDao medicalRecordDao;

  MainCubit(this.patientDao, this.medicalRecordDao) : super(HomeViewState());

  void setState(MainState state) {
    emit(state);
  }
}
