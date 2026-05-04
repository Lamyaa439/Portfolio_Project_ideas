import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/home/bloc/home_event.dart';
import 'presentation/home/screens/home_screen.dart';
import 'core/res/theme/app_theme.dart'; // Importing the theme file

// You will need this simple Cubit to manage the theme state
// You can move this to a separate file later: lib/core/theme/theme_bloc.dart
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
        // Adding the ThemeBloc provider to manage dark/light state
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
      ],
      // We wrap MaterialApp in a BlocBuilder so it rebuilds when the theme changes
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
            darkTheme: AppTheme.darkTheme, // Applying the dark theme version
            themeMode: themeMode, // This tells the app which one to use

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
