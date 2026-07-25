import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/get_all_events_model.dart';
import '../../../domain/usecases/get_all_events_usecase.dart';
import 'get_all_events_state.dart';

class GetAllEventsCubit extends Cubit<GetAllEventsState> {
  final GetAllEventsUseCase getAllEventsUseCase;

  GetAllEventsCubit(this.getAllEventsUseCase)
      : super(GetAllEventsInitial());

  bool _isLoading = false;

  int _page = 1;
  final int _limit = 10;

  bool _hasReachedEnd = false;

  final List<EventItem> _events = [];

  Future<void> loadEvents() async {
    if (_isLoading) return;

    _page = 1;
    _hasReachedEnd = false;
    _events.clear();

    _isLoading = true;

    emit(GetAllEventsLoading());

    try {
      final response = await getAllEventsUseCase(
        page: _page,
        limit: _limit,
      );

      _events.addAll(response.data.items);

      _hasReachedEnd =
          response.data.meta.page >= response.data.meta.totalPages;

      emit(
        GetAllEventsLoaded(
          events: List.from(_events),
          hasReachedEnd: _hasReachedEnd,
        ),
      );
    } catch (e) {
      emit(
        GetAllEventsError(
          e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }

    _isLoading = false;
  }

  Future<void> loadMore() async {
    if (_isLoading) return;

    if (_hasReachedEnd) return;

    final currentState = state;

    if (currentState is! GetAllEventsLoaded) return;

    _isLoading = true;

    try {
      final response = await getAllEventsUseCase(
        page: ++_page,
        limit: _limit,
      );

      _events.addAll(response.data.items);

      _hasReachedEnd =
          response.data.meta.page >= response.data.meta.totalPages;

      emit(
        currentState.copyWith(
          events: List.from(_events),
          hasReachedEnd: _hasReachedEnd,
        ),
      );
    } catch (_) {}

    _isLoading = false;
  }

  Future<void> refresh() async {
    await loadEvents();
  }
}