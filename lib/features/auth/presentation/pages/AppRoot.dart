import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/login_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/request_reset_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/presentation/pages/main_layout.dart';
import '../blocs/app_cubit.dart';
import 'login_page.dart';
import 'splash_page.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    print("APP ROOT BUILD");
    return BlocBuilder<AppCubit, AppState>(
      bloc: context.read<AppCubit>(),
      builder: (context, state) {
        print("APP ROOT STATE: ${state.runtimeType}");

        print("APP ROOT CUBIT: ${identityHashCode(context.read<AppCubit>())}");

        if (state is AppInitial) {
          return const SplashPage();
        }

        if (state is AppAuthenticated) {
          return const MainLayout();
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<LoginCubit>()),

            BlocProvider(create: (_) => sl<RequestResetPasswordCubit>()),
          ],
          child: const LoginPage(),
        );
      },
    );
  }
}
