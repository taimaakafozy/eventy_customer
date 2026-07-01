import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_service_details_usecase.dart';
import 'service_details_state.dart';

class ServiceDetailsCubit extends Cubit<ServiceDetailsState> {
  final GetServiceDetailsUseCase getServiceDetailsUseCase;

  ServiceDetailsCubit(
    this.getServiceDetailsUseCase,
  ) : super(ServiceDetailsInitial());

  bool _isLoading = false;

  String? _currentServiceId;

  Future<void> loadService(
    String id,
  ) async {
    if (_isLoading) return;

    _currentServiceId = id;

    _isLoading = true;

    emit(ServiceDetailsLoading());

    try {
      final response = await getServiceDetailsUseCase(
        id: id,
      );

      emit(
        ServiceDetailsLoaded(
          service: response.data,
        ),
      );
    } catch (e) {
      emit(
        ServiceDetailsError(
          e.toString(),
        ),
      );
    }

    _isLoading = false;
  }

  Future<void> refresh() async {
    if (_currentServiceId == null) return;

    await loadService(_currentServiceId!);
  }
}