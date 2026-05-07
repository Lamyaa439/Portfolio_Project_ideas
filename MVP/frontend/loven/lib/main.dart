import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/artist_profile/data/datasources/artist_mock_datasource.dart';
import 'features/artist_profile/data/repositories/artist_repository_impl.dart';
import 'features/artist_profile/presentation/bloc/artist_profile_bloc.dart';
import 'features/artist_profile/presentation/bloc/artist_profile_event.dart';
import 'features/artist_profile/presentation/screens/artist_profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام Mock DataSource مؤقتاً (لحين جاهزية الـ backend)
    final mockDataSource = ArtistMockDataSource();

    final repository = ArtistRepositoryImpl(
      remoteDataSource: mockDataSource,
    );

    return MaterialApp(
      title: 'LOVEN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFC2410C),
        scaffoldBackgroundColor: const Color(0xFFFAF7F2),
      ),
      home: BlocProvider(
        create: (_) => ArtistProfileBloc(repository: repository)
          ..add(GetArtistRequested('mock-id-123')),
        child: const ArtistProfileScreen(artistId: 'mock-id-123'),
      ),
    );
  }
}
