import '../../../data/models/complaint_model.dart';

abstract class ComplaintDetailsState {}
class ComplaintDetailsLoading extends ComplaintDetailsState {}
class ComplaintDetailsLoaded extends ComplaintDetailsState {
  final ComplaintModel complaint;
  ComplaintDetailsLoaded(this.complaint);
}
class ComplaintDetailsError extends ComplaintDetailsState {
  final String message;
  ComplaintDetailsError(this.message);
}