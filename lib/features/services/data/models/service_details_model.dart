class ServiceDetailsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final ServiceDetailsModel data;

  ServiceDetailsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ServiceDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceDetailsResponseModel(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      data: ServiceDetailsModel.fromJson(json["data"]),
    );
  }
}

class ServiceDetailsModel {
  final String id;
  final String providerId;
  final String serviceTypeId;

  final String description;

  final double rating;
  final int totalReviews;

  final String approvalStatus;

  final bool isCompleted;
  final bool isPackaged;

  final double? latitude;
  final double? longitude;
  final String? locationName;

  final double? price;
  final int? minCapacity;
  final int? maxCapacity;

  final String? serviceLogo;
  final String? businessFile;

  final DateTime createdAt;
  final DateTime updatedAt;

  final ServiceTypeInfo serviceType;

  final List<ServiceFile> files;

  final List<AvailabilityModel> availability;

  final List<SubServiceModel> subServices;

  final ProviderModel provider;

  final List<EventTypeModel> eventTypes;

  final MetaModel meta;

  ServiceDetailsModel({
    required this.id,
    required this.providerId,
    required this.serviceTypeId,
    required this.description,
    required this.rating,
    required this.totalReviews,
    required this.approvalStatus,
    required this.isCompleted,
    required this.isPackaged,
    this.latitude,
    this.longitude,
    this.locationName,
    this.price,
    this.minCapacity,
    this.maxCapacity,
    this.serviceLogo,
    this.businessFile,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceType,
    required this.files,
    required this.availability,
    required this.subServices,
    required this.provider,
    required this.eventTypes,
    required this.meta,
  });

  factory ServiceDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceDetailsModel(
      id: json["id"],
      providerId: json["providerId"],
      serviceTypeId: json["serviceTypeId"],
      description: json["description"] ?? "",

      rating: (json["rating"] ?? 0).toDouble(),
      totalReviews: json["totalReviews"] ?? 0,

      approvalStatus: json["approvalStatus"],

      isCompleted: json["isCompleted"] ?? false,
      isPackaged: json["isPackaged"] ?? false,

      latitude: json["latitude"]?.toDouble(),
      longitude: json["longitude"]?.toDouble(),
      locationName: json["locationName"],

      price: json["price"]?.toDouble(),
      minCapacity: json["minCapacity"],
      maxCapacity: json["maxCapacity"],

      serviceLogo: json["serviceLogo"],
      businessFile: json["businessFile"],

      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),

      serviceType: ServiceTypeInfo.fromJson(
        json["serviceType"],
      ),

      files: (json["files"] as List)
          .map((e) => ServiceFile.fromJson(e))
          .toList(),

      availability: (json["availability"] as List)
          .map((e) => AvailabilityModel.fromJson(e))
          .toList(),

      subServices: (json["subServices"] as List)
          .map((e) => SubServiceModel.fromJson(e))
          .toList(),

      provider: ProviderModel.fromJson(
        json["provider"],
      ),

      eventTypes: (json["eventTypes"] as List)
          .map((e) => EventTypeModel.fromJson(e))
          .toList(),

      meta: MetaModel.fromJson(
        json["meta"],
      ),
    );
  }

  bool get hasImages => files.isNotEmpty;

String? get mainImage =>
    files.isNotEmpty ? files.first.url : null;

bool get hasPrice => price != null;

bool get hasLocation =>
    locationName != null &&
    locationName!.trim().isNotEmpty;

String get formattedRating =>
    rating.toStringAsFixed(1);
}

class ServiceTypeInfo {
  final String name;

  ServiceTypeInfo({
    required this.name,
  });

  factory ServiceTypeInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceTypeInfo(
      name: json["name"],
    );
  }
}

class ServiceFile {
  final String url;

  ServiceFile({
    required this.url,
  });

  factory ServiceFile.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceFile(
      url: json["url"] ?? "",
    );
  }
}

class AvailabilityModel {
  final String id;

  final String workFromTime;
  final String workToTime;

  final int capacity;

  final bool hasSlots;

  final List<WorkingDayModel> workingDays;

  final List<TimeSlotModel> timeSlots;

  AvailabilityModel({
    required this.id,
    required this.workFromTime,
    required this.workToTime,
    required this.capacity,
    required this.hasSlots,
    required this.workingDays,
    required this.timeSlots,
  });

  factory AvailabilityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AvailabilityModel(
      id: json["id"],

      workFromTime: json["workFromTime"],

      workToTime: json["workToTime"],

      capacity: json["capacity"] ?? 0,

      hasSlots: json["hasSlots"] ?? false,

      workingDays: (json["workingDays"] as List)
          .map((e) => WorkingDayModel.fromJson(e))
          .toList(),

      timeSlots: (json["timeSlots"] as List)
          .map((e) => TimeSlotModel.fromJson(e))
          .toList(),
    );
  }
}

class WorkingDayModel {
  final String dayOfWeek;

  WorkingDayModel({
    required this.dayOfWeek,
  });

  factory WorkingDayModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkingDayModel(
      dayOfWeek: json["dayOfWeek"],
    );
  }
}

class TimeSlotModel {
  final String id;

  final String fromTime;
  final String toTime;

  final int capacity;

  TimeSlotModel({
    required this.id,
    required this.fromTime,
    required this.toTime,
    required this.capacity,
  });

  factory TimeSlotModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TimeSlotModel(
      id: json["id"],
      fromTime: json["fromTime"],
      toTime: json["toTime"],
      capacity: json["capacity"] ?? 0,
    );
  }
}

class SubServiceModel {
  final String id;

  final String name;

  final String description;

  final double pricePerUnit;

  final String unitType;

  final int dailyCapacity;

  final bool isAvailable;

  SubServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerUnit,
    required this.unitType,
    required this.dailyCapacity,
    required this.isAvailable,
  });

  factory SubServiceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubServiceModel(
      id: json["id"],

      name: json["name"],

      description: json["description"] ?? "",

      pricePerUnit:
          (json["pricePerUnit"] ?? 0).toDouble(),

      unitType: json["unitType"] ?? "",

      dailyCapacity: json["dailyCapacity"] ?? 0,

      isAvailable: json["isAvailable"] ?? false,
    );
  }
}

class ProviderModel {
  final String id;

  final String businessName;

  final String description;

  final String approvalStatus;

  final ProviderUserModel user;

  ProviderModel({
    required this.id,
    required this.businessName,
    required this.description,
    required this.approvalStatus,
    required this.user,
  });

  factory ProviderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProviderModel(
      id: json["id"],

      businessName: json["businessName"],

      description: json["description"] ?? "",

      approvalStatus: json["approvalStatus"],

      user: ProviderUserModel.fromJson(
        json["user"],
      ),
    );
  }
}

class ProviderUserModel {
  final String fullName;

  final String phoneNumber;

  final String? profileImage;

  final String? locationName;

  ProviderUserModel({
    required this.fullName,
    required this.phoneNumber,
    this.profileImage,
    this.locationName,
  });

  factory ProviderUserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProviderUserModel(
      fullName: json["fullName"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      profileImage: json["profileImage"],
      locationName: json["locationName"],
    );
  }
}

class EventTypeModel {
  final String eventType;

  EventTypeModel({
    required this.eventType,
  });

  factory EventTypeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EventTypeModel(
      eventType: json["eventType"],
    );
  }
}

class MetaModel {
  final PaginationModel files;
  final PaginationModel subServices;

  MetaModel({
    required this.files,
    required this.subServices,
  });

  factory MetaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MetaModel(
      files: PaginationModel.fromJson(
        json["files"],
      ),
      subServices: PaginationModel.fromJson(
        json["subServices"],
      ),
    );
  }
}

class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaginationModel(
      total: json["total"] ?? 0,
      page: json["page"] ?? 1,
      limit: json["limit"] ?? 10,
      totalPages: json["totalPages"] ?? 1,
    );
  }
}