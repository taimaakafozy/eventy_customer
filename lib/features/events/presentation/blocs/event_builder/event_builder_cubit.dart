import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_builder_state.dart';

/// Cubit مسؤول عن إدارة اختيارات الخدمات أثناء إنشاء/تعديل مناسبة.
/// يبقى نفس الـ instance حياً طوال رحلة التصفح (ServicesPage -> ServiceDetailsPage)
/// حتى يرجع المستخدم لصفحة إنشاء المناسبة، وبالتالي لا حاجة لأي إعادة جلب بيانات.
class EventBuilderCubit extends Cubit<Map<String, SelectedService>> {
  EventBuilderCubit() : super(const {});

  void toggleSubService({
    required String serviceId,
    required String serviceName,
    required String subServiceId,
    required String subServiceName,
    required double pricePerUnit,
    required String unitType,
    int initialQty = 1,
  }) {
    final updated = _cloneState();
    final currentSubs = updated[serviceId]?.subServices ?? {};
    final newSubMap = Map<String, SelectedSubService>.from(currentSubs);

    if (newSubMap.containsKey(subServiceId)) {
      newSubMap.remove(subServiceId);
    } else {
      newSubMap[subServiceId] = SelectedSubService(
        id: subServiceId,
        name: subServiceName,
        pricePerUnit: pricePerUnit,
        unitType: unitType,
        quantity: initialQty,
      );
    }

    if (newSubMap.isEmpty) {
      updated.remove(serviceId);
    } else {
      updated[serviceId] =
          SelectedService(serviceId: serviceId, serviceName: serviceName, subServices: newSubMap);
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

    updated[serviceId] =
        SelectedService(serviceId: serviceId, serviceName: service.serviceName, subServices: newSubMap);

    emit(updated);
  }

  void removeService(String serviceId) {
    final updated = _cloneState()..remove(serviceId);
    emit(updated);
  }

  void reset() => emit(const {});

  double get totalPrice => state.values.fold(
        0.0,
        (sum, service) => sum +
            service.subServices.values.fold(0.0, (subSum, sub) => subSum + sub.pricePerUnit * sub.quantity),
      );

  Map<String, SelectedService> _cloneState() => Map<String, SelectedService>.from(state);
}