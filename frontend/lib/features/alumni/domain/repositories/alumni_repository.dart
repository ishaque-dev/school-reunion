import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/alumni.dart';
import '../entities/batch.dart';
import '../entities/stats.dart';

abstract class AlumniRepository {
  Future<Either<Failure, List<Alumni>>> getAlumni({String? search, Batch? batch});

  Future<Either<Failure, Alumni>> getAlumniById(int id);

  Future<Either<Failure, Alumni>> register(Alumni alumni);

  Future<Either<Failure, Stats>> getStats();
}
