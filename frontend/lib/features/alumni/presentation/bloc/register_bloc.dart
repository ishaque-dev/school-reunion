import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/alumni.dart';
import '../../domain/usecases/register_alumni.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterAlumni registerAlumni;

  RegisterBloc({required this.registerAlumni}) : super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmit);
    on<RegisterReset>((_, emit) => emit(const RegisterState()));
  }

  Future<void> _onSubmit(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.submitting, clearError: true));
    final result = await registerAlumni(event.alumni);
    result.fold(
      (failure) => emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: failure.message,
      )),
      (alumni) => emit(state.copyWith(
        status: RegisterStatus.success,
        registered: alumni,
      )),
    );
  }
}
