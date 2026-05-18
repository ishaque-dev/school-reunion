import '../../domain/entities/batch.dart';
import '../../domain/entities/stats.dart';

class StatsModel extends Stats {
  const StatsModel({required super.total, required super.perBatch});

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    final raw = (json['perBatch'] as Map?) ?? const {};
    final Map<Batch, int> perBatch = {};
    raw.forEach((k, v) {
      final b = BatchX.fromString(k.toString());
      if (b != null) perBatch[b] = (v as num).toInt();
    });
    for (final b in Batch.values) {
      perBatch.putIfAbsent(b, () => 0);
    }
    return StatsModel(
      total: (json['total'] as num?)?.toInt() ?? 0,
      perBatch: perBatch,
    );
  }
}
