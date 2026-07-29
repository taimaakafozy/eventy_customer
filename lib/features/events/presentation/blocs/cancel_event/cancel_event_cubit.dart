import 'package:dio/dio.dart';
import 'package:eventy_customer/features/events/data/models/cancel_event_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/cancel_event_usecase.dart';
import 'cancel_event_state.dart';

class CancelEventCubit extends Cubit<CancelEventState> {
  final CancelEventUseCase cancelEventUseCase;

  CancelEventCubit(this.cancelEventUseCase)
      : super(CancelEventInitial());

  Future<void> cancelEvent({
    required String eventId,
    required CancelEventRequestModel reason,
  }) async {
    emit(CancelEventLoading());

    try {
      await cancelEventUseCase(
        eventId,
        reason,
      );

      emit(
        CancelEventSuccess(
          "Event cancelled successfully",
        ),
      );
    } on DioException catch (e) {
      print("========== CANCEL EVENT ==========");
      print("Status Code: ${e.response?.statusCode}");
      print("Response: ${e.response?.data}");

      final serverMessage =
          e.response?.data is Map
              ? (e.response?.data["message"] ??
                  e.response?.data["error"])
              : null;

      emit(
        CancelEventError(
          serverMessage?.toString() ??
              e.message ??
              "Failed to cancel event",
        ),
      );
    } catch (e) {
      emit(
        CancelEventError(
          e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

  void reset() {
    emit(CancelEventInitial());
  }
}