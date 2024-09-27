abstract class AddState {}

class AddInitial extends AddState {}

class AddLoading extends AddState {}

class AddSuccess extends AddState {}

class AddFailure extends AddState {
  final String message;
  AddFailure(this.message);
}
