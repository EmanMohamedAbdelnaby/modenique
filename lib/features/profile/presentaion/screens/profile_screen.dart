import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nti_final_project_new/features/auth/presentation/cubit/auth_state.dart';
import 'package:nti_final_project_new/features/profile/data/profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:url_launcher/url_launcher.dart';

import '/core/utils/app_constant/app_assets.dart';
import '/core/utils/app_constant/routes.dart';
import '/core/utils/app_style/color_app.dart';
import '../../../../core/utils/app/app_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkTheme = false;

  UserModel user = UserModel(
    name: "Amelia Stardust",
    email: "amelia.stardust@email.com",
    phone: "01012345678",
    imagePath: AppAssets.logoOption1,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "My Profile",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge!.copyWith(fontSize: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoute.editProfile,
                      arguments: user,
                    );
                    if (result != null && result is UserModel) {
                      setState(() {
                        user = result;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: Card(
                    elevation: 2,
                    shadowColor: AppColors.blackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      width: 300,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: user.imagePath != null
                                ? (File(user.imagePath!).existsSync()
                                      ? FileImage(File(user.imagePath!))
                                      : AssetImage(user.imagePath!)
                                            as ImageProvider)
                                : AssetImage(AppAssets.logoOption1),
                          ),

                          const SizedBox(height: 15),
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                buildMenuItem(
                  icon: Icons.brightness_6_rounded,
                  title: "Change Theme",
                  trailing: Switch(
                    value:
                        context.watch<AppCubit>().currentTheme ==
                        ThemeModeState.dark,
                    activeColor: AppColors.primaryColor,
                    onChanged: (val) {
                      if (val) {
                        context.read<AppCubit>().selectTheme(
                          ThemeModeState.dark,
                        );
                      } else {
                        context.read<AppCubit>().selectTheme(
                          ThemeModeState.light,
                        );
                      }
                    },
                  ),
                  onPressed: () {},
                ),
                buildMenuItem(
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      builder: (bottomSheetContext) {
                        return BlocProvider.value(
                          value: context.read<AuthCubit>(), // 🔥 دا أهم سطر
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom:
                                  MediaQuery.of(
                                    bottomSheetContext,
                                  ).viewInsets.bottom +
                                  20,
                              top: 20,
                            ),
                            child: ChangePasswordCard(),
                          ),
                        );
                      },
                    );
                  },
                ),
                buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy & Policy",
                  onPressed: () {},
                ),
                buildMenuItem(
                  icon: Icons.info_outline,
                  title: "About Us",
                  onPressed: () {},
                ),
                buildMenuItem(
                  icon: Icons.contact_support_outlined,
                  title: "Contact Us",
                  onPressed: () {
                    _launchCaller('01012345678'); 
                  },
                ),
                buildMenuItem(
                  icon: Icons.language_outlined,
                  title: "Language",
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoggedOut &&
                        state.message.contains("Logged out")) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoute.login,
                        (route) => false,
                      );
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final bool isLoading = state is AuthLoading;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                final confirmLogout = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Confirm Logout"),
                                    content: const Text(
                                      "Are you sure you want to log out?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Confirm"),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmLogout == true) {
                                  context.read<AuthCubit>().logout();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Logout",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required void Function()? onPressed,
    required String title,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // أصغر من 6
      child: Card(
        elevation: 2,
        shadowColor: AppColors.blackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ), // أصغر شوية
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 1,
          ), // قللت الهامش الأفقي
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ), // محتوى ثابت
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D6),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: AppColors.primaryColor),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              trailing ??
                  IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordCard extends StatefulWidget {
  @override
  State<ChangePasswordCard> createState() => _ChangePasswordCardState();
}

class _ChangePasswordCardState extends State<ChangePasswordCard> {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool isLoading = false;
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoading) {
          setState(() => isLoading = true);
        } else {
          setState(() => isLoading = false);

          if (!mounted) return;

          if (state is AuthSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
      child: Card(
        elevation: 3,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16), // أقل من 20
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Change Password",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // أصغر شوية
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildField("Old Password", oldPassController),
              const SizedBox(height: 10),
              _buildField("New Password", newPassController),
              const SizedBox(height: 10),
              _buildField("Confirm Password", confirmPassController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (newPassController.text !=
                            confirmPassController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Passwords do not match"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        context.read<AuthCubit>().changePassword(
                          currentPassword: oldPassController.text,
                          newPassword: newPassController.text,
                          confirmNewPassword: confirmPassController.text,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 45), // أقل من 50
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 15, // أصغر
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller) {
    bool showPassword = controller == oldPassController
        ? _showOldPassword
        : controller == newPassController
        ? _showNewPassword
        : _showConfirmPassword;

    return TextField(
      controller: controller,
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        filled: false, // لو عايزة بدون لون خلفية
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.primaryColor,
            size: 20, // أصغر شوية
          ),
          onPressed: () {
            setState(() {
              if (controller == oldPassController) {
                _showOldPassword = !_showOldPassword;
              } else if (controller == newPassController) {
                _showNewPassword = !_showNewPassword;
              } else {
                _showConfirmPassword = !_showConfirmPassword;
              }
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      style: const TextStyle(fontSize: 14), // أصغر شوية
    );
  }
}

void _launchCaller(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}
