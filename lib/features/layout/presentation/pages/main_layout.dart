import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/features/events/presentation/blocs/get_All_Events/Get_All_Events_Cubit.dart';
import 'package:eventy_customer/features/events/presentation/pages/my_events_page.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorite_status/favorite_status_cubit.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorites_list/favorites_list_cubit.dart';
import 'package:eventy_customer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:eventy_customer/features/home/presentation/pages/home_page.dart';
import 'package:eventy_customer/features/services/presentation/blocs/available_services/available_services_cubit.dart';
import 'package:eventy_customer/features/services/presentation/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bottom_navigation_cubit.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  static final List<Widget> _pages = [
    HomePage(),
  const ServicesPage(),
    const FavoritesPage(),
    const MyEventsPage(),
  ];
void _onTabTapped(BuildContext context, int index) {

  final current = context.read<BottomNavigationCubit>().state;

    if(current == index){
        return;
    }
  context.read<BottomNavigationCubit>().changeTab(index);

  switch (index) {
    case 1:
      sl<AvailableServicesCubit>().refresh();
      // sl<ServiceTypesCubit>()..getServiceTypes();
      break;
    case 2:
      sl<FavoritesListCubit>().refresh();
      break;
    case 3:
      sl<GetAllEventsCubit>().refresh();
      break;
  }
}

@override
void initState() {
  super.initState();

  sl<FavoriteStatusCubit>().loadFavoriteIds();

  // sl<ServiceTypesCubit>().getServiceTypes(); 
}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationCubit(),
      child: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: IndexedStack(index: currentIndex, children: _pages),
            bottomNavigationBar: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                final colors = theme.colorScheme;
                final icons = [Icons.home, Icons.search_outlined, Icons.favorite_border, Icons.event_note_outlined];
                final labels = ["Home", "Services", "Favorites", "Events"];

                return Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    boxShadow: [BoxShadow(color: colors.onSurface.withOpacity(0.15), blurRadius: 8)],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(icons.length, (index) {
                        final isSelected = index == currentIndex;

                        return InkWell(
                          onTap: () => _onTabTapped(context, index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? colors.primary.withOpacity(0.15) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icons[index],
                                  size: isSelected ? 28 : 24,
                                  color: isSelected ? colors.primary : colors.onSurface.withOpacity(0.6),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    color: isSelected ? colors.primary : colors.onSurface.withOpacity(0.6),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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