abstract class QuoteDecisionState {}

class QuoteDecisionInitial extends QuoteDecisionState {}

class QuoteDecisionSubmitting extends QuoteDecisionState {}

class QuoteDecisionSuccess extends QuoteDecisionState {
  final String message;
  QuoteDecisionSuccess(this.message);
}

class QuoteDecisionError extends QuoteDecisionState {
  final String message;
  QuoteDecisionError(this.message);
}