import '../../../data/models/service_type_model.dart';

abstract class ServiceTypesState {}

class ServiceTypesInitial extends ServiceTypesState {}

class ServiceTypesLoading extends ServiceTypesState {}

class ServiceTypesSuccess extends ServiceTypesState {
  final List<ServiceTypeModel> serviceTypes;

  ServiceTypesSuccess(this.serviceTypes);
}

class ServiceTypesError extends ServiceTypesState {
  final String message;

  ServiceTypesError(this.message);
}