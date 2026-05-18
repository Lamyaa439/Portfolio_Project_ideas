import 'package:loven/features/authentication/data/datasources/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<void> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    await _remoteDataSource.login(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String systemRole,
    String? fcmToken,
  }) async {
    await _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      systemRole: systemRole,
      fcmToken: fcmToken,
    );
  }

  Future<void> logout() async {
    await _remoteDataSource.logout();
  }
}