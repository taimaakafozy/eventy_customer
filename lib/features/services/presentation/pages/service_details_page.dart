import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/date_format_helper.dart';
import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:eventy_customer/core/widgets/price_tag.dart';
import 'package:eventy_customer/core/widgets/snackbar_helper.dart';
import 'package:eventy_customer/features/events/data/models/add_service_booking_model.dart';
import 'package:eventy_customer/features/events/data/models/get_all_events_model.dart';
import 'package:eventy_customer/features/events/presentation/blocs/add_service_to_event/add_service_to_event_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/add_service_to_event/add_service_to_event_state.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_builder/event_builder_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_builder/event_builder_state.dart';
import 'package:eventy_customer/features/events/presentation/pages/create_event_page.dart';
import 'package:eventy_customer/features/events/presentation/pages/event_bookings_details_page.dart';
import 'package:eventy_customer/features/events/presentation/pages/select_event_for_booking_page.dart';
import 'package:eventy_customer/features/reviews/presentation/widgets/reviews_section.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:eventy_customer/features/services/domain/validators/service_time_matcher.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_state.dart';
import 'package:eventy_customer/features/services/presentation/widgets/service_details/availability_section.dart';
import 'package:eventy_customer/features/services/presentation/widgets/service_details/booking_choice_sheet.dart';
import 'package:eventy_customer/features/services/presentation/widgets/service_details/event_types_section.dart';
import 'package:eventy_customer/features/services/presentation/widgets/service_details/media_gallery.dart';
import 'package:eventy_customer/features/services/presentation/widgets/service_details/package_services_section.dart';
import 'package:eventy_customer/features/services/presentation/widgets/service_details/sub_service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String serviceId;

  /// true عند أي رحلة حجز (إنشاء مناسبة جديدة أو إضافة لمناسبة موجودة)
  final bool selectable;

  /// بيانات المناسبة (تُستخدم لفحص التوفر بالتاريخ/الوقت في كلا وضعي الحجز)
  final DateTime? eventDate;
  final String? eventStartTime;
  final String? eventEndTime;
  final int? eventGuests;

  /// ⚠️ جديد: عند تمرير قيمة هنا، الصفحة بوضع "إضافة لمناسبة موجودة"
  /// (مو إنشاء مناسبة جديدة) — هذا هو المصدر الوحيد للحقيقة لتحديد الوضع
  final String? addToEventId;
  final String? addToEventName;

  const ServiceDetailsPage({
    super.key,
    required this.serviceId,
    this.selectable = false,
    this.eventDate,
    this.eventStartTime,
    this.eventEndTime,
    this.eventGuests,
    this.addToEventId,
    this.addToEventName,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  /// اختيارات محلية لوضع "إضافة لمناسبة موجودة" فقط (خدمة واحدة، بدون EventBuilderCubit)
  final Map<String, int> _localSubServices = {};
  bool _localWholeServiceSelected = false;

  bool get _isAddToEventFlow => widget.addToEventId != null;
  bool get _isCreationFlow => widget.selectable && !_isAddToEventFlow;
  bool get _selectableUi => _isCreationFlow || _isAddToEventFlow;
  bool get _hasEventContext => widget.eventDate != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceDetailsCubit>().loadService(
        widget.serviceId,
        date: widget.eventDate != null
            ? DateFormatHelper.toIsoDateOnly(widget.eventDate!)
            : null,
      );
    });
  }

  ServiceTimeMatchResult? _timeMatchFor(ServiceDetailsModel service) {
    if (!_hasEventContext ||
        widget.eventStartTime == null ||
        widget.eventEndTime == null)
      return null;
    return ServiceTimeMatcher.match(
      availability: service.availability,
      eventStartTime: widget.eventStartTime!,
      eventEndTime: widget.eventEndTime!,
    );
  }

  bool _guestsOk(ServiceDetailsModel service) {
    return !(service.maxCapacity != null &&
        widget.eventGuests != null &&
        widget.eventGuests! > service.maxCapacity!);
  }

  void _submitAddToEvent(
    BuildContext context,
    ServiceDetailsModel service,
    ServiceTimeMatchResult? timeMatch,
  ) {
    final items = <AddServiceBookingItem>[];

    for (final entry in _localSubServices.entries) {
      items.add(
        AddServiceBookingItem(
          subServiceId: entry.key,
          quantity: entry.value,
          customerNotes: "",
        ),
      );
    }

    final request = AddServiceBookingRequestModel(
      serviceId: service.id,
      timeSlotId: timeMatch?.timeSlotId,
      items: items,
    );

    context.read<AddServiceToEventCubit>().submit(
      widget.addToEventId!,
      request,
    );
  }

  void _onAddToEventSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Added to Event! 🎉"),
        content: const Text(
          "Your request has been sent to the provider. You'll be notified once they respond.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // إغلاق الـ Dialog
              Navigator.of(
                context,
              ).pop(true); // رجوع لصفحة تفاصيل المناسبة + طلب تحديث
            },
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("SERVICE DETAILS PAGE");
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<ServiceDetailsCubit, ServiceDetailsState>(
        builder: (context, state) {
          if (state is ServiceDetailsLoading ||
              state is ServiceDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ServiceDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 60,
                      color: theme.disabledColor,
                    ),
                    const SizedBox(height: 14),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<ServiceDetailsCubit>().loadService(
                            widget.serviceId,
                            date: widget.eventDate != null
                                ? DateFormatHelper.toIsoDateOnly(
                                    widget.eventDate!,
                                  )
                                : null,
                          ),
                      icon: const Icon(Icons.refresh),
                      label: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              ),
            );
          }

          final service = (state as ServiceDetailsLoaded).service;
          final timeMatch = _timeMatchFor(service);
          final dayOnlyAvailable = service.isAvailableForFilteredDate;
          final guestsOk = _guestsOk(service);
          final timeOk = _hasEventContext
              ? (timeMatch?.fits ?? dayOnlyAvailable)
              : true;
          final canBook = timeOk && guestsOk;

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ServiceDetailsCubit>().refresh(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  leading: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(.35),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 17,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: MediaGallery(
                      files: service.files,
                      serviceTypeName: service.serviceType.name,
                      heroTag: service.id,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (service.serviceLogo != null)
                              Container(
                                width: 56,
                                height: 56,
                                margin: const EdgeInsets.only(right: 12),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.scaffoldBackgroundColor,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.12),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  service.serviceLogo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: theme.primaryColor.withOpacity(.1),
                                    child: Icon(
                                      Icons.business,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          service.provider.businessName,
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      if (service.hasDiscount)
                                        DiscountBadge(
                                          percentOff:
                                              service.discount?.percentOff ?? 0,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        ServiceTypeHelper.icon(
                                          service.serviceType.name,
                                        ),
                                        size: 16,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(.55),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        ServiceTypeHelper.displayName(
                                          service.serviceType.name,
                                        ),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(.65),
                                            ),
                                      ),
                                      if (service.isPackaged) ...[
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 9,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.gold.withOpacity(
                                              .14,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            "Package",
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: AppColors.goldText,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        /// بانر "إضافة إلى: اسم المناسبة" — فقط بوضع الإضافة لمناسبة موجودة
                        if (_isAddToEventFlow) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.event_note_rounded,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Adding to: ${widget.addToEventName ?? 'your event'}",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    service.totalReviews > 0
                                        ? "${service.formattedRating} (${service.totalReviews})"
                                        : "New",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (service.hasLocation)
                              _InfoChip(
                                icon: Icons.location_on_rounded,
                                label: service.locationName!,
                              ),
                            if (service.hasCapacity)
                              _InfoChip(
                                icon: Icons.groups_rounded,
                                label: service.capacityLabel,
                              ),
                          ],
                        ),

                        if (service.finalPrice != null || service.hasPrice) ...[
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.primaryColor,
                                  AppColors.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.sell_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                if (service.hasDiscount) ...[
                                  Text(
                                    "\$${service.originalPrice!.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "\$${service.finalPrice!.toStringAsFixed(2)}",
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.25),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "-${service.discount?.percentOff.toStringAsFixed(0)}%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ] else
                                  Text(
                                    "\$${service.price!.toStringAsFixed(2)}",
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                const SizedBox(width: 6),
                                const Text(
                                  "starting price",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],

                        if (service.eventTypes.isNotEmpty) ...[
                          const SizedBox(height: 26),
                          Text(
                            "Suitable For",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          EventTypesSection(eventTypes: service.eventTypes),
                        ],

                        const SizedBox(height: 28),

                        if (service.description.trim().isNotEmpty) ...[
                          Text(
                            "Description",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Text(
                              service.description,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],

                        if (service.availability.isNotEmpty) ...[
                          Text(
                            "Availability",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AvailabilitySection(
                            availability: service.availability,
                          ),
                          const SizedBox(height: 24),
                        ],

                        if (_hasEventContext) ...[
                          if (timeMatch != null && !timeMatch.fits)
                            _WarningBanner(
                              icon: Icons.event_busy_rounded,
                              message: timeMatch.reason,
                            )
                          else if (timeMatch == null && !dayOnlyAvailable)
                            _WarningBanner(
                              icon: Icons.event_busy_rounded,
                              message:
                                  "This service is not available on ${DateFormatHelper.toIsoDateOnly(widget.eventDate!)}.",
                            )
                          else if (timeMatch != null && timeMatch.fits)
                            _SuccessBanner(message: timeMatch.reason),
                          if (!guestsOk)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: _WarningBanner(
                                icon: Icons.groups_rounded,
                                message:
                                    "Your guest count (${widget.eventGuests}) exceeds this service's maximum capacity (${service.maxCapacity}).",
                              ),
                            ),
                          const SizedBox(height: 24),
                        ],

                        if (service.hasPackageServices) ...[
                          Text(
                            "Included Services",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "This package works exclusively with these partners",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .55,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          PackageServicesSection(
                            services: service.packageServices!,
                          ),
                          const SizedBox(height: 30),
                        ],

                        /// خدمة بدون Sub-Services (Hall, Sound) — اختيار مباشر
                        if (_selectableUi &&
                            service.subServices.isEmpty &&
                            !service.hasPackageServices) ...[
                          Text(
                            "Book This Service",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "This service doesn't require choosing sub-items — add it directly",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .55,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_isCreationFlow)
                            BlocBuilder<
                              EventBuilderCubit,
                              Map<String, SelectedService>
                            >(
                              builder: (context, selections) {
                                final isSelected =
                                    selections[service.id]?.wholeServicePrice !=
                                    null;
                                return _WholeServiceCard(
                                  isSelected: isSelected,
                                  originalPrice:
                                      service.originalPrice ?? service.price,
                                  finalPrice:
                                      service.finalPrice ?? service.price,
                                  percentOff: service.discount?.percentOff,
                                  enabled: canBook,
                                  onTap: () => context
                                      .read<EventBuilderCubit>()
                                      .toggleWholeService(
                                        serviceId: service.id,
                                        serviceName:
                                            service.provider.businessName,
                                        price:
                                            service.finalPrice ??
                                            service.price ??
                                            0,
                                        originalPrice: service.hasDiscount
                                            ? (service.originalPrice ??
                                                  service.price)
                                            : null,
                                        percentOff:
                                            service.discount?.percentOff,
                                        timeSlotId: timeMatch?.timeSlotId,
                                      ),
                                );
                              },
                            )
                          else
                            _WholeServiceCard(
                              isSelected: _localWholeServiceSelected,
                              originalPrice:
                                  service.originalPrice ?? service.price,
                              finalPrice: service.finalPrice ?? service.price,
                              percentOff: service.discount?.percentOff,
                              enabled: canBook,
                              onTap: () => setState(
                                () => _localWholeServiceSelected =
                                    !_localWholeServiceSelected,
                              ),
                            ),
                          const SizedBox(height: 34),
                        ],

                        /// Sub Services — عرض أو اختيار
                        if (service.subServices.isNotEmpty) ...[
                          Text(
                            _selectableUi
                                ? "Select Services"
                                : "Available Services",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _selectableUi
                                ? "Choose what you need and set the quantity"
                                : "You'll be able to select these when booking",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .55,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_isCreationFlow)
                            BlocBuilder<
                              EventBuilderCubit,
                              Map<String, SelectedService>
                            >(
                              builder: (context, selections) {
                                final serviceSelections =
                                    selections[service.id]?.subServices ?? {};
                                return Column(
                                  children: service.subServices.map((s) {
                                    final selectedSub = serviceSelections[s.id];
                                    return SubServiceCard(
                                      subService: s,
                                      selectable: true,
                                      enabled: canBook,
                                      isSelected: selectedSub != null,
                                      quantity: selectedSub?.quantity ?? 1,
                                      onToggle: () => context
                                          .read<EventBuilderCubit>()
                                          .toggleSubService(
                                            serviceId: service.id,
                                            serviceName:
                                                service.provider.businessName,
                                            subServiceId: s.id,
                                            subServiceName: s.name,
                                            pricePerUnit:
                                                s.finalPrice ?? s.pricePerUnit,
                                            originalPricePerUnit: s.hasDiscount
                                                ? (s.originalPrice ??
                                                      s.pricePerUnit)
                                                : null,
                                            percentOff: s.discount?.percentOff,
                                            unitType: s.unitType,
                                            timeSlotId: timeMatch?.timeSlotId,
                                          ),
                                      onQuantityChanged: (q) => context
                                          .read<EventBuilderCubit>()
                                          .setQuantity(service.id, s.id, q),
                                    );
                                  }).toList(),
                                );
                              },
                            )
                          else if (_isAddToEventFlow)
                            Column(
                              children: service.subServices.map((s) {
                                final isSelected = _localSubServices
                                    .containsKey(s.id);
                                final qty = _localSubServices[s.id] ?? 1;
                                return SubServiceCard(
                                  subService: s,
                                  selectable: true,
                                  enabled: canBook,
                                  isSelected: isSelected,
                                  quantity: qty,
                                  onToggle: () => setState(() {
                                    if (isSelected) {
                                      _localSubServices.remove(s.id);
                                    } else {
                                      _localSubServices[s.id] = 1;
                                    }
                                  }),
                                  onQuantityChanged: (q) => setState(
                                    () => _localSubServices[s.id] = q,
                                  ),
                                );
                              }).toList(),
                            )
                          else
                            ...service.subServices.map(
                              (s) => SubServiceCard(subService: s),
                            ),
                          const SizedBox(height: 34),
                        ],

                        Text(
                          "Provider",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.04),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primary.withOpacity(
                                  .12,
                                ),
                                child:
                                    (service.provider.user.profileImage ??
                                            service.serviceLogo) ==
                                        null
                                    ? const Icon(
                                        Icons.business,
                                        color: AppColors.primary,
                                      )
                                    : ClipOval(
                                        child: Image.network(
                                          service.provider.user.profileImage ??
                                              service.serviceLogo!,
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.business,
                                                color: AppColors.primary,
                                              ),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.provider.businessName,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      service.provider.user.fullName,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    if (service.provider.description
                                        .trim()
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Text(
                                        service.provider.description,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              height: 1.5,
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(.70),
                                            ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 34),
                        ReviewsSection(
                          serviceId: service.id,
                          averageRating: service.rating,
                          totalReviews: service.totalReviews,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar:
          BlocBuilder<ServiceDetailsCubit, ServiceDetailsState>(
            builder: (context, state) {
              if (state is! ServiceDetailsLoaded) return const SizedBox();
              final service = state.service;

              if (_isAddToEventFlow) {
                final timeMatch = _timeMatchFor(service);

                return BlocConsumer<
                  AddServiceToEventCubit,
                  AddServiceToEventState
                >(
                  listener: (context, addState) {
                    if (addState is AddServiceToEventSuccess)
                      _onAddToEventSuccess(context);
                    if (addState is AddServiceToEventError) {
                      showAppSnackBar(
                        context,
                        message: addState.message,
                        type: SnackBarType.error,
                      );
                    }
                  },
                  builder: (context, addState) {
                    final isSubmitting = addState is AddServiceToEventLoading;
                    final hasSelection =
                        _localWholeServiceSelected ||
                        _localSubServices.isNotEmpty;

                    return SafeArea(
                      minimum: const EdgeInsets.all(18),
                      child: SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (isSubmitting || !hasSelection)
                              ? null
                              : () => _submitAddToEvent(
                                  context,
                                  service,
                                  timeMatch,
                                ),
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Add to Event"),
                        ),
                      ),
                    );
                  },
                );
              }

              if (!widget.selectable) {
                return SafeArea(
                  minimum: const EdgeInsets.all(18),
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () async {
                        final choice = await BookingChoiceSheet.show(context);

                        if (!context.mounted || choice == null) return;

                        if (choice == BookingChoice.create) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateEventPage(),
                            ),
                          );
                          return;
                        }

                        final selectedEvent = await Navigator.push<EventItem>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SelectEventForBookingPage(),
                          ),
                        );

                        if (!context.mounted || selectedEvent == null) return;

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventBookingsDetailsPage(
                              eventId: selectedEvent.id,
                              addServiceId: service.id,
                            ),
                          ),
                        );
                      },
                      child: const Text("Book Now"),
                    ),
                  ),
                );
              }

              return BlocBuilder<
                EventBuilderCubit,
                Map<String, SelectedService>
              >(
                builder: (context, selections) {
                  final current = selections[service.id];
                  final count =
                      current?.subServices.length ??
                      (current?.wholeServicePrice != null ? 1 : 0);

                  return SafeArea(
                    minimum: const EdgeInsets.all(18),
                    child: SizedBox(
                      height: 54,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          count > 0 ? "Done ($count selected)" : "Done",
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}

class _WholeServiceCard extends StatelessWidget {
  final bool isSelected;
  final double? originalPrice;
  final double? finalPrice;
  final double? percentOff;
  final bool enabled;
  final VoidCallback onTap;

  const _WholeServiceCard({
    required this.isSelected,
    this.originalPrice,
    this.finalPrice,
    this.percentOff,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.primaryColor.withOpacity(.08)
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? theme.primaryColor
                    : theme.dividerColor.withOpacity(.2),
                width: isSelected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected
                      ? theme.primaryColor
                      : theme.colorScheme.onSurface.withOpacity(.35),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Book this service for your event",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                PriceTag(
                  originalPrice: originalPrice,
                  finalPrice: finalPrice,
                  percentOff: percentOff,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  const _WarningBanner({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withOpacity(.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  final String message;
  const _SuccessBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.success),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "✓ $message",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.dividerColor.withOpacity(.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.primaryColor),
          const SizedBox(width: 5),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
