import 'package:flutter/material.dart';

import '../model/onboarding_model.dart';
import '../widgets/on_boarding_card_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  void nextCard() {
    if (currentIndex < onboardingData.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final data = onboardingData[currentIndex];

    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 227, 206, 197),
      body: Center(
        child: OnboardingCard(
          data: data,
          currentIndex: currentIndex,
          total: onboardingData.length,
          onNext: nextCard,
          onSkip: skip,
        ),
      ),
    );
  }
}
