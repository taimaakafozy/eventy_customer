import 'package:eventy_customer/features/events/data/models/add_service_booking_model.dart';
import 'package:eventy_customer/features/events/data/models/cancel_event_request_model.dart';
import 'package:eventy_customer/features/events/data/models/event_bookings_details_model.dart';
import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';
import 'package:eventy_customer/features/events/data/models/quote_decision_request_model.dart';

import '../../domain/repository/event_repository.dart';
import '../datasource/event_remote_datasource.dart';
import '../models/create_event_model.dart';

class EventRepositoryImpl
    implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<CreateEventResponse> createEvent(
    CreateEventRequest request,
  ) {
    return remoteDataSource.createEvent(
      request,
    );
  }

   @override
  Future<GetAllEventsResponse> getAllEvents({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? status,
    String? fromDate,
    String? toDate,
    bool ?archived,
  }) {
    return remoteDataSource.getAllEvents(
      page: page,
      limit: limit,
      sortBy: sortBy,
      order: order,
      status: status,
      fromDate: fromDate,
      toDate: toDate,
      archived: archived,
    );
  }

  @override
  Future<EventBookingsDetailsModel> getEventBookings(String eventId) => remoteDataSource.getEventBookings(eventId);

  @override
  Future<void> submitQuoteDecisions(String eventId, QuoteDecisionRequestModel request) =>
      remoteDataSource.submitQuoteDecisions(eventId, request);

      @override
Future<void> cancelEvent(
  String eventId,
  CancelEventRequestModel request,
) =>
    remoteDataSource.cancelEvent(
      eventId,
      request,
    );

     @override
  Future<AddedBookingModel> addServiceToEvent(String eventId, AddServiceBookingRequestModel request) {
    return remoteDataSource.addServiceToEvent(eventId, request);
  }
}