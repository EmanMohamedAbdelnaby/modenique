import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/core/utils/app_constant/routes.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';
import 'package:nti_final_project_new/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nti_final_project_new/features/home/presentation/cubit/coupon_cubit.dart';
import 'package:nti_final_project_new/features/home/presentation/cubit/home_cubit.dart';
import 'package:nti_final_project_new/features/home/presentation/screens/coupon_screen.dart';
import 'package:nti_final_project_new/features/home/presentation/screens/favourite_screen.dart';
import 'package:nti_final_project_new/features/home/presentation/screens/home_screen.dart';
//import 'package:nti_final_project_new/features/home/presentation/screens/image_search/search_image.dart';

import '../add_product/presentation/screens/add_products.dart';
import '../profile/presentaion/screens/profile_screen.dart';
//import '../profile/presentaion/screens/edit_profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (_) => FavoriteCubit()),
        BlocProvider(create: (_) => CouponCubit()),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: [
            BlocProvider(
              create: (_) => HomeCubit(),
              child: const HomeScreens(),
            ),
            FavoriteScreen(),
            CouponScreen(),
            //SearchImage(),
            AddProducts(),
            BlocProvider(
              create: (_) => AuthCubit(),
              child: const ProfilePage(),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.cart);
            },
            mini: true,
            shape: const CircleBorder(),
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            child: Icon(
              Icons.shopping_cart,
              size: 26,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          unselectedItemColor: AppColors.greyColor.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 35),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined, size: 35),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined, size: 35),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined, size: 35),
              label: "   ",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 35),
              label: " ",
            ),
          ],
        ),
      ),
    );
  }
}
