import 'package:equatable/equatable.dart';
import 'batch.dart';

class Stats extends Equatable {
  final int total;
  final Map<Batch, int> perBatch;

  const Stats({required this.total, required this.perBatch});

  int countFor(Batch b) => perBatch[b] ?? 0;

  @override
  List<Object?> get props => [total, perBatch];
}
