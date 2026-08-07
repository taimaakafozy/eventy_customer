import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_builder_state.dart';

class EventBuilderCubit extends Cubit<Map<String, SelectedService>> {
  EventBuilderCubit() : super(const {});

  void toggleSubService({
    required String serviceId,
    required String serviceName,
    required String subServiceId,
    required String subServiceName,
    required double pricePerUnit, // ⚠️ يُمرَّر الآن كـ finalPrice
    double? originalPricePerUnit,
    double? percentOff,
    required String unitType,
    String? timeSlotId,
    int initialQty = 1,
  }) {
    final updated = _cloneState();
    final existing = updated[serviceId];
    final currentSubs = existing?.subServices ?? {};
    final newSubMap = Map<String, SelectedSubService>.from(currentSubs);

    if (newSubMap.containsKey(subServiceId)) {
      newSubMap.remove(subServiceId);
    } else {
      newSubMap[subServiceId] = SelectedSubService(
        id: subServiceId,
        name: subServiceName,
        pricePerUnit: pricePerUnit,
        originalPricePerUnit: originalPricePerUnit,
        percentOff: percentOff,
        unitType: unitType,
        quantity: initialQty,
      );
    }

    if (newSubMap.isEmpty) {
      updated.remove(serviceId);
    } else {
      updated[serviceId] = SelectedService(
        serviceId: serviceId,
        serviceName: serviceName,
        subServices: newSubMap,
        timeSlotId: timeSlotId ?? existing?.timeSlotId,
      );
    }

    emit(updated);
  }

  void setQuantity(String serviceId, String subServiceId, int quantity) {
    if (quantity < 1) return;
    final service = state[serviceId];
    if (service == null || !service.subServices.containsKey(subServiceId)) return;

    final updated = _cloneState();
    final newSubMap = Map<String, SelectedSubService>.from(service.subServices);
    newSubMap[subServiceId] = newSubMap[subServiceId]!.copyWith(quantity: quantity);

    updated[serviceId] = service.copyWith(subServices: newSubMap);
    emit(updated);
  }

  void toggleWholeService({
    required String serviceId,
    required String serviceName,
    required double price, // ⚠️ finalPrice
    double? originalPrice,
    double? percentOff,
    String? timeSlotId,
  }) {
    final updated = _cloneState();

    if (updated.containsKey(serviceId)) {
      updated.remove(serviceId);
    } else {
      updated[serviceId] = SelectedService(
        serviceId: serviceId,
        serviceName: serviceName,
        subServices: const {},
        wholeServicePrice: price,
        wholeServiceOriginalPrice: originalPrice,
        wholeServicePercentOff: percentOff,
        timeSlotId: timeSlotId,
      );
    }

    emit(updated);
  }

  void removeService(String serviceId) {
    final updated = _cloneState()..remove(serviceId);
    emit(updated);
  }

  void reset() => emit(const {});

  double get totalPrice => state.values.fold(0.0, (sum, service) {
        final subsTotal = service.subServices.values
            .fold(0.0, (subSum, sub) => subSum + sub.pricePerUnit * sub.quantity);
        return sum + subsTotal + (service.wholeServicePrice ?? 0);
      });

  Map<String, SelectedService> _cloneState() => Map<String, SelectedService>.from(state);
}