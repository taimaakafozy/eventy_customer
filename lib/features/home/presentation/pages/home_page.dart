import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/widgets/app_search_field.dart';
import 'package:eventy_customer/features/events/presentation/pages/create_event_page.dart';
import 'package:eventy_customer/features/home/presentation/widgets/Create_Event_Card.dart';
import 'package:eventy_customer/features/home/presentation/widgets/categories/categories_section.dart';
import 'package:eventy_customer/features/home/presentation/widgets/hero_banner/hero_banner.dart';
import 'package:eventy_customer/features/home/presentation/widgets/home_header.dart';
import 'package:eventy_customer/features/home/presentation/widgets/packages/recommended_packages_section.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_types/service_types_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const HomeHeader(),
              const SizedBox(height: 10),
              const AppSearchField(hintText: "Search events..."),
              const SizedBox(height: 15),
              const HeroBanner(),
              const SizedBox(height: 18),

              /// Create Event CTA
              CreateEventCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateEventPage()),
                  );
                },
              ),

              const SizedBox(height: 22),

              BlocProvider(
                create: (_) => sl<ServiceTypesCubit>(),
                child: const CategoriesSection(),
              ),

              const SizedBox(height: 32),

              const RecommendedPackagesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

