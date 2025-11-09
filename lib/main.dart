import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/features/home/presentation/cubit/cart_cubit.dart';
import 'package:nti_final_project_new/features/home/presentation/cubit/favourite_cubit.dart';
//import 'package:nti_final_project_new/features/main/main_screen.dart';
import 'package:nti_final_project_new/iconpage.dart';

import 'core/services/cache/cache_helper.dart';
import 'core/utils/app/app_cubit.dart';
import 'core/utils/app/app_state.dart';
import 'core/utils/theme/dark_mode.dart';
import 'core/utils/theme/light_mode.dart';
import 'map_routs_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FavoriteCubit()),
        BlocProvider(create: (context) => AppCubit()),
        BlocProvider(create: (context) => FavoriteCubit()),
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).getTheme(),
            initialRoute: "/",
            routes: routsApp,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

//git status
//git add .
//git commit -m "Added new features and updated files"
//git push origin main
