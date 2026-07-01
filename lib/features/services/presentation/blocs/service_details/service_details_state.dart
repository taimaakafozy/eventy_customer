import 'package:eventy_customer/features/services/data/models/service_details_model.dart';

abstract class ServiceDetailsState {}

class ServiceDetailsInitial extends ServiceDetailsState {}

class ServiceDetailsLoading extends ServiceDetailsState {}

class ServiceDetailsLoaded extends ServiceDetailsState {
  final ServiceDetailsModel service;

  ServiceDetailsLoaded({
    required this.service,
  });
}

class ServiceDetailsError extends ServiceDetailsState {
  final String message;

  ServiceDetailsError(this.message);
}