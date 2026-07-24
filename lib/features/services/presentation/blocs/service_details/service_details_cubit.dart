import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_service_details_usecase.dart';
import 'service_details_state.dart';

class ServiceDetailsCubit extends Cubit<ServiceDetailsState> {
  final GetServiceDetailsUseCase getServiceDetailsUseCase;

  ServiceDetailsCubit(this.getServiceDetailsUseCase) : super(ServiceDetailsInitial());

  bool _isLoading = false;
  String? _currentServiceId;
  String? _currentDate;

  Future<void> loadService(String id, {String? date}) async {
    if (_isLoading) return;

    _currentServiceId = id;
    _currentDate = date;
    _isLoading = true;

    emit(ServiceDetailsLoading());

    try {
      final response = await getServiceDetailsUseCase(id: id, date: date);
      emit(ServiceDetailsLoaded(service: response.data));
    } catch (e) {
      emit(ServiceDetailsError(e.toString()));
    }

    _isLoading = false;
  }

  Future<void> refresh() async {
    if (_currentServiceId == null) return;
    await loadService(_currentServiceId!, date: _currentDate);
  }
}