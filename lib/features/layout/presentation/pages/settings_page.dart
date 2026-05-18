
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/primary_tab_tile.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/presentation/blocs/app_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override 
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isThemeExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: 
      // FutureBuilder<String?>(
      //   future: sl<SecureStorageService>().getUserRole(),
      //   builder: (context, snapshot) {

          // /// ⏳ تحميل
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          // }

           ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: 2,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, mode) {
                      return PrimaryTabTile(
                        title: 'وضع العرض',
                        icon: Icons.dark_mode,
                        isExpanded: isThemeExpanded,
                        onTap: () {
                          setState(() {
                            isThemeExpanded = !isThemeExpanded;
                          });
                        },
                        child: Column(
                          children: [
                            _themeOption(
                              context,
                              title: 'حسب النظام',
                              selected: mode == ThemeMode.system,
                              mode: ThemeMode.system,
                            ),
                            _themeOption(
                              context,
                              title: 'وضع نهاري',
                              selected: mode == ThemeMode.light,
                              mode: ThemeMode.light,
                            ),
                            _themeOption(
                              context,
                              title: 'وضع ليلي',
                              selected: mode == ThemeMode.dark,
                              mode: ThemeMode.dark,
                            ),
                          ],
                        ),
                      );
                    },
                  );

                case 1:
                  return BlocListener<AppCubit, AppState>(
                    listener: (context, state) {},
                    child: PrimaryTabTile(
                      title: 'تسجيل الخروج',
                      icon: Icons.logout,
                      showArrow: false,
                      onTap: () {
                        context.read<AppCubit>().logout();
                      },
                    ),
                  );

                default:
                  return const SizedBox();
              }
            },
          )
      //   },
      // ),
    );
  }


  Widget _themeOption(
      BuildContext context, {
        required String title,
        required bool selected,
        required ThemeMode mode,
      }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          context.read<ThemeCubit>().changeTheme(mode);
        },
        child: Container(
          padding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected
                ? theme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              if (selected)
                Icon(Icons.check_circle,
                    color: theme.primaryColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}