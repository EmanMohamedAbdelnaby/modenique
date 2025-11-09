import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_style/color_app.dart';
import 'card_home.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  List<String> offerImages = [];
  bool isLoading = true;
  String? error;
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("accessToken") ?? '';

      final response = await Dio().get(
        "https://accessories-eshop.runasp.net/api/offers",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final offersData = response.data['offers'];
        if (offersData != null && offersData['items'] != null) {
          final items = offersData['items'] as List;
          setState(() {
            offerImages = items
                .map<String>((e) => e['coverUrl'] as String)
                .toList();
            isLoading = false;
          });
          startAutoSlide();
        } else {
          setState(() {
            offerImages = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = "Failed to load offers: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void startAutoSlide() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      if (offerImages.isEmpty) return;
      setState(() {
        currentIndex = (currentIndex + 1) % offerImages.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text("Error: $error"));
    if (offerImages.isEmpty)
      return const Center(child: Text("No offers found."));

    return Column(
      children: [
        CardHome(
          images: offerImages, // تمرير كل الصور للقائمة
          changeDuration: const Duration(seconds: 3), // وقت التغيير بين الصور
        ),
        const SizedBox(height: 7),
        DotsIndicator(
          dotsCount: offerImages.length,
          position: currentIndex.toDouble(),
          decorator: DotsDecorator(
            activeColor: AppColors.primaryColor,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ],
    );
  }
}
