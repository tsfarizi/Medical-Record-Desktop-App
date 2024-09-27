import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/bloc/main_cubit.dart';
import 'package:medgis_app/page/bloc/main_state.dart';
import 'package:medgis_app/page/widgets/sidebar.dart';
import 'package:medgis_app/utils/dao/medical_record_dao.dart';
import 'package:medgis_app/utils/dao/patients_dao.dart';
import 'package:medgis_app/utils/dao/queue_dao.dart';
import 'package:medgis_app/utils/services/patient_service.dart';
import 'package:medgis_app/utils/theme/color_scheme.dart';
import 'package:medgis_app/view/shared/add/bloc/add_cubit.dart';
import 'package:medgis_app/view/detail/bloc/detail_cubit.dart';
import 'package:medgis_app/view/detail/view/detail_view.dart';
import 'package:medgis_app/view/home/view/home_view.dart';
import 'package:medgis_app/view/home/bloc/home_cubit.dart';
import 'package:medgis_app/view/queue/bloc/queue_cubit.dart';
import 'package:medgis_app/view/queue/view/queue_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String database = "http://192.168.43.41:2003";
    final PatientDao patientDao = PatientDao(database);
    final MedicalRecordDao medicalRecordDao = MedicalRecordDao(database);
    final PatientService patientService =
        PatientService(patientDao, medicalRecordDao);
    final QueueDao queueDao = QueueDao(database);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit(patientDao, medicalRecordDao),
        ),
        BlocProvider(
          create: (context) => HomeCubit(patientService),
        ),
        BlocProvider(
          create: (context) => AddCubit(patientDao),
        ),
        BlocProvider(
          create: (context) => DetailCubit(patientDao, medicalRecordDao),
        ),
        BlocProvider(
          create: (context) => QueueCubit(patientService, queueDao),
        )
      ],
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: Row(
          children: [
            const Expanded(
              flex: 3,
              child: Sidebar(),
            ),
            Expanded(
              flex: 13,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.all(25),
                child: BlocBuilder<MainCubit, MainState>(
                  builder: (context, state) {
                    if (state is QueueViewState) {
                      return const QueueView();
                    } else if (state is HomeViewState) {
                      return const HomeView();
                    } else if (state is DetailPatientViewState) {
                      return const DetailView();
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
