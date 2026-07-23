import 'package:eventy_customer/features/events/data/models/create_event_model.dart';

abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventSuccess extends EventState {
  final CreateEventResponse response;

  EventSuccess(this.response);
}

class EventError extends EventState {
  final String message;

  EventError(this.message);
}