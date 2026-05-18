part of 'alumni_list_bloc.dart';

abstract class AlumniListEvent extends Equatable {
  const AlumniListEvent();

  @override
  List<Object?> get props => [];
}

class AlumniListLoaded extends AlumniListEvent {
  const AlumniListLoaded();
}

class AlumniListSearchChanged extends AlumniListEvent {
  final String query;
  const AlumniListSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class AlumniListBatchFilterChanged extends AlumniListEvent {
  final Batch? batch;
  const AlumniListBatchFilterChanged(this.batch);

  @override
  List<Object?> get props => [batch];
}

class AlumniListSortChanged extends AlumniListEvent {
  final SortBy sortBy;
  const AlumniListSortChanged(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}

class AlumniListRefreshed extends AlumniListEvent {
  const AlumniListRefreshed();
}
