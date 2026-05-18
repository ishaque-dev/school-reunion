part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final Alumni alumni;
  const RegisterSubmitted(this.alumni);

  @override
  List<Object?> get props => [alumni];
}

class RegisterReset extends RegisterEvent {
  const RegisterReset();
}
