import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nti_final_project_new/features/home/presentation/screens/image_search/imagesearch_controller.dart';

class SearchImage extends StatelessWidget {
  const SearchImage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImageSearchController());
    final ImagePicker picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(title: const Text("Search by Image")),
      body: GetBuilder<ImageSearchController>(
        builder: (_) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                controller.file == null
                    ? const Text("Select an image")
                    : Image.file(controller.file!, height: 200),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // اختيار صورة من المعرض
                        final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          controller.chooseImage(File(pickedFile.path));
                        }
                      },
                      child: const Text("Choose Image"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => controller.uploadImage(),
                      child: const Text("Search"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (controller.statusRequest.value == "loading")
                  const CircularProgressIndicator(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.aiSearchResults.length,
                  itemBuilder: (context, index) {
                    final item = controller.aiSearchResults[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          item.itemsImage ?? "",
                          width: 60,
                        ),
                        title: Text(item.itemsName ?? ""),
                        subtitle: Text(item.itemsDesc ?? ""),
                        trailing: Text("\$${item.itemsPrice ?? 0}"),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
