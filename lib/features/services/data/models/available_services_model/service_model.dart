import 'package:eventy_customer/features/services/data/models/available_services_model/service_file_model.dart';

import 'availability_model.dart';
import 'event_type_model.dart';
import 'provider_model.dart';
import 'service_type_model.dart';
import 'sub_service_model.dart';

class ServiceModel {
  final String id;
  final String providerId;
  final String serviceTypeId;

  final String description;

  final double? latitude;
  final double? longitude;
  final String? locationName;

  final String? businessFile;
  final String? serviceLogo;

  final String approvalStatus;

  final bool isCompleted;
  final bool isPackaged;

  final double rating;
  final int totalReviews;

  final int? minCapacity;
  final int? maxCapacity;

  final double? price;

  final DateTime createdAt;
  final DateTime updatedAt;

  final ServiceTypeModel serviceType;

  final ProviderModel provider;

  final List<EventTypeModel> eventTypes;

  final List<ServiceFileModel> files;

  final List<SubServiceModel> subServices;

  final List<AvailabilityModel> availability;

  const ServiceModel({
    required this.id,
    required this.providerId,
    required this.serviceTypeId,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.businessFile,
    required this.serviceLogo,
    required this.approvalStatus,
    required this.isCompleted,
    required this.isPackaged,
    required this.rating,
    required this.totalReviews,
    required this.minCapacity,
    required this.maxCapacity,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceType,
    required this.provider,
    required this.eventTypes,
    required this.files,
    required this.subServices,
    required this.availability,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      providerId: json['providerId'] ?? '',
      serviceTypeId: json['serviceTypeId'] ?? '',
      description: json['description'] ?? '',

      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      locationName: json['locationName'],

      businessFile: json['businessFile'],
      serviceLogo: json['serviceLogo'],

      approvalStatus: json['approvalStatus'] ?? '',

      isCompleted: json['isCompleted'] ?? false,
      isPackaged: json['isPackaged'] ?? false,

      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,

      minCapacity: json['minCapacity'],
      maxCapacity: json['maxCapacity'],

      price: json['price']?.toDouble(),

      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      serviceType: ServiceTypeModel.fromJson(
        json['serviceType'] ?? {},
      ),

      provider: ProviderModel.fromJson(
        json['provider'] ?? {},
      ),

      eventTypes: (json['eventTypes'] as List<dynamic>? ?? [])
          .map((e) => EventTypeModel.fromJson(e))
          .toList(),

      files: (json['files'] as List<dynamic>? ?? [])
          .map((e) => ServiceFileModel.fromJson(e))
          .toList(),

      subServices: (json['subServices'] as List<dynamic>? ?? [])
          .map((e) => SubServiceModel.fromJson(e))
          .toList(),

      availability: (json['availability'] as List<dynamic>? ?? [])
          .map((e) => AvailabilityModel.fromJson(e))
          .toList(),
    );
  }
}