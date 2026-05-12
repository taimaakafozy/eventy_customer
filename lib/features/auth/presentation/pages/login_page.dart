import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_content_container.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../blocs/app_cubit.dart';
import '../blocs/login_cubit.dart';
import '../blocs/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController phoneController;
  late final TextEditingController passController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), 
          child: Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Column(
                children: [
                  const AppLogo(),
                  AppContentContainer(
                    child: Column(
                      children: [
                        const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        PrimaryTextField(
                          label: 'رقم الموبايل',
                          icon: Icons.phone_android,
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: height * 0.01),
                        PrimaryTextField(
                          label: 'كلمة المرور',
                          icon: Icons.lock,
                          controller: passController,
                          isPassword: true,
                        ),
                        SizedBox(height: height * 0.03),
                        PrimaryButton(
                          title: 'تسجيل الدخول',
                          // onPressed: () {
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (_) => const MainLayout(),
                          //     ),
                          //   );
                          // },
                          onPressed: () {
                            // context.read<LoginCubit>().login(
                            //   phoneController.text,
                            //   passController.text,
                            // );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
