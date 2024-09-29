abstract class MainState {}

class HomeViewState extends MainState {}

class AddPatientViewState extends MainState {}

class DetailPatientViewState extends MainState {}

class QueueViewState extends MainState {}

class SettingsViewState extends MainState {}

class MainFailure extends MainState {
  final String message;

  MainFailure(this.message);
}
