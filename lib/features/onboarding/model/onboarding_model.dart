import 'package:nti_final_project_new/core/utils/app_constant/app_assets.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String subtitle;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

final List<OnboardingModel> onboardingData = [
  OnboardingModel(
    image: AppAssets.onboard1,
    title: 'MAKE IT FASHIONABLE',
    subtitle: 'With new fashion style',
  ),
  OnboardingModel(
    image: AppAssets.onboard2,
    title: 'SHOP THE MODERN ESSENTIALS',
    subtitle: 'With most modern fashion style',
  ),
  OnboardingModel(
    image: AppAssets.onboard3,
    title: 'NEW CLOTHS NEW PASSION',
    subtitle: 'With fresh fashion tastes',
  ),
];
