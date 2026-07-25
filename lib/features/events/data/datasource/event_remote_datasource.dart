import 'package:eventy_customer/features/events/data/models/create_event_model.dart';
import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';

import '../../../../core/network/dio_client.dart';

abstract class EventRemoteDataSource {
  Future<CreateEventResponse> createEvent(
    CreateEventRequest request,
  );
   Future<GetAllEventsResponse> getAllEvents({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  });
}

class EventRemoteDataSourceImpl
    implements EventRemoteDataSource {
  final DioClient client;

  EventRemoteDataSourceImpl(this.client);

  @override
  Future<CreateEventResponse> createEvent(
    CreateEventRequest request,
  ) async {
    final response = await client.dio.post(
      'events',
      data: request.toJson(),
    );

    final data = response.data;

    if (data['success'] != true) {
      throw Exception(
        data['message'] ??
            'Failed to create event',
      );
    }

    return CreateEventResponse.fromJson(
      data,
    );
  }
    @override
  Future<GetAllEventsResponse> getAllEvents({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  }) async {
    final response = await client.dio.get(
      'events',
      queryParameters: {
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'order': order,
      },
    );

    final data = response.data;

    if (data['success'] != true) {
      throw Exception(
        data['message'] ??
            'Failed to load events',
      );
    }

    return GetAllEventsResponse.fromJson(
      data,
    );
  }
}