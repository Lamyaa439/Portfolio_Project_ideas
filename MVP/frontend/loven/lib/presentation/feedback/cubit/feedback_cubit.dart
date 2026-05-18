import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/feedback_remote_datasource.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackRemoteDataSource _remoteDataSource;

  FeedbackCubit(this._remoteDataSource) : super(FeedbackInitial());

  Future<void> submitFeedback({
    required String message,
    String? subject,
  }) async {
    emit(FeedbackLoading());

    try {
      await _remoteDataSource.submitFeedback(
        message: message,
        subject: subject,
      );

      emit(FeedbackSuccess('Feedback submitted successfully'));
    } catch (e) {
      emit(FeedbackError(e.toString()));
    }
  }
}
