import 'package:eventy_customer/features/events/domain/repository/event_repository.dart';

import '../../data/models/event_bookings_details_model.dart';

class GetEventBookingsUseCase {
  final EventRepository repository;
  GetEventBookingsUseCase(this.repository);

  Future<EventBookingsDetailsModel> call(String eventId) => repository.getEventBookings(eventId);
}