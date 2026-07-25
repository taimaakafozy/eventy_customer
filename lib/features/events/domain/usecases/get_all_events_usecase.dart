import '../../data/models/get_all_events_model.dart';
import '../repository/event_repository.dart';

class GetAllEventsUseCase {
  final EventRepository repository;

  GetAllEventsUseCase(
    this.repository,
  );

  Future<GetAllEventsResponse> call({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  }) {
    return repository.getAllEvents(
      page: page,
      limit: limit,
      sortBy: sortBy,
      order: order,
    );
  }
}