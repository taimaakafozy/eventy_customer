abstract class CancelEventState {}

class CancelEventInitial extends CancelEventState {}

class CancelEventLoading extends CancelEventState {}

class CancelEventSuccess extends CancelEventState {
  final String message;
  CancelEventSuccess(this.message);
}

class CancelEventError extends CancelEventState {
  final String message;
  CancelEventError(this.message);
}
