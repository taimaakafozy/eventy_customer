import 'package:eventy_customer/features/events/data/models/create_event_model.dart';

import '../../../../core/network/dio_client.dart';

abstract class EventRemoteDataSource {
  Future<CreateEventResponse> createEvent(
    CreateEventRequest request,
  );
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
}