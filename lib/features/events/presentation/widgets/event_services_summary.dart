import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_builder/event_builder_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_builder/event_builder_state.dart';
import 'package:eventy_customer/features/services/presentation/blocs/available_services/available_services_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_types/service_types_cubit.dart';
import 'package:eventy_customer/features/services/presentation/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventServicesSummary extends StatelessWidget {
  final DateTime? eventDate;

  const EventServicesSummary({super.key, this.eventDate});

  void _browseServices(BuildContext context) {
    final eventBuilderCubit = context.read<EventBuilderCubit>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AvailableServicesCubit>()..loadServices(null)),
            BlocProvider(create: (_) => sl<ServiceTypesCubit>()..getServiceTypes()),
            BlocProvider.value(value: eventBuilderCubit),
          ],
          child: ServicesPage(selectionMode: true, eventDate: eventDate),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Add Services", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(
          "Browse the marketplace and add the services your event needs",
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.55)),
        ),
        const SizedBox(height: 16),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _browseServices(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.primaryColor.withOpacity(.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: theme.primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text("Browse Services",
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w700, color: theme.primaryColor)),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.primaryColor),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<EventBuilderCubit, Map<String, SelectedService>>(
          builder: (context, selections) {
            if (selections.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    "No services added yet",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.5)),
                  ),
                ),
              );
            }

            final total = context.read<EventBuilderCubit>().totalPrice;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...selections.values.map((service) {
                  final isWhole = service.wholeServicePrice != null;
                  final serviceTotal = isWhole
                      ? service.wholeServicePrice!
                      : service.subServices.values
                          .fold(0.0, (sum, s) => sum + s.pricePerUnit * s.quantity);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.dividerColor.withOpacity(.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(service.serviceName,
                                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                            ),
                            Text("\$${serviceTotal.toStringAsFixed(0)}",
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.gold, fontWeight: FontWeight.w800)),
                            IconButton(
                              icon: Icon(Icons.close_rounded,
                                  size: 18, color: theme.colorScheme.onSurface.withOpacity(.5)),
                              onPressed: () =>
                                  context.read<EventBuilderCubit>().removeService(service.serviceId),
                            ),
                          ],
                        ),
                        if (isWhole)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text("Full service booking",
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.55))),
                          )
                        else ...[
                          Divider(height: 16, color: theme.dividerColor.withOpacity(.3)),
                          ...service.subServices.values.map((sub) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("${sub.name} × ${sub.quantity}",
                                        style: theme.textTheme.bodySmall),
                                  ),
                                  Text("\$${(sub.pricePerUnit * sub.quantity).toStringAsFixed(0)}",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Estimated Total",
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text("\$${total.toStringAsFixed(0)}",
                          style: theme.textTheme.titleLarge
                              ?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}