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
}