import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';

import '../../data/models/create_event_model.dart';

abstract class EventRepository {
  Future<CreateEventResponse> createEvent(
    CreateEventRequest request,
  );
   Future<GetAllEventsResponse> getAllEvents({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? status,
    String? fromDate,
    String? toDate,
    bool? archived,
  });
}