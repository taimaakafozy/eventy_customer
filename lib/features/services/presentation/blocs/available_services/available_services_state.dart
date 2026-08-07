import '../../../data/models/available_services_model/service_model.dart';

abstract class AvailableServicesState {}

class AvailableServicesInitial extends AvailableServicesState {}

class AvailableServicesLoading extends AvailableServicesState {}

class AvailableServicesLoaded extends AvailableServicesState {
  final List<ServiceModel> services;
  final bool hasReachedEnd;
  final bool isLoadingMore;

  AvailableServicesLoaded({
    required this.services,
    required this.hasReachedEnd,
    this.isLoadingMore = false,
  });

  AvailableServicesLoaded copyWith({
    List<ServiceModel>? services,
    bool? hasReachedEnd,
    bool? isLoadingMore,
  }) {
    return AvailableServicesLoaded(
      services: services ?? this.services,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class AvailableServicesError extends AvailableServicesState {
  final String message;
  AvailableServicesError(this.message);
}