import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/date_format_helper.dart';
import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_builder/event_builder_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_builder/event_builder_state.dart';
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

  /// وضع الاختيار — يُستخدم فقط أثناء إنشاء/تعديل مناسبة، ويتطلب EventBuilderCubit بالـ context
  final bool selectable;

  /// بيانات المناسبة — تُستخدم لفلترة التوفر ومطابقة الوقت تلقائيًا
  final DateTime? eventDate;
  final String? eventStartTime;
  final String? eventEndTime;
  final int? eventGuests;

  const ServiceDetailsPage({
    super.key,
    required this.serviceId,
    this.selectable = false,
    this.eventDate,
    this.eventStartTime,
    this.eventEndTime,
    this.eventGuests,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceDetailsCubit>().loadService(
            widget.serviceId,
            date: widget.eventDate != null ? DateFormatHelper.toIsoDateOnly(widget.eventDate!) : null,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<ServiceDetailsCubit, ServiceDetailsState>(
        builder: (context, state) {
          if (state is ServiceDetailsLoading || state is ServiceDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ServiceDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 60, color: theme.disabledColor),
                    const SizedBox(height: 14),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () => context.read<ServiceDetailsCubit>().loadService(
                            widget.serviceId,
                            date: widget.eventDate != null
                                ? DateFormatHelper.toIsoDateOnly(widget.eventDate!)
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

          /// ⚠️ مطابقة الوقت تُحسب فقط أثناء إنشاء مناسبة (selectable + eventDate)
          final hasEventContext = widget.selectable && widget.eventDate != null;

          ServiceTimeMatchResult? timeMatch;
          if (hasEventContext && widget.eventStartTime != null && widget.eventEndTime != null) {
            timeMatch = ServiceTimeMatcher.match(
              availability: service.availability,
              eventStartTime: widget.eventStartTime!,
              eventEndTime: widget.eventEndTime!,
            );
          }

          final bool dayOnlyAvailable = service.isAvailableForFilteredDate;

          final bool guestsOk = !(service.maxCapacity != null &&
              widget.eventGuests != null &&
              widget.eventGuests! > service.maxCapacity!);

          final bool timeOk = hasEventContext ? (timeMatch?.fits ?? dayOnlyAvailable) : true;
          final bool canBook = timeOk && guestsOk;

          return RefreshIndicator(
            onRefresh: () async => context.read<ServiceDetailsCubit>().refresh(),
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
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 17),
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
                            Expanded(
                              child: Text(
                                service.provider.businessName,
                                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (service.isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Active",
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: AppColors.success, fontWeight: FontWeight.w700),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              ServiceTypeHelper.icon(service.serviceType.name),
                              size: 16,
                              color: theme.colorScheme.onSurface.withOpacity(.55),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              ServiceTypeHelper.displayName(service.serviceType.name),
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.65)),
                            ),
                            if (service.isPackaged) ...[
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withOpacity(.14),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Package",
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: AppColors.goldText, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                                  const SizedBox(width: 6),
                                  Text(
                                    service.totalReviews > 0
                                        ? "${service.formattedRating} (${service.totalReviews})"
                                        : "New",
                                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            if (service.hasLocation)
                              _InfoChip(icon: Icons.location_on_rounded, label: service.locationName!),
                            if (service.hasCapacity)
                              _InfoChip(icon: Icons.groups_rounded, label: service.capacityLabel),
                          ],
                        ),
                        if (service.hasPrice) ...[
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [theme.primaryColor, AppColors.secondary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.sell_rounded, color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  "\$${service.price!.toStringAsFixed(2)}",
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 6),
                                const Text("starting price", style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                        if (service.eventTypes.isNotEmpty) ...[
                          const SizedBox(height: 26),
                          Text("Suitable For",
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          EventTypesSection(eventTypes: service.eventTypes),
                        ],
                        const SizedBox(height: 28),
                        if (service.description.trim().isNotEmpty) ...[
                          Text("Description",
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.04), blurRadius: 16, offset: const Offset(0, 6)),
                              ],
                            ),
                            child: Text(service.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
                          ),
                          const SizedBox(height: 28),
                        ],

                        /// Availability
                        if (service.availability.isNotEmpty) ...[
                          Text("Availability",
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          AvailabilitySection(availability: service.availability),
                          const SizedBox(height: 24),
                        ],

                        /// ⚠️ بانرات مطابقة الوقت والسعة — فقط أثناء إنشاء مناسبة
                        if (hasEventContext) ...[
                          if (timeMatch != null && !timeMatch.fits)
                            _WarningBanner(icon: Icons.event_busy_rounded, message: timeMatch.reason)
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

                        /// Package Services (Hall + Partners)
                        if (service.hasPackageServices) ...[
                          Text("Included Services",
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            "This package works exclusively with these partners",
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.55)),
                          ),
                          const SizedBox(height: 16),
                          PackageServicesSection(services: service.packageServices!),
                          const SizedBox(height: 30),
                        ],

                        /// خدمة بدون Sub-Services (Hall, Sound) — اختيار مباشر
                        if (widget.selectable && service.subServices.isEmpty && !service.hasPackageServices) ...[
                          Text("Book This Service",
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            "This service doesn't require choosing sub-items — add it directly",
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.55)),
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<EventBuilderCubit, Map<String, SelectedService>>(
                            builder: (context, selections) {
                              final isSelected = selections[service.id]?.wholeServicePrice != null;

                              return _WholeServiceCard(
                                isSelected: isSelected,
                                price: service.price,
                                enabled: canBook,
                                onTap: () => context.read<EventBuilderCubit>().toggleWholeService(
                                      serviceId: service.id,
                                      serviceName: service.provider.businessName,
                                      price: service.price ?? 0,
                                      timeSlotId: timeMatch?.timeSlotId,
                                    ),
                              );
                            },
                          ),
                          const SizedBox(height: 34),
                        ],

                        /// Sub Services — عرض أو اختيار
                        if (service.subServices.isNotEmpty) ...[
                          Text(
                            widget.selectable ? "Select Services" : "Available Services",
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.selectable
                                ? "Choose what you need and set the quantity"
                                : "You'll be able to select these when booking",
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.55)),
                          ),
                          const SizedBox(height: 16),
                          if (widget.selectable)
                            BlocBuilder<EventBuilderCubit, Map<String, SelectedService>>(
                              builder: (context, selections) {
                                final serviceSelections = selections[service.id]?.subServices ?? {};

                                return Column(
                                  children: service.subServices.map((s) {
                                    final selectedSub = serviceSelections[s.id];

                                    return SubServiceCard(
                                      subService: s,
                                      selectable: true,
                                      enabled: canBook,
                                      isSelected: selectedSub != null,
                                      quantity: selectedSub?.quantity ?? 1,
                                      onToggle: () => context.read<EventBuilderCubit>().toggleSubService(
                                            serviceId: service.id,
                                            serviceName: service.provider.businessName,
                                            subServiceId: s.id,
                                            subServiceName: s.name,
                                            pricePerUnit: s.pricePerUnit,
                                            unitType: s.unitType,
                                            timeSlotId: timeMatch?.timeSlotId,
                                          ),
                                      onQuantityChanged: (q) =>
                                          context.read<EventBuilderCubit>().setQuantity(service.id, s.id, q),
                                    );
                                  }).toList(),
                                );
                              },
                            )
                          else
                            ...service.subServices.map((s) => SubServiceCard(subService: s)),
                          const SizedBox(height: 34),
                        ],

                        /// Provider
                        Text("Provider", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 14, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primary.withOpacity(.12),
                                child: (service.provider.user.profileImage ?? service.serviceLogo) == null
                                    ? const Icon(Icons.business, color: AppColors.primary)
                                    : ClipOval(
                                        child: Image.network(
                                          service.provider.user.profileImage ?? service.serviceLogo!,
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.business, color: AppColors.primary),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(service.provider.businessName,
                                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(service.provider.user.fullName, style: theme.textTheme.bodyMedium),
                                    if (service.provider.description.trim().isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Text(
                                        service.provider.description,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          height: 1.5,
                                          color: theme.colorScheme.onSurface.withOpacity(.70),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
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
      bottomNavigationBar: BlocBuilder<ServiceDetailsCubit, ServiceDetailsState>(
        builder: (context, state) {
          if (state is! ServiceDetailsLoaded) return const SizedBox();

          if (!widget.selectable) {
            return SafeArea(
              minimum: const EdgeInsets.all(18),
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () => BookingChoiceSheet.show(context),
                  child: const Text("Book Now"),
                ),
              ),
            );
          }

          return BlocBuilder<EventBuilderCubit, Map<String, SelectedService>>(
            builder: (context, selections) {
              final current = selections[state.service.id];
              final count = current?.subServices.length ?? (current?.wholeServicePrice != null ? 1 : 0);

              return SafeArea(
                minimum: const EdgeInsets.all(18),
                child: SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(count > 0 ? "Done ($count selected)" : "Done"),
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
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
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
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _WholeServiceCard extends StatelessWidget {
  final bool isSelected;
  final double? price;
  final bool enabled;
  final VoidCallback onTap;

  const _WholeServiceCard({
    required this.isSelected,
    required this.price,
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
              color: isSelected ? theme.primaryColor.withOpacity(.08) : theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? theme.primaryColor : theme.dividerColor.withOpacity(.2),
                width: isSelected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(.35),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Book this service for your event",
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (price != null)
                  Text(
                    "\$${price!.toStringAsFixed(0)}",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: AppColors.gold, fontWeight: FontWeight.w800),
                  ),
              ],
            ),
          ),
        ),
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