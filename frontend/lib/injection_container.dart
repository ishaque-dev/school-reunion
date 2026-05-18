import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'features/alumni/data/datasources/alumni_remote_datasource.dart';
import 'features/alumni/data/repositories/alumni_repository_impl.dart';
import 'features/alumni/domain/repositories/alumni_repository.dart';
import 'features/alumni/domain/usecases/get_alumni_list.dart';
import 'features/alumni/domain/usecases/get_stats.dart';
import 'features/alumni/domain/usecases/register_alumni.dart';
import 'features/alumni/presentation/bloc/alumni_list_bloc.dart';
import 'features/alumni/presentation/bloc/register_bloc.dart';
import 'features/alumni/presentation/bloc/stats_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data sources
  sl.registerLazySingleton<AlumniRemoteDataSource>(
    () => AlumniRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AlumniRepository>(
    () => AlumniRepositoryImpl(remote: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAlumniList(sl()));
  sl.registerLazySingleton(() => RegisterAlumni(sl()));
  sl.registerLazySingleton(() => GetStats(sl()));

  // BLoCs — factories so we get fresh instances when requested
  sl.registerFactory(() => AlumniListBloc(getAlumniList: sl()));
  sl.registerFactory(() => RegisterBloc(registerAlumni: sl()));
  sl.registerFactory(() => StatsCubit(getStats: sl()));
}
