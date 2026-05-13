import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../data/datasources/auth_remote_data_source.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRemoteDataSource _authRemoteDataSource =
      AuthRemoteDataSource();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      // Get Firebase Cloud Messaging device token
      final fcmToken =
          await FirebaseMessaging.instance.getToken();

      print("LOGIN FCM TOKEN: $fcmToken");

      await _authRemoteDataSource.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      emit(AuthSuccess());

    } catch (e) {
      print("LOGIN ERROR: $e");

      emit(AuthFailure(_mapErrorMessage(e)));
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String systemRole,
  }) async {
    emit(AuthLoading());

    try {
      // Get Firebase Cloud Messaging device token
      final fcmToken =
          await FirebaseMessaging.instance.getToken();

      print("SIGNUP FCM TOKEN: $fcmToken");

      await _authRemoteDataSource.register(
        name: name,
        email: email,
        password: password,
        systemRole: systemRole,
        fcmToken: fcmToken,
      );

      emit(AuthSuccess());

    } catch (e) {
      print("SIGNUP ERROR: $e");

      emit(AuthFailure(_mapErrorMessage(e)));
    }
  }

  String _mapErrorMessage(Object error) {
    final errorText = error.toString();

    if (errorText.contains('User already exists')) {
      return 'An account with this email already exists';
    }

    if (errorText.contains('Invalid credentials') ||
        errorText.contains('401')) {
      return 'Invalid email or password';
    }

    if (errorText.contains('Failed to fetch')) {
      return 'Unable to connect to server';
    }

    if (errorText.contains('400')) {
      return 'Please check your input';
    }

    // TEMPORARY:
    // Show actual backend/Firebase errors while debugging
    return errorText;
  }
}