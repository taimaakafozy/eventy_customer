import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_state.dart';
import 'package:eventy_customer/features/services/presentation/widgets/service_details/availability_section.dart';
import 'package:eventy_customer/features/services/presentation/widgets/services/service_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String serviceId;

  const ServiceDetailsPage({
    super.key,
    required this.serviceId,
  });

  @override
  State<ServiceDetailsPage> createState() =>
      _ServiceDetailsPageState();
}

class _ServiceDetailsPageState
    extends State<ServiceDetailsPage> {
  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ServiceDetailsCubit>().loadService(
      widget.serviceId,
    );
  });
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: BlocBuilder<
          ServiceDetailsCubit,
          ServiceDetailsState>(
        builder: (context, state) {
          if (state is ServiceDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ServiceDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is! ServiceDetailsLoaded) {
            return const SizedBox();
          }

          final ServiceDetailsModel service =
              state.service;

          return RefreshIndicator(
            onRefresh: () async {
    context.read<ServiceDetailsCubit>().refresh();
  },
            child: CustomScrollView(
              physics:
                  const BouncingScrollPhysics(),
              slivers: [
            
                /// ===========================
                /// HEADER IMAGE
                /// ===========================
            
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  elevation: 0,
            
                  backgroundColor:
                      theme.scaffoldBackgroundColor,
            
                  flexibleSpace:
                      FlexibleSpaceBar(
                   background: Hero(
              tag: service.id,
              child: service.hasImages
                  ? Image.network(
            service.mainImage!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return ServicePlaceholder(
                type: ServiceTypeHelper.displayName(
              service.serviceType.name,
            )
              );
            },
                    )
                  : ServicePlaceholder(
            type: ServiceTypeHelper.displayName(
              service.serviceType.name,
            )
                    ),
            ),
                  ),
                ),
            
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      22,
                      20,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
            
                        /// Provider Name
            
                        Text(
                          service.provider.businessName,
                          style: theme
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),
            
                        const SizedBox(height: 8),
            
                        Text(
                          ServiceTypeHelper.displayName(
              service.serviceType.name,
            ),
                          style: theme
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    theme.colorScheme.onSurface.withOpacity(.65)
                              ),
                        ),
            
                        const SizedBox(height: 18),
            
                        Row(
                          children: [
            
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: AppColors
                                    .primary
                                    .withOpacity(
                                        .10),
                                borderRadius:
                                    BorderRadius.circular(
                                        30),
                              ),
                              child: Row(
                                children: [
            
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
            
                                  const SizedBox(
                                      width: 6),
            
                                  Text(
                                    service
                                        .formattedRating,
                                    style: theme
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
            
                            const SizedBox(width: 12),
            
                            Text(
                              "${service.totalReviews} Reviews",
                              style: theme
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:theme.colorScheme.onSurface.withOpacity(.65)
                                  ),
                            ),
                          ],
                        ),
            
                        if (service.hasLocation) ...[
            
                          const SizedBox(height: 18),
            
                          Row(
                            children: [
            
                              const Icon(
                                Icons.location_on,
                                color:
                                    AppColors.primary,
                              ),
            
                              const SizedBox(
                                  width: 8),
            
                              Expanded(
                                child: Text(
                                  service.locationName!,
                                  style: theme
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
            
                        if (service.hasPrice) ...[
            
                          const SizedBox(height: 18),
            
                          Container(
                            padding:
                                const EdgeInsets.all(
                                    16),
            
                            decoration:
                                BoxDecoration(
                              color: AppColors
                                  .primary
                                  .withOpacity(.08),
            
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
            
                            child: Row(
                              children: [
            
                                const Icon(
                                  Icons.sell,
                                  color:
                                      AppColors.primary,
                                ),
            
                                const SizedBox(
                                    width: 10),
            
                                Text(
                                 "\$${service.price!.toStringAsFixed(2)}",
                                  style: theme
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        color:
                                            AppColors
                                                .primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
            
                        const SizedBox(height: 30),
                                              /// ==========================
                        /// Description
                        /// ==========================
            
                        if (service.description != null &&
                            service.description!.trim().isNotEmpty) ...[
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
                              service.description!,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                              ),
                            ),
                          ),
            
                          const SizedBox(height: 28),
                        ],
            
                        /// ==========================
                        /// Availability
                        /// ==========================
            
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
            
                          const SizedBox(height: 30),
                        ],
            
                        /// ==========================
                        /// Sub Services
                        /// ==========================
            
                        if (service.subServices.isNotEmpty) ...[
                          Text(
                            "Available Services",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
            
                          const SizedBox(height: 16),
            
                          SubServicesSection(
                            subServices: service.subServices,
                          ),
            
                          const SizedBox(height: 34),
                        ],
            
                        /// ==========================
                        /// Provider
                        /// ==========================
            
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
            
                              CircleAvatar(
                                radius: 28,
                                backgroundColor:
                                    AppColors.primary.withOpacity(.12),
            
                                child: service.provider.user.profileImage ==
                                        null
                                    ? const Icon(
                                        Icons.business,
                                        color: AppColors.primary,
                                      )
                                    : ClipOval(
              child: Image.network(
                service.provider.user.profileImage!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.business,
                    color: AppColors.primary,
                  );
                },
              ),
            )
                              ),
            
                              const SizedBox(width: 16),
            
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
            
                                    Text(
                                      service.provider.businessName,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
            
                                    const SizedBox(height: 4),
            
                                    Text(
                                      service.provider.user.fullName,
                                      style:
                                          theme.textTheme.bodyMedium,
                                    ),
            
                                    const SizedBox(height: 10),
            
                                    if (service.provider.description != null &&
                                        service.provider.description
                                            .trim()
                                            .isNotEmpty)
                                      Text(
                                        service.provider.description,
                                        style: theme
                                            .textTheme.bodyMedium
                                            ?.copyWith(
                                          height: 1.5,
                                          color: theme.colorScheme.onSurface.withOpacity(.70),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
            
                        const SizedBox(height: 90),
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
          BlocBuilder<ServiceDetailsCubit,
              ServiceDetailsState>(
        builder: (context, state) {

          if (state is! ServiceDetailsLoaded) {
            return const SizedBox();
          }

          return SafeArea(
            minimum: const EdgeInsets.all(18),
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {

                  /// Booking Page
                },

                child: const Text(
                  "Book Now",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}