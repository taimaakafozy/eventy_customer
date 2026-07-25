class GetAllEventsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final EventsData data;
  final String timestamp;

  GetAllEventsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory GetAllEventsResponse.fromJson(Map<String, dynamic> json) {
    return GetAllEventsResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: EventsData.fromJson(json['data']),
      timestamp: json['timestamp'],
    );
  }
}

class EventsData {
  final List<EventItem> items;
  final EventsMeta meta;

  EventsData({
    required this.items,
    required this.meta,
  });

  factory EventsData.fromJson(Map<String, dynamic> json) {
    return EventsData(
      items: (json['items'] as List)
          .map((e) => EventItem.fromJson(e))
          .toList(),
      meta: EventsMeta.fromJson(json['meta']),
    );
  }
}

class EventItem {
  final String id;
  final String customerId;
  final String name;
  final String eventType;
  final DateTime eventDate;
  final String eventStartTime;
  final String eventEndTime;
  final String eventLocation;
  final int numberOfGuests;
  final String customerNotes;
  final String status;
  final String? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EventCustomer customer;

  EventItem({
    required this.id,
    required this.customerId,
    required this.name,
    required this.eventType,
    required this.eventDate,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.eventLocation,
    required this.numberOfGuests,
    required this.customerNotes,
    required this.status,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.customer,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id'],
      customerId: json['customerId'],
      name: json['name'],
      eventType: json['eventType'],
      eventDate: DateTime.parse(json['eventDate']),
      eventStartTime: json['eventStartTime'],
      eventEndTime: json['eventEndTime'],
      eventLocation: json['eventLocation'],
      numberOfGuests: json['numberOfGuests'],
      customerNotes: json['customerNotes'] ?? '',
      status: json['status'],
      archivedAt: json['archivedAt'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      customer: EventCustomer.fromJson(json['customer']),
    );
  }
}

class EventCustomer {
  final String id;
  final String fullName;
  final String email;

  EventCustomer({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory EventCustomer.fromJson(Map<String, dynamic> json) {
    return EventCustomer(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
    );
  }
}

class EventsMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  EventsMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory EventsMeta.fromJson(Map<String, dynamic> json) {
    return EventsMeta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }
}