import 'package:flutter/material.dart';

class CardHome extends StatefulWidget {
  final List<String> images; // بدل صورة واحدة، نبقى نرسل قائمة الصور
  final Duration changeDuration; // وقت تغيير الصورة

  const CardHome({
    super.key,
    required this.images,
    this.changeDuration = const Duration(seconds: 3),
  });

  @override
  State<CardHome> createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.changeDuration, updateImage);
  }

  void updateImage() {
    if (!mounted) return;
    setState(() {
      // نحدد عدد الصور بدون آخر صورة
      int lastIndex = widget.images.length - 1;
      currentIndex = (currentIndex + 1) % lastIndex;
    });
    Future.delayed(widget.changeDuration, updateImage);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: 130,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: Image.network(
            width: 300,
            widget.images[currentIndex], // استخدم currentIndex الجديد
            key: ValueKey<int>(currentIndex),
            fit: BoxFit.fill,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
              );
            },
          ),
        ),
      ),
    );
  }
}
