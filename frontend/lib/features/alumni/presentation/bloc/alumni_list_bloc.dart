import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/alumni.dart';
import '../../domain/entities/batch.dart';
import '../../domain/usecases/get_alumni_list.dart';

part 'alumni_list_event.dart';
part 'alumni_list_state.dart';

class AlumniListBloc extends Bloc<AlumniListEvent, AlumniListState> {
  final GetAlumniList getAlumniList;

  AlumniListBloc({required this.getAlumniList}) : super(const AlumniListState()) {
    on<AlumniListLoaded>(_fetch);
    on<AlumniListRefreshed>(_fetch);
    on<AlumniListSearchChanged>(_onSearchChanged);
    on<AlumniListBatchFilterChanged>(_onBatchChanged);
    on<AlumniListSortChanged>(_onSortChanged);
  }

  Future<void> _fetch(AlumniListEvent event, Emitter<AlumniListState> emit) async {
    emit(state.copyWith(status: AlumniListStatus.loading, clearError: true));
    final result = await getAlumniList(
      AlumniListParams(search: state.search, batch: state.batchFilter),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AlumniListStatus.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: AlumniListStatus.success,
        alumni: data,
      )),
    );
  }

  Future<void> _onSearchChanged(
      AlumniListSearchChanged event, Emitter<AlumniListState> emit) async {
    emit(state.copyWith(search: event.query, status: AlumniListStatus.loading));
    final result = await getAlumniList(
      AlumniListParams(search: event.query, batch: state.batchFilter),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AlumniListStatus.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: AlumniListStatus.success,
        alumni: data,
      )),
    );
  }

  Future<void> _onBatchChanged(
      AlumniListBatchFilterChanged event, Emitter<AlumniListState> emit) async {
    emit(state.copyWith(
      batchFilter: event.batch,
      clearBatchFilter: event.batch == null,
      status: AlumniListStatus.loading,
    ));
    final result = await getAlumniList(
      AlumniListParams(search: state.search, batch: event.batch),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AlumniListStatus.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: AlumniListStatus.success,
        alumni: data,
      )),
    );
  }

  void _onSortChanged(AlumniListSortChanged event, Emitter<AlumniListState> emit) {
    emit(state.copyWith(sortBy: event.sortBy));
  }
}
