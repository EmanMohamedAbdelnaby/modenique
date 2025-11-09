import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/core/utils/app_constant/routes.dart';

import '../../../../core/utils/app_constant/validators.dart';
import '../../../../core/utils/app_style/color_app.dart';
import '../../../../core/utils/shared_custom_widget/custom_text_form_field.dart';
import '../../../../core/utils/shared_custom_widget/primary_button_widget.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController emailController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pushNamed(
              context,
              AppRoute.resetpassword,
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

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 65),
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.whiteColor,
                          border: Border.all(
                            color: const Color(0xffE8ECF4),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 17,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Center(
                        child: Text(
                          "Forget Password",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(fontSize: 22),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Enter your email address to reset your password",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Email address",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormeFieldStyle(
                        maxLin: 1,
                        hintText: "your email@example.com",
                        hintTextStyle: Theme.of(context).textTheme.bodySmall,
                        controller: emailController,
                        validate: (val) => Validator.validateEmail(val!),
                      ),
                      const SizedBox(height: 50),
                      PrimaryButtonWidget(
                        buttonWidth: 320,
                        bootonText: state is AuthLoading
                            ? "Loading..."
                            : "Send Email",
                        fontsize: 16,
                        onpressed: () {
                          if (formKey.currentState!.validate()) {
                            cubit.forgetPassword(emailController.text);
                          }
                        },
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
    );
  }
}
