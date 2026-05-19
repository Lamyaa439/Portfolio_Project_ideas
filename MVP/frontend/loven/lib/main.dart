import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

import 'features/home/controller/bloc/home_bloc.dart';
import 'features/home/controller/bloc/home_event.dart';

import 'features/navigation/controller/cubit/navigation_bar_cubit.dart';

import 'core/res/theme/app_theme.dart';
import 'core/router/app_router.dart';

import 'features/auth/controller/cubit/auth_cubit.dart';

import 'features/cart/data/repositories/cart_repository.dart';
import 'features/cart/controller/cubit/cart_cubit.dart';

import 'features/artist_profile/model/artist_repository.dart';
import 'features/artist_profile/controller/artist_profile_cubit.dart';

import 'features/artwork/data/repositories/artwork_repository.dart';
import 'features/artwork/controller/cubit/artwork_cubit.dart';

import 'features/order/data/repositories/order_repository.dart';
import 'features/order/controller/cubit/order_cubit.dart';

import 'features/feedback/data/repositories/feedback_repository.dart';
import 'features/feedback/controller/cubit/feedback_cubit.dart';

import 'features/report/data/repositories/report_repository.dart';
import 'features/report/controller/cubit/report_cubit.dart';

class ThemeBloc extends Cubit<ThemeMode> {
  ThemeBloc() : super(ThemeMode.light);

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        BlocProvider<NavigationBarCubit>(
          create: (context) => NavigationBarCubit(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(FetchHomeData()),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<ArtistProfileCubit>(
          create: (context) => ArtistProfileCubit(
            repository: ArtistRepository(),
          ),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(
            CartRepository(),
          ),
        ),
        BlocProvider<ArtworkCubit>(
          create: (context) => ArtworkCubit(
            ArtworkRepository(),
          ),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(
            OrderRepository(),
          ),
        ),
        BlocProvider<FeedbackCubit>(
          create: (context) => FeedbackCubit(
            FeedbackRepository(),
          ),
        ),
        BlocProvider<ReportCubit>(
          create: (context) => ReportCubit(
            ReportRepository(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
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
            routerConfig: router,
          );
        },
      ),
    );
  }
}