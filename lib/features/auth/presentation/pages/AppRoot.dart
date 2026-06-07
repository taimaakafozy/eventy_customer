// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/di/service_locator.dart';
// import '../../../layout/presentation/pages/main_layout.dart';
// import '../blocs/app_cubit.dart';
// import '../blocs/login_cubit.dart';
// import 'login_page.dart';

// class AppRoot extends StatelessWidget {
//   const AppRoot({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AppCubit, AppState>(
//       builder: (context, state) {
//         if (state is AppInitial) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (state is AppAuthenticated) {
//           return const MainLayout();
//         }

//         /// ❌ مهم: لما يصير logout لازم يرجع هون تلقائياً
//         return BlocProvider(
//           create: 
//            (_) => sl<LoginCubit>(),
//           child: const LoginPage(),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
import '../../../../core/di/service_locator.dart';
import '../../../layout/presentation/pages/main_layout.dart';
import '../blocs/app_cubit.dart';
import '../blocs/login_cubit.dart';
import 'login_page.dart';
import 'splash_page.dart';
 
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
 
  @override
  State<AppRoot> createState() => _AppRootState();
}
 
class _AppRootState extends State<AppRoot> {
  bool _showSplash = true;
 
  @override
  void initState() {
    super.initState();
    // Hold splash for 2.6 seconds then let auth state decide
    Future.delayed(const Duration(milliseconds: 5600), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashPage();
    }
 
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state is AppInitial) {
          // Still checking token — keep a lightweight loader
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
 
        if (state is AppAuthenticated) {
          return const MainLayout();
        }
 
        return BlocProvider(
          create: (_) => sl<LoginCubit>(),
          child: const LoginPage(),
        );
      },
    );
  }
}