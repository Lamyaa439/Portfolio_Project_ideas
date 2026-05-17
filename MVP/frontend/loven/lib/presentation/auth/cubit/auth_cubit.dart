import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../../data/datasources/auth_remote_data_source.dart';
import '../../../core/storage/token_storage.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSource();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await _authRemoteDataSource.login(
        email: email,
        password: password,
      );

      emit(AuthSuccess());
    } catch (e) {
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
      await _authRemoteDataSource.register(
        name: name,
        email: email,
        password: password,
        systemRole: systemRole,
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(_mapErrorMessage(e)));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await TokenStorage().clearToken();

      emit(AuthInitial());
    } catch (e) {
      emit(AuthInitial());
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

    return 'Something went wrong';
  }
}
