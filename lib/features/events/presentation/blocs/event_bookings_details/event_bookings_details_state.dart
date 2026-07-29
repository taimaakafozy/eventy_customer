import '../../../data/models/event_bookings_details_model.dart';

abstract class EventBookingsDetailsState {}

class EventBookingsDetailsLoading extends EventBookingsDetailsState {}

class EventBookingsDetailsLoaded extends EventBookingsDetailsState {
  final EventBookingsDetailsModel details;
  EventBookingsDetailsLoaded(this.details);
}

class EventBookingsDetailsError extends EventBookingsDetailsState {
  final String message;
  EventBookingsDetailsError(this.message);
}