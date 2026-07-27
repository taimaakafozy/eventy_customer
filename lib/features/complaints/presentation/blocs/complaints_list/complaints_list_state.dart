import '../../../data/models/complaint_model.dart';

abstract class ComplaintsListState {}
class ComplaintsListInitial extends ComplaintsListState {}
class ComplaintsListLoading extends ComplaintsListState {}
class ComplaintsListLoaded extends ComplaintsListState {
  final List<ComplaintModel> items;
  final bool hasReachedEnd;
  ComplaintsListLoaded({required this.items, required this.hasReachedEnd});
}
class ComplaintsListError extends ComplaintsListState {
  final String message;
  ComplaintsListError(this.message);
}