<<<<<<< Updated upstream
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/home/bloc/home_event.dart';
import 'core/res/theme/app_theme.dart';
import 'presentation/splash/splash_screen.dart';
import 'presentation/auth/cubit/auth_cubit.dart';

class ThemeBloc extends Cubit<ThemeMode> {
  ThemeBloc() : super(ThemeMode.light);
  void toggleTheme() =>
      emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
}

void main() {
  runApp(const LovenApp());
}

class LovenApp extends StatelessWidget {
  const LovenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(FetchHomeData()),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'LOVEN',
            debugShowCheckedModeBanner: false,
            locale: const Locale('en', 'US'),
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'SA'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/home/bloc/home_event.dart';
import 'core/res/theme/app_theme.dart'; // Importing the theme file
import 'presentation/splash/splash_screen.dart';
import 'presentation/auth/cubit/auth_cubit.dart';

// Simple Cubit to manage theme switching logic
class ThemeBloc extends Cubit<ThemeMode> {
  ThemeBloc() : super(ThemeMode.light);
  void toggleTheme() =>
      emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
}

void main() {
  runApp(const LovenApp());
}

class LovenApp extends StatelessWidget {
  const LovenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(FetchHomeData()),
        ),
        // Providing ThemeBloc at the top level
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'LOVEN',
            debugShowCheckedModeBanner: false,

            // --- Bilingual Support ---
            // I added this so user can sweitch between English and Arabic :)
            locale: const Locale('en', 'US'), // defualte Lan
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'SA'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            theme: AppTheme.lightTheme, // Applying the custom theme
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
>>>>>>> Stashed changes
