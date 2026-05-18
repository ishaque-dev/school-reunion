part of 'register_bloc.dart';

enum RegisterStatus { initial, submitting, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final Alumni? registered;
  final String? errorMessage;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.registered,
    this.errorMessage,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    Alumni? registered,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      registered: registered ?? this.registered,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, registered, errorMessage];
}
