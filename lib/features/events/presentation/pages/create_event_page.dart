import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/widgets/primary_button.dart';
import 'package:eventy_customer/core/widgets/primary_text_field.dart';
import 'package:eventy_customer/core/widgets/primary_quantity_stepper.dart';
import 'package:eventy_customer/core/widgets/snackbar_helper.dart';
import 'package:eventy_customer/features/auth/presentation/pages/pick_location_page.dart';
import 'package:eventy_customer/features/events/data/models/create_event_model.dart';
import 'package:eventy_customer/features/events/presentation/blocs/create_event/create_event_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/create_event/create_event_state.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_builder/event_builder_cubit.dart';
import 'package:eventy_customer/features/events/presentation/pages/inquiry_sent_page.dart';
import 'package:eventy_customer/features/events/presentation/widgets/event_services_summary.dart';
import 'package:eventy_customer/features/events/presentation/widgets/event_step_indicator.dart';
import 'package:eventy_customer/features/events/presentation/widgets/event_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

/// طبقة خارجية: مسؤوليتها الوحيدة توفير الـ Providers.
/// هذا يضمن أن أي context تحتها فعليًا "تحت" الـ Provider، لا فوقه.
class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<EventCubit>()),
        BlocProvider(create: (_) => sl<EventBuilderCubit>()),
      ],
      child: const _CreateEventView(),
    );
  }
}

class _CreateEventView extends StatefulWidget {
  const _CreateEventView();

  @override
  State<_CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<_CreateEventView> {
  final _pageController = PageController();
  int _step = 1;
  double? _latitude;
  double? _longitude;
  static const _totalSteps = 4;
  static const _stepNames = [
    "Basic Info",
    "Location & Time",
    "Description",
    "Select Services",
  ];

  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  String? _eventType;
  DateTime? _eventDate;
  int _guests = 50;

  String? _locationName;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  void _showError(String message) =>
      showAppSnackBar(context, message: message, type: SnackBarType.warning);

  bool _validateStep(int step) {
    switch (step) {
      case 1:
        if (_nameController.text.trim().isEmpty)
          return _fail("Please enter an event title");
        if (_eventType == null) return _fail("Please select an event type");
        if (_eventDate == null) return _fail("Please select the event date");
        return true;
      case 2:
        if (_locationName == null || _locationName!.trim().isEmpty)
          return _fail("Please choose the event location");
        if (_startTime == null || _endTime == null)
          return _fail("Please select start and end time");
        return true;
      case 3:
        return true;
      case 4:
        if (context.read<EventBuilderCubit>().state.isEmpty)
          return _fail("Please add at least one service");
        return true;
      default:
        return true;
    }
  }

  bool _fail(String msg) {
    _showError(msg);
    return false;
  }

  void _next() {
    if (!_validateStep(_step)) return;

    if (_step < _totalSteps) {
      setState(() => _step++);
      _pageController.animateToPage(
        _step - 1,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step == 1) {
      Navigator.pop(context);
      return;
    }
    setState(() => _step--);
    _pageController.animateToPage(
      _step - 1,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PickLocationPage(
          initialLocation: (_latitude != null && _longitude != null)
              ? LatLng(_latitude!, _longitude!)
              : null,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _locationName = result['locationName'];
        _latitude = result['latitude'];
        _longitude = result['longitude'];
      });
    }
  }

  void _submit() {
    final builderState = context.read<EventBuilderCubit>().state;

    final services = builderState.values.map((selectedService) {
      /// ⚠️ الخدمات بدون Sub-Services (Hall/Sound) تُرسل بـ items فارغة
      /// (بانتظار تأكيد الباك اند لشكل الطلب الرسمي بهذه الحالة)
      final items = selectedService.subServices.values.map((sub) {
        return CreateBookingItem(
          subServiceId: sub.id,
          quantity: sub.quantity,
          customerNotes: "",
        );
      }).toList();

      return CreateBookingService(
        serviceId: selectedService.serviceId,
        items: items,
      );
    }).toList();

    final request = CreateEventRequest(
      name: _nameController.text.trim(),
      eventType: _eventType!,
      eventDate: DateTime.utc(
        _eventDate!.year,
        _eventDate!.month,
        _eventDate!.day,
      ),
      eventStartTime: _formatTime(_startTime!),
      eventEndTime: _formatTime(_endTime!),
      eventLocation: _locationName!,
      numberOfGuests: _guests,
      customerNotes: _notesController.text.trim(),
      services: services,
    );

    context.read<EventCubit>().createEvent(request);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<EventCubit, EventState>(
      // في BlocListener<EventCubit, EventState>:
      listener: (context, state) {
        if (state is EventSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => InquirySentPage(response: state.response),
            ),
          );
        }
        if (state is EventError) {
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _back,
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: theme.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Create Your Event ✨",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: EventStepIndicator(
                  currentStep: _step,
                  totalSteps: _totalSteps,
                  stepNames: _stepNames,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1(theme),
                    _buildStep2(theme),
                    _buildStep3(theme),
                    // const SingleChildScrollView(
                    //   padding: EdgeInsets.all(20),
                    //   child: EventServicesSummary(),
                    // ),
                    _buildStep4Widget(theme),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                child: BlocBuilder<EventCubit, EventState>(
                  builder: (context, state) {
                    // وبقسم الزر الأخير:
                    final isLoading = state is EventLoading;
                    return PrimaryButton(
                      title: _step == _totalSteps
                          ? (isLoading ? "Sending..." : "Send Inquiry")
                          : "Next →",
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _next,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryTextField(
            label: "Event Title",
            icon: Icons.title_rounded,
            controller: _nameController,
          ),
          const SizedBox(height: 20),
          Text(
            "Event Type",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          EventTypeSelector(
            selected: _eventType,
            onSelect: (v) => setState(() => _eventType = v),
          ),
          const SizedBox(height: 20),
          _PickerField(
            label: "Date",
            icon: Icons.calendar_today_rounded,
            value: _eventDate == null
                ? "Select date"
                : _formatDate(_eventDate!),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 730)),
              );
              if (picked != null) setState(() => _eventDate = picked);
            },
          ),
          const SizedBox(height: 20),
          Text(
            "Number of Guests",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          PrimaryQuantityStepper(
            value: _guests,
            min: 1,
            max: 5000,
            step: 5,
            suffixLabel: "guests",
            onChanged: (v) => setState(() => _guests = v),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Event Location",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _PickerField(
            label: "Location",
            icon: Icons.location_on_rounded,
            value: _locationName ?? "Tap to choose location",
            onTap: _pickLocation,
          ),
          const SizedBox(height: 24),
          Text(
            "Event Time",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PickerField(
                  label: "Start Time",
                  icon: Icons.access_time_rounded,
                  value: _startTime?.format(context) ?? "Select",
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 18, minute: 0),
                    );
                    if (picked != null) setState(() => _startTime = picked);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerField(
                  label: "End Time",
                  icon: Icons.access_time_filled_rounded,
                  value: _endTime?.format(context) ?? "Select",
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 23, minute: 0),
                    );
                    if (picked != null) setState(() => _endTime = picked);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryTextField(
            label: "Notes for providers (optional)",
            icon: Icons.notes_rounded,
            controller: _notesController,
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Summary",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                _summaryRow(theme, "Title", _nameController.text),
                _summaryRow(theme, "Type", _eventType ?? "-"),
                _summaryRow(
                  theme,
                  "Date",
                  _eventDate == null ? "-" : _formatDate(_eventDate!),
                ),
                _summaryRow(
                  theme,
                  "Time",
                  (_startTime == null || _endTime == null)
                      ? "-"
                      : "${_startTime!.format(context)} - ${_endTime!.format(context)}",
                ),
                _summaryRow(theme, "Location", _locationName ?? "-"),
                _summaryRow(theme, "Guests", "$_guests"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4Widget(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: EventServicesSummary(eventDate: _eventDate), // ⚠️ جديد
    );
  }

  Widget _summaryRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(.6),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const _PickerField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: theme.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(.5),
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
