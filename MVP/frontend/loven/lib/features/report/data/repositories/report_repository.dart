import 'package:loven/features/report/data/datasources/report_remote_datasource.dart';

class ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepository(this._remoteDataSource);

  Future<Map<String, dynamic>> submitReport({
    required String reason,
    required String targetType,
    required String targetId,
    String? description,
  }) async {
    return await _remoteDataSource.submitReport(
      reason: reason,
      targetType: targetType,
      targetId: targetId,
      description: description,
    );
  }
}