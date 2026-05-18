import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/report_remote_datasource.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRemoteDataSource _remoteDataSource;

  ReportCubit(this._remoteDataSource) : super(ReportInitial());

  Future<void> submitReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  }) async {
    emit(ReportLoading());

    try {
      await _remoteDataSource.submitReport(
        targetType: targetType,
        targetId: targetId,
        reason: reason,
        details: details,
      );

      emit(ReportSuccess('Report submitted successfully'));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}
