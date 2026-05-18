import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/alumni.dart';
import '../repositories/alumni_repository.dart';

class RegisterAlumni implements UseCase<Alumni, Alumni> {
  final AlumniRepository repository;
  RegisterAlumni(this.repository);

  @override
  Future<Either<Failure, Alumni>> call(Alumni params) {
    return repository.register(params);
  }
}
