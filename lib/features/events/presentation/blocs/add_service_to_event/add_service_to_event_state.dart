import '../../../data/models/add_service_booking_model.dart';

abstract class AddServiceToEventState {}

class AddServiceToEventInitial extends AddServiceToEventState {}

class AddServiceToEventLoading extends AddServiceToEventState {}

class AddServiceToEventSuccess extends AddServiceToEventState {
  final AddedBookingModel booking;
  AddServiceToEventSuccess(this.booking);
}

class AddServiceToEventError extends AddServiceToEventState {
  final String message;
  AddServiceToEventError(this.message);
}