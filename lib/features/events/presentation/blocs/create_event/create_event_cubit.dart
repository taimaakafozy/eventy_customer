import 'package:dio/dio.dart';
import 'package:eventy_customer/features/events/data/models/create_event_model.dart';
import 'package:eventy_customer/features/events/presentation/blocs/create_event/create_event_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/create_event_usecase.dart';

class EventCubit extends Cubit<EventState> {
  final CreateEventUseCase createEventUseCase;

  EventCubit(this.createEventUseCase) : super(EventInitial());

  Future<void> createEvent(CreateEventRequest request) async {
    emit(EventLoading());

    try {
      final response = await createEventUseCase(request);
      emit(EventSuccess(response));
    } on DioException catch (e) {
      /// ⚠️ هذا الجزء هو الأهم للتشخيص — يطبع رسالة السيرفر الحقيقية
      print('❌ CREATE EVENT FAILED');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Body: ${e.response?.data}');
      print('Request Body Sent: ${request.toJson()}');

      final serverMessage = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.response?.data['error'])
          : null;

      emit(EventError(
        serverMessage?.toString() ?? e.message ?? "Failed to create event",
      ));
    } catch (e) {
      emit(EventError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void reset() => emit(EventInitial());
}