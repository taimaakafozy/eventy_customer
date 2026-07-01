import '../../../data/models/available_services_model/service_model.dart';

abstract class AvailableServicesState {}

class AvailableServicesInitial extends AvailableServicesState {}

class AvailableServicesLoading extends AvailableServicesState {}

class AvailableServicesLoadingMore extends AvailableServicesState {}

class AvailableServicesLoaded extends AvailableServicesState {
  final List<ServiceModel> services;
  final bool hasReachedEnd;

  AvailableServicesLoaded({
    required this.services,
    required this.hasReachedEnd,
  });
}

class AvailableServicesError extends AvailableServicesState {
  final String message;

  AvailableServicesError(this.message);
}