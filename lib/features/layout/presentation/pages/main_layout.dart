import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bottom_navigation_cubit.dart';




class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  static const List<Widget> _pages = [
    // HomePage(),
    // DashboardPage() ,
    // SettingsPage(),


  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationCubit(),
      child: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            // backgroundColor: AppColors.dark,
            // body: _pages[currentIndex],
            body: IndexedStack(
              index: currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                final colors = theme.colorScheme;
                final icons = [Icons.home, Icons.dashboard_outlined,Icons.settings];
                final labels = ['الرئيسية','لوحة التحكم', 'الإعدادات'];
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
                          onTap: () =>
                              context.read<BottomNavigationCubit>().changeTab(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
