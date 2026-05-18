import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/entities/batch.dart';
import '../../domain/entities/stats.dart';
import '../../domain/usecases/get_stats.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  final StatsStatus status;
  final Stats stats;
  final String? errorMessage;

  const StatsState({
    this.status = StatsStatus.initial,
    this.stats = const Stats(total: 0, perBatch: {}),
    this.errorMessage,
  });

  StatsState copyWith({StatsStatus? status, Stats? stats, String? errorMessage}) {
    return StatsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, errorMessage];
}

class StatsCubit extends Cubit<StatsState> {
  final GetStats getStats;
  StatsCubit({required this.getStats}) : super(const StatsState());

  Future<void> load() async {
    emit(state.copyWith(status: StatsStatus.loading));
    final result = await getStats(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: StatsStatus.failure,
        errorMessage: failure.message,
      )),
      (data) {
        final filled = <Batch, int>{};
        for (final b in Batch.values) {
          filled[b] = data.countFor(b);
        }
        emit(state.copyWith(
          status: StatsStatus.success,
          stats: Stats(total: data.total, perBatch: filled),
        ));
      },
    );
  }
}
