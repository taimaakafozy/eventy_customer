import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/quote_decision_request_model.dart';
import '../../../domain/usecases/submit_quote_decisions_usecase.dart';
import 'quote_decision_state.dart';

class QuoteDecisionCubit extends Cubit<QuoteDecisionState> {
  final SubmitQuoteDecisionsUseCase submitQuoteDecisionsUseCase;
  final String eventId;

  QuoteDecisionCubit(this.submitQuoteDecisionsUseCase, this.eventId) : super(QuoteDecisionInitial());

  Future<void> submit({
    required List<String> acceptedBookingIds,
    String? method,
    List<String> rejectedBookingIds = const [],
    String? rejectionReason,
  }) async {
    emit(QuoteDecisionSubmitting());

    try {
      await submitQuoteDecisionsUseCase(
        eventId,
        QuoteDecisionRequestModel(
          eventId: eventId,
          acceptedBookingIds: acceptedBookingIds,
          method: method,
          rejectedBookingIds: rejectedBookingIds,
          rejectionReason: rejectionReason,
        ),
      );

      emit(QuoteDecisionSuccess("Your decision has been submitted"));
    } on DioException catch (e) {
      /// ⚠️ نطبع تفاصيل الخطأ الحقيقية للتشخيص، ونعرض رسالة السيرفر للمستخدم
      print('❌ QUOTE DECISION FAILED');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Body: ${e.response?.data}');

      final serverMessage =
          e.response?.data is Map ? (e.response?.data['message'] ?? e.response?.data['error']) : null;

      emit(QuoteDecisionError(serverMessage?.toString() ?? e.message ?? "Failed to submit your decision"));
    } catch (e) {
      emit(QuoteDecisionError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void reset() => emit(QuoteDecisionInitial());
}