import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/add_service_booking_model.dart';
import '../../../domain/usecases/add_service_to_event_usecase.dart';
import 'add_service_to_event_state.dart';

class AddServiceToEventCubit extends Cubit<AddServiceToEventState> {
  final AddServiceToEventUseCase addServiceToEventUseCase;

  AddServiceToEventCubit(this.addServiceToEventUseCase) : super(AddServiceToEventInitial());

  Future<void> submit(String eventId, AddServiceBookingRequestModel request) async {
    emit(AddServiceToEventLoading());

    try {
      final booking = await addServiceToEventUseCase(eventId, request);
      emit(AddServiceToEventSuccess(booking));
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data is Map ? (e.response?.data['message'] ?? e.response?.data['error']) : null;
      emit(AddServiceToEventError(serverMessage?.toString() ?? e.message ?? "Failed to add service"));
    } catch (e) {
      emit(AddServiceToEventError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}