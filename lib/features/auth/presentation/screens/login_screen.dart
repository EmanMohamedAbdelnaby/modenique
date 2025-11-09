import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/core/utils/app_constant/routes.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';
import 'package:nti_final_project_new/core/utils/app_style/text_style_app.dart';
import 'package:nti_final_project_new/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nti_final_project_new/features/auth/presentation/cubit/auth_state.dart';

import '../../../../core/utils/app_constant/validators.dart';
import '../../../../core/utils/shared_custom_widget/custom_text_form_field.dart';
import '../../../../core/utils/shared_custom_widget/primary_button_widget.dart';
import '../widgets/cistom_other_methods_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isPassword = true;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.pushReplacementNamed(context, AppRoute.mainScreen);
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();

            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        Center(
                          child: Text(
                            "Modenique",
                            style: AppTextSty.titleAuthTextStyle.copyWith(
                              fontSize: 26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Welcome back",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "Email",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormeFieldStyle(
                          maxLin: 1,
                          hintText: "Enter your Email",
                          hintTextStyle: Theme.of(context).textTheme.bodySmall,
                          controller: emailController,
                          validate: (val) => Validator.validateEmail(val!),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Password",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormeFieldStyle(
                          maxLin: 1,
                          hintText: "Enter your Password",
                          hintTextStyle: Theme.of(context).textTheme.bodySmall,
                          controller: passwordController,
                          validate: (val) => Validator.validatePassword(val!),
                          isPassword: isPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPassword
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                isPassword = !isPassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 40,
                              child: TextButton(
                                child: Text(
                                  "Forgot your password?",
                                  style: AppTextSty.titleAuthTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoute.forgetPassword,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        state is AuthLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : PrimaryButtonWidget(
                                bootonText: 'Login in',
                                onpressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.login(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                  }
                                },
                                fontsize: 16,
                                borderRaduis: 20,
                                buttonWidth: 320,
                                buttonHight: 50,
                              ),
                        const SizedBox(height: 30),
                        const OtherLoginMethods(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Create new account?",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoute.signUp,
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: AppTextSty.titleAuthTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
