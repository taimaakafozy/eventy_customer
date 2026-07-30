import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/widgets/emptyview_data.dart';
import 'package:eventy_customer/core/widgets/errorview_data.dart';
import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';
import 'package:eventy_customer/features/events/domain/usecases/get_all_events_usecase.dart';
import 'package:eventy_customer/features/events/presentation/widgets/event_card.dart';
import 'package:flutter/material.dart';

class SelectEventForBookingPage extends StatefulWidget {
  const SelectEventForBookingPage({super.key});

  @override
  State<SelectEventForBookingPage> createState() => _SelectEventForBookingPageState();
}

class _SelectEventForBookingPageState extends State<SelectEventForBookingPage> {
  bool _loading = true;
  String? _error;
  List<EventItem> _addableEvents = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// ⚠️ لا نستخدم GetAllEventsCubit المشترك (Singleton) هنا عمدًا — لتفادي
  /// التأثير على فلتر صفحة "My Events" بشكل جانبي، فنستدعي الـ UseCase مباشرة
  /// كطلب مستقل خاص بهذه الشاشة فقط.
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await sl<GetAllEventsUseCase>().call(page: 1, limit: 50);
      final now = DateTime.now();

      final addable = response.data.items.where((e) {
        final status = e.status.toUpperCase();
        if (status == 'COMPLETED' || status == 'CANCELLED') return false;
        return e.eventDate.isAfter(now.subtract(const Duration(days: 1)));
      }).toList();

      setState(() {
        _addableEvents = addable;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Add to Which Event?")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _addableEvents.isEmpty
                  ? const EmptyView(
                      title: "No events available",
                      message: "Create a new event first, then you can add services to it later.",
                      icon: Icons.event_note_rounded,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                        itemCount: _addableEvents.length,
                        itemBuilder: (context, index) {
                          final event = _addableEvents[index];
                          return EventCard(
                            event: event,
                            onTap: () => Navigator.pop(context, event),
                          );
                        },
                      ),
                    ),
    );
  }
}