abstract class MainState {}

class HomeViewState extends MainState {}

class AddPatientState extends MainState {}

class DetailPatientState extends MainState {
  DetailPatientState();
}

class MainFailure extends MainState {
  final String message;

  MainFailure(this.message);
}
