import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_style/color_app.dart';
import '../../data/models/notification_model.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().getNotifications();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Notifications",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is NotificationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationSuccessState) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return const Center(child: Text("No notifications found"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12), // أقل من 16
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                NotificationModel item = notifications[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // أصغر من 20
                  ),
                  elevation: 2, // أقل من 4
                  shadowColor: AppColors.blackColor.withOpacity(0.2),
                  margin: const EdgeInsets.only(bottom: 12), // أقل من 16
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ), // أصغر
                    leading: CircleAvatar(
                      radius: 20, // أقل من 25
                      backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                      child:
                          item.coverPictureUrl != null &&
                              item.coverPictureUrl!.isNotEmpty
                          ? ClipOval(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: SvgPicture.network(
                                  item.coverPictureUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.notifications,
                              color: AppColors.primaryColor,
                              size: 20, // أصغر من default
                            ),
                    ),
                    title: Text(
                      item.title ?? "Notification ${index + 1}",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16, // أقل من 18
                        fontWeight: FontWeight.w500, // أخف شوية
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2), // أقل من 4
                        Text(
                          item.message ?? "",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 13, // أقل من 15
                              ),
                        ),
                        const SizedBox(height: 4), // أقل من 6
                        Text(
                          item.date?.split("T").first ?? "",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 11, // أقل من 13
                              ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14, // أقل من 16
                      color: Colors.grey[400],
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          } else if (state is NotificationFailureState) {
            return Center(child: Text("Error: ${state.errorMessage}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
