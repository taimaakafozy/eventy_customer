import 'package:eventy_customer/features/events/domain/repository/event_repository.dart';

import '../../data/models/quote_decision_request_model.dart';
class SubmitQuoteDecisionsUseCase {
  final EventRepository repository;
  SubmitQuoteDecisionsUseCase(this.repository);

  Future<void> call(String eventId, QuoteDecisionRequestModel request) =>
      repository.submitQuoteDecisions(eventId, request);
}