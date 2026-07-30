import '../../data/models/add_service_booking_model.dart';
import '../repository/event_repository.dart';

class AddServiceToEventUseCase {
  final EventRepository repository;

  AddServiceToEventUseCase(this.repository);

  Future<AddedBookingModel> call(String eventId, AddServiceBookingRequestModel request) {
    return repository.addServiceToEvent(eventId, request);
  }
}