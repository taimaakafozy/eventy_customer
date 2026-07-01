import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/features/services/presentation/blocs/available_services/available_services_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_types/service_types_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_types/service_types_state.dart';
import 'package:eventy_customer/features/services/presentation/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_card.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  @override
  void initState() {
    super.initState();

    context.read<ServiceTypesCubit>().getServiceTypes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceTypesCubit, ServiceTypesState>(
      builder: (context, state) {
        if (state is ServiceTypesLoading) {
          return const SizedBox(
            height: 112,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ServiceTypesError) {
          return SizedBox(
            height: 112,
            child: Center(child: Text(state.message)),
          );
        }

        if (state is ServiceTypesSuccess) {
          return SizedBox(
            height: 112,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: state.serviceTypes.length,
              itemBuilder: (_, index) {
                final category = state.serviceTypes[index];

                return CategoryCard(
                  serviceType: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) =>
                                  sl<ServiceTypesCubit>()..getServiceTypes(),
                            ),

                            BlocProvider(
                              create: (_) =>
                                  sl<AvailableServicesCubit>()
                                    ..loadServices(category.name),
                            ),
                          ],

                          child: ServicesPage(selectedType: category),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
