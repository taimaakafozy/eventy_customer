import 'package:eventy_customer/features/events/data/models/add_service_booking_model.dart';
import 'package:eventy_customer/features/events/data/models/cancel_event_request_model.dart';
import 'package:eventy_customer/features/events/data/models/event_bookings_details_model.dart';
import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';
import 'package:eventy_customer/features/events/data/models/quote_decision_request_model.dart';

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
   Future<EventBookingsDetailsModel> getEventBookings(String eventId);
  Future<void> submitQuoteDecisions(String eventId, QuoteDecisionRequestModel request);

  Future<void> cancelEvent(
  String eventId,
  CancelEventRequestModel request,
);

Future<AddedBookingModel> addServiceToEvent(String eventId, AddServiceBookingRequestModel request);
}