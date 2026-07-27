import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/theme/theme_cubit.dart';
import 'package:eventy_customer/core/widgets/app_confirmation_dialog.dart';
import 'package:eventy_customer/core/widgets/primary_tab_tile.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/app_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/pages/change_password_page.dart';
import 'package:eventy_customer/features/complaints/presentation/pages/complaints_page.dart';
import 'package:eventy_customer/features/events/presentation/pages/my_events_page.dart';
import 'package:eventy_customer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:eventy_customer/features/user_profile/presentation/blocs/user_profile_cubit.dart';
import 'package:eventy_customer/features/user_profile/presentation/blocs/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserProfileCubit>()..loadProfile(),
      child: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              const _DrawerHeader(),
              const SizedBox(height: 6),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  children: [
                    _SectionLabel(title: "MENU"),
                    PrimaryTabTile(
                      title: "My Events",
                      icon: Icons.event_note_rounded,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyEventsPage(),
                          ),
                        );
                      },
                    ),
                    PrimaryTabTile(
                      title: "Favorites",
                      icon: Icons.favorite_border_rounded,
                      onTap: () {
                        Navigator.pop(context);
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoritesPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 24),
                    _SectionLabel(title: "ACCOUNT"),
                    PrimaryTabTile(
                      title: "Edit Profile",
                      icon: Icons.person_outline_rounded,
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: navigate to edit profile page
                      },
                    ),
                    PrimaryTabTile(
                      title: "Change Password",
                      icon: Icons.lock_outline_rounded,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 24),
                    _SectionLabel(title: "SETTINGS"),
                    _ThemeTile(),
                    const Divider(height: 24),
                    _SectionLabel(title: "SUPPORT"),
                    // PrimaryTabTile(
                    //   title: "Help & Support",
                    //   icon: Icons.support_agent_rounded,
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     // TODO: navigate to support page
                    //   },
                    // ),
                    PrimaryTabTile(
                      title: "My Complaints",
                      icon: Icons.report_problem_outlined,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ComplaintsPage(),
                          ),
                        );
                      },
                    ),
                    PrimaryTabTile(
                      title: "About Eventy",
                      icon: Icons.info_outline_rounded,
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: navigate to about page
                      },
                    ),
                    PrimaryTabTile(
                      title: "Terms & Privacy",
                      icon: Icons.description_outlined,
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: navigate to terms page
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: PrimaryTabTile(
                  title: "Logout",
                  icon: Icons.logout_rounded,
                  showArrow: false,
                  onTap: () => _confirmLogout(context),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Eventy © 2026 · v1.0.0",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(.4),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final appCubit = context.read<AppCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AppConfirmationDialog(
        title: "Logout",
        message: "Are you sure you want to log out of your account?",
        confirmText: "Logout",
        onConfirm: () {
          Navigator.pop(context); // إغلاق الدراور
          appCubit.logout();
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
      child: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: .8,
          color: theme.colorScheme.onSurface.withOpacity(.4),
        ),
      ),
    );
  }
}

/// كارد وضع العرض — يدعم System/Light/Dark عبر ThemeCubit الموجود أصلاً
class _ThemeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return PrimaryTabTile(
          title: "Display Mode",
          icon: (mode == ThemeMode.dark)
              ? Icons.dark_mode_rounded
              : Icons.light_mode_rounded,
          showArrow: false,
          trailing: DropdownButton<ThemeMode>(
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
            value: mode,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(12),
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
              DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
              DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<ThemeCubit>().changeTheme(value);
              }
            },
          ),
        );
      },
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gold, theme.colorScheme.secondary],
        ),
      ),
      child: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading || state is UserProfileInitial) {
            return const _HeaderSkeleton();
          }

          if (state is UserProfileError) {
            return Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(.2),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    "Welcome",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }

          final profile = (state as UserProfileLoaded).profile;

          return Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(.2),
                backgroundImage: profile.profileImage != null
                    ? NetworkImage(profile.profileImage!)
                    : null,
                child: profile.profileImage == null
                    ? Text(
                        profile.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      profile.phoneNumber,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 30, backgroundColor: Colors.white.withOpacity(.2)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 14,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.3),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
