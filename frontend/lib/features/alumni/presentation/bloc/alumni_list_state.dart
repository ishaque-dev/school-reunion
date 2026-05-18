part of 'alumni_list_bloc.dart';

enum SortBy { name, batch, city, occupation }

extension SortByX on SortBy {
  String get label {
    switch (this) {
      case SortBy.name:
        return 'Name';
      case SortBy.batch:
        return 'Batch';
      case SortBy.city:
        return 'City';
      case SortBy.occupation:
        return 'Occupation';
    }
  }
}

enum AlumniListStatus { initial, loading, success, failure }

class AlumniListState extends Equatable {
  final AlumniListStatus status;
  final List<Alumni> alumni;
  final String search;
  final Batch? batchFilter;
  final SortBy sortBy;
  final String? errorMessage;

  const AlumniListState({
    this.status = AlumniListStatus.initial,
    this.alumni = const [],
    this.search = '',
    this.batchFilter,
    this.sortBy = SortBy.name,
    this.errorMessage,
  });

  List<Alumni> get sortedAlumni {
    final list = List<Alumni>.from(alumni);
    switch (sortBy) {
      case SortBy.name:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortBy.batch:
        list.sort((a, b) => a.batch.index.compareTo(b.batch.index));
        break;
      case SortBy.city:
        list.sort((a, b) =>
            (a.city ?? '').toLowerCase().compareTo((b.city ?? '').toLowerCase()));
        break;
      case SortBy.occupation:
        list.sort((a, b) => (a.occupation ?? '')
            .toLowerCase()
            .compareTo((b.occupation ?? '').toLowerCase()));
        break;
    }
    return list;
  }

  AlumniListState copyWith({
    AlumniListStatus? status,
    List<Alumni>? alumni,
    String? search,
    Batch? batchFilter,
    bool clearBatchFilter = false,
    SortBy? sortBy,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AlumniListState(
      status: status ?? this.status,
      alumni: alumni ?? this.alumni,
      search: search ?? this.search,
      batchFilter: clearBatchFilter ? null : (batchFilter ?? this.batchFilter),
      sortBy: sortBy ?? this.sortBy,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, alumni, search, batchFilter, sortBy, errorMessage];
}
