import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/alumni.dart';
import '../../domain/entities/batch.dart';
import '../../domain/entities/stats.dart';
import '../../domain/repositories/alumni_repository.dart';
import '../datasources/alumni_remote_datasource.dart';
import '../models/alumni_model.dart';

class AlumniRepositoryImpl implements AlumniRepository {
  final AlumniRemoteDataSource remote;

  AlumniRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<Alumni>>> getAlumni({String? search, Batch? batch}) async {
    return _guard(() async {
      final list = await remote.getAlumni(search: search, batch: batch?.apiValue);
      return list.cast<Alumni>();
    });
  }

  @override
  Future<Either<Failure, Alumni>> getAlumniById(int id) {
    return _guard(() => remote.getAlumniById(id));
  }

  @override
  Future<Either<Failure, Alumni>> register(Alumni alumni) {
    return _guard(() => remote.register(AlumniModel.fromEntity(alumni)));
  }

  @override
  Future<Either<Failure, Stats>> getStats() {
    return _guard(() => remote.getStats());
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
