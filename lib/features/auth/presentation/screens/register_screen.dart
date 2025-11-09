import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/core/utils/app_constant/routes.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';
//import 'package:nti_final_project_new/features/auth/data/services/api_services.dart';
import 'package:nti_final_project_new/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nti_final_project_new/features/auth/presentation/cubit/auth_state.dart';

import '../../../../core/utils/app_constant/validators.dart';
import '../../../../core/utils/shared_custom_widget/custom_text_form_field.dart';
import '../../../../core/utils/shared_custom_widget/primary_button_widget.dart';
import '../widgets/cistom_other_methods_login.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPassword = true;
  bool isConfirmPassword = true;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
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
              Navigator.pushNamed(
                context,
                AppRoute.veryfiycode,
                arguments: emailController.text,
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      Text(
                        "Create Account",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        "First Name",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormeFieldStyle(
                        maxLin: 1,
                        hintText: "Enter your first name",

                        prefixIcon: Icon(
                          Icons.person,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        hintTextStyle: Theme.of(context).textTheme.bodySmall,
                        controller: firstNameController,
                        validate: (val) =>
                            Validator.validateUserName(val ?? "First name"),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        "Last Name",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormeFieldStyle(
                        maxLin: 1,
                        hintText: "Enter your last name",
                        prefixIcon: Icon(
                          Icons.person,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        hintTextStyle: Theme.of(context).textTheme.bodySmall,
                        controller: lastNameController,
                        validate: (val) =>
                            Validator.validateUserName(val ?? "Last name"),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        "Email",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormeFieldStyle(
                        maxLin: 1,
                        hintText: "Enter your email",
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        hintTextStyle: Theme.of(context).textTheme.bodySmall,
                        controller: emailController,
                        validate: (val) => Validator.validateEmail(val ?? ""),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        "Password",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormeFieldStyle(
                        maxLin: 1,
                        isPassword: isPassword,
                        hintText: "Enter password",
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
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
                        hintTextStyle: Theme.of(context).textTheme.bodySmall,
                        controller: passwordController,
                        validate: (val) =>
                            Validator.validatePassword(val ?? ""),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        "Confirm Password",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormeFieldStyle(
                        maxLin: 1,
                        isPassword: isConfirmPassword,
                        hintText: "Confirm your password",
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isConfirmPassword
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined,
                            size: 18,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              isConfirmPassword = !isConfirmPassword;
                            });
                          },
                        ),
                        hintTextStyle: Theme.of(context).textTheme.bodySmall,
                        controller: confirmPasswordController,
                        validate: (val) {
                          if (val != passwordController.text) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: 320,
                        height: 50,
                        child: state is AuthLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : PrimaryButtonWidget(
                                bootonText: 'Sign up',
                                onpressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.registerUser(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      firstname: firstNameController.text
                                          .trim(),
                                      lastname: lastNameController.text.trim(),
                                    );
                                  }
                                },
                                fontsize: 16,
                                borderRaduis: 20,
                                buttonWidth: 320,
                                buttonHight: 50,
                              ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(fontSize: 13),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const OtherLoginMethods(),
                    ],
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
