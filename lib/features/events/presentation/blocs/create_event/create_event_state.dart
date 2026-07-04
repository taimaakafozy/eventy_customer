abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventSuccess extends EventState {}

class EventError extends EventState {
  final String message;

  EventError(this.message);
}