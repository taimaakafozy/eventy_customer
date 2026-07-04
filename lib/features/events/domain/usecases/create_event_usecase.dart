import '../../data/models/create_event_model.dart';
import '../repository/event_repository.dart';

class CreateEventUseCase {
  final EventRepository repository;

  CreateEventUseCase(
    this.repository,
  );

  Future<CreateEventResponse> call(
    CreateEventRequest request,
  ) {
    return repository.createEvent(
      request,
    );
  }
}