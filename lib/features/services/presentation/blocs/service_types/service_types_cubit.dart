import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_service_types_usecase.dart';
import 'service_types_state.dart';

class ServiceTypesCubit extends Cubit<ServiceTypesState> {
  final GetServiceTypesUseCase getServiceTypesUseCase;

  ServiceTypesCubit(
    this.getServiceTypesUseCase,
  ) : super(ServiceTypesInitial());

  Future<void> getServiceTypes() async {
    emit(ServiceTypesLoading());

    try {
      final result =
          await getServiceTypesUseCase();

      emit(
        ServiceTypesSuccess(result),
      );
    } catch (e) {
      emit(
        ServiceTypesError(
          e.toString().replaceAll(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
}