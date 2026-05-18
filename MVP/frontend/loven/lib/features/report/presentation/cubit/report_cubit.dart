import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loven/features/report/data/repositories/report_repository.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository _reportRepository;

  ReportCubit(this._reportRepository) : super(ReportInitial());

  Future<void> submitReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  }) async {
    emit(ReportLoading());

    try {
      await _reportRepository.submitReport(
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
