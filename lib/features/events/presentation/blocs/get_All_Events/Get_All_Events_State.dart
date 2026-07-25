import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';

abstract class GetAllEventsState {}

class GetAllEventsInitial extends GetAllEventsState {}

class GetAllEventsLoading extends GetAllEventsState {}

class GetAllEventsError extends GetAllEventsState {
  final String message;

  GetAllEventsError(this.message);
}

class GetAllEventsLoaded extends GetAllEventsState {
  final List<EventItem> events;
  final bool hasReachedEnd;

  GetAllEventsLoaded({
    required this.events,
    required this.hasReachedEnd,
  });

  GetAllEventsLoaded copyWith({
    List<EventItem>? events,
    bool? hasReachedEnd,
  }) {
    return GetAllEventsLoaded(
      events: events ?? this.events,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}