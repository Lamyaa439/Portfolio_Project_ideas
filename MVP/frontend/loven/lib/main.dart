import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/home/bloc/home_event.dart';
import 'presentation/home/screens/home_screen.dart';
import 'core/res/theme/app_theme.dart'; // Importing the theme file

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
      ],
      child: MaterialApp(
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

        home: HomeScreen(),
      ),
    );
  }
}
