import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_constant/routes.dart';
import '../../../../core/utils/app_constant/validators.dart';
import '../../../../core/utils/app_style/color_app.dart';
import '../../../../core/utils/shared_custom_widget/custom_text_form_field.dart';
import '../../../../core/utils/shared_custom_widget/primary_button_widget.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/custom_pin_code_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late String email;
  String otp = "";
  bool isPassword = true;
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    email = args;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pushReplacementNamed(context, AppRoute.login);
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
                    const SizedBox(height: 56),
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
                        onPressed: () => Navigator.pop(context),
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
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Text(
                        "Enter the verification code we sent to your email.",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomPinCodeField(
                        onCompleted: (value) => setState(() => otp = value),
                      ),
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
                      hintText: "Enter your new Password",
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
                        onPressed: () =>
                            setState(() => isPassword = !isPassword),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn’t receive code? ",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () => cubit.resendOTP(email),
                          child: Text(
                            "Resend",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    PrimaryButtonWidget(
                      buttonWidth: 320,
                      bootonText: state is AuthLoading
                          ? "Loading..."
                          : "Reset Password",
                      fontsize: 16,
                      onpressed: () {
                        if (formKey.currentState!.validate()) {
                          if (otp.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter the OTP code'),
                              ),
                            );
                          } else {
                            cubit.resetPassword(
                              email: email,
                              otp: otp,
                              newPassword: passwordController.text,
                            );
                          }
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
    );
  }
}
