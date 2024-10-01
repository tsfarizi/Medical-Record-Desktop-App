import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/bloc/main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(QueueViewState());

  void setState(MainState state) {
    emit(state);
  }
}
