import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/alumni/presentation/bloc/alumni_list_bloc.dart';
import 'features/alumni/presentation/bloc/register_bloc.dart';
import 'features/alumni/presentation/bloc/stats_cubit.dart';
import 'features/alumni/presentation/pages/home_page.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const ReunionApp());
}

class ReunionApp extends StatelessWidget {
  const ReunionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlumniListBloc>(create: (_) => sl<AlumniListBloc>()),
        BlocProvider<RegisterBloc>(create: (_) => sl<RegisterBloc>()),
        BlocProvider<StatsCubit>(create: (_) => sl<StatsCubit>()..load()),
      ],
      child: MaterialApp(
        title: 'Class Reunion 2026',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
