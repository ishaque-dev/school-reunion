import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/stats.dart';
import '../repositories/alumni_repository.dart';

class GetStats implements UseCase<Stats, NoParams> {
  final AlumniRepository repository;
  GetStats(this.repository);

  @override
  Future<Either<Failure, Stats>> call(NoParams params) {
    return repository.getStats();
  }
}
