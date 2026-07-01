import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/features/home/presentation/pages/home_page.dart';
import 'package:eventy_customer/features/layout/presentation/pages/settings_page.dart';
import 'package:eventy_customer/features/services/presentation/blocs/available_services/available_services_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_types/service_types_cubit.dart';
import 'package:eventy_customer/features/services/presentation/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bottom_navigation_cubit.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  static final   List<Widget> _pages = [
    HomePage(),
    BlocProvider(
    create: (_) => sl<AvailableServicesCubit>()
      ..loadServices(null),
    child: const ServicesPage(),
  ),

    // Scaffold(body: Center(child: Text("Favorites"))),
    Scaffold(body: Center(child: Text("Bookings"))),
    Scaffold(body: Center(child: Text("Profile"))),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
   return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (_) => BottomNavigationCubit(),
    ),

    BlocProvider(
      create: (_) => sl<ServiceTypesCubit>()
        ..getServiceTypes(),
    ),
    
  ],
  child: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            // backgroundColor: AppColors.dark,
            // body: _pages[currentIndex],
            body: IndexedStack(index: currentIndex, children: _pages),
            bottomNavigationBar: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                final colors = theme.colorScheme;
                final icons = [
                  Icons.home,
                  Icons.search_outlined,
                  // Icons.favorite_border,
                  Icons.book_outlined,
                  Icons.person_outline,
                  // Icons.dashboard_outlined,
                  Icons.settings,
                ];
                final labels = [
                  "Home",
                  "Services",
                  // "Favorites",
                  "Bookings",
                  "Profile",
                  'الإعدادات',
                ];
                return Container(
                  decoration: BoxDecoration(
                    color: colors.surface, // 👈 يتغير حسب الثيم
                    boxShadow: [
                      BoxShadow(
                        color: colors.onSurface.withOpacity(0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: List.generate(icons.length, (index) {
                        final isSelected = index == currentIndex;

                        return InkWell(
                          onTap: () => context
                              .read<BottomNavigationCubit>()
                              .changeTab(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primary.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icons[index],
                                  size: isSelected ? 28 : 24,
                                  color: isSelected
                                      ? colors.primary
                                      : colors.onSurface.withOpacity(0.6),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    color: isSelected
                                        ? colors.primary
                                        : colors.onSurface.withOpacity(0.6),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  child: Text(labels[index]),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
