import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/review_model.dart';
import '../../../domain/usecases/get_service_reviews_usecase.dart';
import 'service_reviews_state.dart';

class ServiceReviewsCubit extends Cubit<ServiceReviewsState> {
  final GetServiceReviewsUseCase getServiceReviewsUseCase;
  ServiceReviewsCubit(this.getServiceReviewsUseCase) : super(ServiceReviewsLoading());

  final List<ReviewModel> _items = [];
  String? _serviceId;
  int _page = 1;
  final int _limit = 5;
  bool _hasReachedEnd = false;
  bool _isLoading = false;

  Future<void> load(String serviceId) async {
    if (_isLoading) return;

    _serviceId = serviceId;
    _page = 1;
    _hasReachedEnd = false;
    _items.clear();
    _isLoading = true;

    emit(ServiceReviewsLoading());

    try {
      final response = await getServiceReviewsUseCase(serviceId, page: _page, limit: _limit);

      _items.addAll(response.items);
      _hasReachedEnd = response.meta.page >= response.meta.totalPages;

      emit(ServiceReviewsLoaded(items: List.from(_items), total: response.meta.total, hasReachedEnd: _hasReachedEnd));
    } catch (e) {
      emit(ServiceReviewsError(e.toString().replaceFirst('Exception: ', '')));
    }

    _isLoading = false;
  }

  Future<void> loadMore() async {
    if (_isLoading || _hasReachedEnd || _serviceId == null) return;

    final currentState = state;
    if (currentState is! ServiceReviewsLoaded) return;

    _isLoading = true;
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final response = await getServiceReviewsUseCase(_serviceId!, page: _page + 1, limit: _limit);

      _page = response.meta.page;
      _items.addAll(response.items);
      _hasReachedEnd = response.meta.page >= response.meta.totalPages;

      emit(ServiceReviewsLoaded(
        items: List.from(_items),
        total: response.meta.total,
        hasReachedEnd: _hasReachedEnd,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(currentState.copyWith(isLoadingMore: false));
    }

    _isLoading = false;
  }
}