import '../../../data/models/complaint_model.dart';

abstract class CreateComplaintState {}
class CreateComplaintInitial extends CreateComplaintState {}
class CreateComplaintLoading extends CreateComplaintState {}
class CreateComplaintSuccess extends CreateComplaintState {
  final ComplaintModel complaint;
  CreateComplaintSuccess(this.complaint);
}
class CreateComplaintError extends CreateComplaintState {
  final String message;
  CreateComplaintError(this.message);
}