import '../../data/models/create_event_model.dart';

abstract class EventRepository {
  Future<CreateEventResponse> createEvent(
    CreateEventRequest request,
  );
}