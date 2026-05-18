import '../../../../core/network/api_client.dart';
import '../models/alumni_model.dart';
import '../models/stats_model.dart';

abstract class AlumniRemoteDataSource {
  Future<List<AlumniModel>> getAlumni({String? search, String? batch});
  Future<AlumniModel> getAlumniById(int id);
  Future<AlumniModel> register(AlumniModel alumni);
  Future<StatsModel> getStats();
}

class AlumniRemoteDataSourceImpl implements AlumniRemoteDataSource {
  final ApiClient client;

  AlumniRemoteDataSourceImpl({required this.client});

  @override
  Future<List<AlumniModel>> getAlumni({String? search, String? batch}) async {
    final query = <String, String>{};
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (batch != null && batch.isNotEmpty) query['batch'] = batch;

    final result = await client.get('/alumni', query: query);
    return (result as List)
        .map((e) => AlumniModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AlumniModel> getAlumniById(int id) async {
    final result = await client.get('/alumni/$id');
    return AlumniModel.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<AlumniModel> register(AlumniModel alumni) async {
    final result = await client.post('/alumni', body: alumni.toJson());
    return AlumniModel.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<StatsModel> getStats() async {
    final result = await client.get('/alumni/stats');
    return StatsModel.fromJson(result as Map<String, dynamic>);
  }
}
