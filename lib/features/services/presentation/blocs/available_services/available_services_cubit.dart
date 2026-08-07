import 'package:eventy_customer/features/services/domain/usecases/get_available_services_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/available_services_model/service_model.dart';
import 'available_services_state.dart';

class AvailableServicesCubit extends Cubit<AvailableServicesState> {
  final GetAvailableServicesUseCase getAvailableServicesUseCase;

  AvailableServicesCubit(this.getAvailableServicesUseCase) : super(AvailableServicesInitial());

  final List<ServiceModel> _services = [];
  int _currentPage = 1;
  bool _hasReachedEnd = false;
  bool _isLoading = false;
  String? _currentType;

  Future<void> loadServices(String? type) async {
    if (_isLoading) return;

    _currentType = type;
    _currentPage = 1;
    _hasReachedEnd = false;
    _services.clear();
    _isLoading = true;

    emit(AvailableServicesLoading());

    try {
      final response = await getAvailableServicesUseCase(type: type, page: 1);

      _services.addAll(response.items);
      _currentPage = response.meta.page;
      _hasReachedEnd = response.meta.page >= response.meta.totalPages;

      emit(AvailableServicesLoaded(services: List.from(_services), hasReachedEnd: _hasReachedEnd));
    } catch (e) {
      emit(AvailableServicesError(e.toString()));
    }

    _isLoading = false;
  }

  /// ⚠️ لا نغادر Loaded إطلاقًا هنا — فقط نُحدّث isLoadingMore داخل نفس الحالة
  Future<void> loadMore() async {
    if (_isLoading) return;
    if (_hasReachedEnd) return;

    final currentState = state;
    if (currentState is! AvailableServicesLoaded) return;

    _isLoading = true;
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final response = await getAvailableServicesUseCase(type: _currentType, page: _currentPage + 1);

      _currentPage = response.meta.page;
      _services.addAll(response.items);
      _hasReachedEnd = response.meta.page >= response.meta.totalPages;

      emit(AvailableServicesLoaded(
        services: List.from(_services),
        hasReachedEnd: _hasReachedEnd,
        isLoadingMore: false,
      ));
    } catch (_) {
      /// فشل تحميل الصفحة التالية لا يمسح القائمة الحالية — فقط نوقف مؤشر التحميل
      emit(currentState.copyWith(isLoadingMore: false));
    }

    _isLoading = false;
  }

  Future<void> refresh() async => loadServices(_currentType);
}