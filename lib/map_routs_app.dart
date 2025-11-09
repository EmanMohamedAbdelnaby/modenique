import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/core/utils/app_constant/routes.dart';
import 'package:nti_final_project_new/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nti_final_project_new/features/auth/presentation/screens/forget_password.dart';
import 'package:nti_final_project_new/features/auth/presentation/screens/login_screen.dart';
import 'package:nti_final_project_new/features/auth/presentation/screens/register_screen.dart';
import 'package:nti_final_project_new/features/auth/presentation/screens/reset_password.dart';
import 'package:nti_final_project_new/features/auth/presentation/screens/verification_code.dart';
import 'package:nti_final_project_new/features/home/presentation/cubit/search_cubit.dart';
import 'package:nti_final_project_new/features/home/presentation/screens/cart_screen.dart';
import 'package:nti_final_project_new/features/home/presentation/screens/details_screen.dart';
import 'package:nti_final_project_new/features/home/presentation/screens/product_screen.dart';
import 'package:nti_final_project_new/features/main/main_screen.dart';
import 'package:nti_final_project_new/features/onboarding/screen/onboarding_screen.dart';
import 'package:nti_final_project_new/features/profile/presentaion/screens/edit_profile.dart';
import 'features/home/data/services/home_api_service.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/home/presentation/screens/notification_screen.dart';
import 'features/home/presentation/screens/search_screen.dart';

Map<String, Widget Function(BuildContext)> routsApp = {
  AppRoute.mainScreen: ((context) => const MainScreen()),
  AppRoute.login: ((context) => const LoginScreen()),
  AppRoute.signUp: ((context) => const RegisterScreen()),
  AppRoute.veryfiycode: ((context) => const VerificationCodeScreen()),
  AppRoute.forgetPassword: ((context) => const ForgetPassword()),
  AppRoute.resetpassword: ((context) => BlocProvider(
    create: (context) => AuthCubit(),
    child: const ResetPassword(),
  )),
  AppRoute.onBoarding: ((context) => const OnboardingScreen()),
  AppRoute.notificationScreen: ((context) => BlocProvider(
    create: (context) => HomeCubit()..getNotifications(),
    child: const NotificationScreen(),
  )),
  AppRoute.productScreen: (context) => BlocProvider(
    create: (context) => HomeCubit()..getAllItems(),
    child: const ProductsScreen(),
  ),
  AppRoute.searchScreen: (context) => BlocProvider(
    create: (_) => SearchCubit(HomeApiServices())..getAllProducts(),
    child: const SearchScreen(),
  ),
  AppRoute.detailsScreen: ((context) => const DetailsScreen()),
  AppRoute.cart: ((context) => const CartScreen()),
   AppRoute.editProfile: ((context) => const EditProfile()),
};
