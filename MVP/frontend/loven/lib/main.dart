import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/home/bloc/home_event.dart';
import 'core/res/theme/app_theme.dart';
import 'presentation/splash/splash_screen.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'data/datasources/cart_remote_datasource.dart';
import 'data/datasources/artist_profile_remote_datasource.dart';
import 'presentation/cart/cubit/cart_cubit.dart';
import 'presentation/artist_profile/cubit/artist_profile_cubit.dart';

// Simple Cubit to manage theme switching logic
class ThemeBloc extends Cubit<ThemeMode> {
  ThemeBloc() : super(ThemeMode.light);

  void toggleTheme() =>
      emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before running the app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Listen for foreground Firebase push notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FOREGROUND MESSAGE TITLE: ${message.notification?.title}");
    print("FOREGROUND MESSAGE BODY: ${message.notification?.body}");
    print("FOREGROUND MESSAGE DATA: ${message.data}");
  });

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
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(
            CartRemoteDataSource(),
          ),
        ),
        BlocProvider<ArtistProfileCubit>(
          create: (context) => ArtistProfileCubit(
            ArtistProfileRemoteDataSource(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'LOVEN',
            debugShowCheckedModeBanner: false,

            // Bilingual support: English and Arabic
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

            // App theme configuration
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
