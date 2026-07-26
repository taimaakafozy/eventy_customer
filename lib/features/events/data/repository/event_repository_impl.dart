import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';

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

   @override
  Future<GetAllEventsResponse> getAllEvents({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? status,
    String? fromDate,
    String? toDate,
    bool ?archived,
  }) {
    return remoteDataSource.getAllEvents(
      page: page,
      limit: limit,
      sortBy: sortBy,
      order: order,
      status: status,
      fromDate: fromDate,
      toDate: toDate,
      archived: archived,
    );
  }
}