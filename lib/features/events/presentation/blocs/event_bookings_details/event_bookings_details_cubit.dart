import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_event_bookings_usecase.dart';
import 'event_bookings_details_state.dart';

class EventBookingsDetailsCubit extends Cubit<EventBookingsDetailsState> {
  final GetEventBookingsUseCase getEventBookingsUseCase;
  final String eventId;

  EventBookingsDetailsCubit(this.getEventBookingsUseCase, this.eventId) : super(EventBookingsDetailsLoading());

  Timer? _pollingTimer;

  Future<void> load() async {
    emit(EventBookingsDetailsLoading());
    try {
      final details = await getEventBookingsUseCase(eventId);
      emit(EventBookingsDetailsLoaded(details));
      _syncPolling(details.hasProcessingCashPayments);
    } catch (e) {
      emit(EventBookingsDetailsError(e.toString().replaceFirst('Exception: ', '')));
      _pollingTimer?.cancel();
    }
  }

  /// ⚠️ جديد: يعيد التحميل تلقائيًا كل 10 ثواني طالما فيه دفعة كاش لسا
  /// بانتظار مسح المزوّد لل QR — يتوقف تلقائيًا فور اكتمال كل الدفعات
  void _syncPolling(bool shouldPoll) {
    _pollingTimer?.cancel();
    if (!shouldPoll) return;

    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final details = await getEventBookingsUseCase(eventId);
        emit(EventBookingsDetailsLoaded(details));
        if (!details.hasProcessingCashPayments) {
          _pollingTimer?.cancel();
        }
      } catch (_) {
        // تجاهل فشل تحديث الخلفية الصامت — لا نزعج المستخدم بخطأ
      }
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}