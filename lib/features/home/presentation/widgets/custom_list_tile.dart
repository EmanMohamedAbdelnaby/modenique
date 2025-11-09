import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_style/color_app.dart';

class CustomListTile extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? description;
  final void Function()? onPressed;
  const CustomListTile(
      {super.key,
      this.onPressed,
      required this.imageUrl,
      this.title,
      this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.greyColor.withOpacity(0.11)),
      child: ListTile(
        title: Text(title!, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(description!,
        maxLines: 1,
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13)),
        leading: CachedNetworkImage(imageUrl: imageUrl),
      ),
    );
  }
}
