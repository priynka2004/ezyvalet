import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/constants/app_images.dart';
import 'package:ezyvalet/constants/app_strings.dart';
import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';

class EzyValetScreen extends StatelessWidget {
  const EzyValetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.title,
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildHowItWorksSection(),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildKeyFeaturesSection(),
            ),
            const SizedBox(height: 24),
            Center(child: _buildVendorLoginButton(context)),
            const SizedBox(height: 16),
            _buildFooterLinks(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(AppImages.heroBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppStrings.heroTitle, style: AppTextStyles.heroTitle),
            const SizedBox(height: 12),
            Text(AppStrings.heroSubtitle, style: AppTextStyles.heroSubtitle),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: AppColors.dark,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    AppStrings.loginSignup,
                    style: AppTextStyles.buttonWhiteText,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.dark,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    AppStrings.getStarted,
                    style: AppTextStyles.buttonDarkText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.howItWorksTitle, style: AppTextStyles.sectionTitle),
        const SizedBox(height: 20),
        _buildStep("Guest Arrival", "Guest arrives at your venue.",
            Icons.person),
        _buildStep("Valet Service",
            "Valet parks the car and issues a digital ticket.", Icons.directions_car),
        _buildStep("Car Retrieval",
            "Guest requests their car via the app and receives real-time updates.",
            Icons.car_repair),
      ],
    );
  }

  Widget _buildStep(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.dark,
              child: Icon(icon, color: AppColors.white, size: 16),
            ),
            Container(width: 2, height: 40, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.stepTitle),
              const SizedBox(height: 4),
              Text(description, style: AppTextStyles.highlightedText),
              const SizedBox(height: 16),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildKeyFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Benefits of EzyValet", style: AppTextStyles.sectionTitle),
        const SizedBox(height: 40),
        Text("Key Features", style: AppTextStyles.sectionTitle),
        const SizedBox(height: 14),
        Text(
          AppStrings.featuresDescription,
          style: AppTextStyles.bodyText,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildFeatureCard(Icons.notifications, "Instant Notifications",
                "Guests receive real-time updates on their car's status."),
            _buildFeatureCard(Icons.description, "Digital & Paperless",
                "Reduce paper waste and streamline operations."),
            _buildFeatureCard(Icons.bar_chart, "Powerful Analytics",
                "Gain insights into valet performance and guest satisfaction."),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: AppColors.dark),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 4),
          Text(description, style: AppTextStyles.highlightedText),
        ],
      ),
    );
  }

  Widget _buildVendorLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VendorLoginScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonLight,
        foregroundColor: AppColors.dark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(AppStrings.vendorLogin, style: AppTextStyles.buttonDarkText),
    );
  }

  Widget _buildFooterLinks() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppStrings.privacyPolicy,
                  style: AppTextStyles.footerLink),
              const SizedBox(width: 30),
              Text(AppStrings.termsOfService,
                  style: AppTextStyles.footerLink),
            ],
          ),
          const SizedBox(height: 8),
          Text(AppStrings.copyright,
              style: AppTextStyles.footerLink),
        ],
      ),
    );
  }
}
