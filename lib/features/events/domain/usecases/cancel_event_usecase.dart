import 'package:eventy_customer/features/events/domain/repository/event_repository.dart';

import '../../data/models/cancel_event_request_model.dart';
class CancelEventUseCase {
  final EventRepository repository;
  CancelEventUseCase(this.repository);

  Future<void> call(String eventId, CancelEventRequestModel request) =>
      repository.cancelEvent(eventId, request);
}