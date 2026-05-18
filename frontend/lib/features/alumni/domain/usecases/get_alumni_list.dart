import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/alumni.dart';
import '../entities/batch.dart';
import '../repositories/alumni_repository.dart';

class GetAlumniList implements UseCase<List<Alumni>, AlumniListParams> {
  final AlumniRepository repository;
  GetAlumniList(this.repository);

  @override
  Future<Either<Failure, List<Alumni>>> call(AlumniListParams params) {
    return repository.getAlumni(search: params.search, batch: params.batch);
  }
}

class AlumniListParams extends Equatable {
  final String? search;
  final Batch? batch;
  const AlumniListParams({this.search, this.batch});

  @override
  List<Object?> get props => [search, batch];
}
