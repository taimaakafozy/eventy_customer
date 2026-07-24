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
    } catch (e) {
      emit(EventError(e.toString().replaceFirst('Exception: ', '')));
      print('Error creating event: $e'); 
    }
  }

  void reset() => emit(EventInitial());
}
