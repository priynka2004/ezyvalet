import 'package:flutter/material.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/constants/app_images.dart';
import 'package:ezyvalet/constants/app_strings.dart';
import 'package:ezyvalet/constants/app_text_styles.dart';
import 'package:ezyvalet/authintiction/VendorLoginScreen.dart';

class EzyValetScreen extends StatelessWidget {
  const EzyValetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(AppStrings.title, style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildHowItWorksSection(),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildKeyFeaturesSection(screenWidth),
            ),
            const SizedBox(height: 32),
            _buildVendorLoginButton(context),
            const SizedBox(height: 40),
            _buildFooterLinks(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.heroBackground),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.heroTitle,
                  style: AppTextStyles.heroTitle.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.heroSubtitle,
                  style: AppTextStyles.heroSubtitle.copyWith(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return VendorLoginScreen();
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(AppStrings.loginSignup,
                          style: AppTextStyles.buttonWhiteText),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(AppStrings.getStarted,
                          style: AppTextStyles.buttonWhiteText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.howItWorksTitle, style: AppTextStyles.sectionTitle),
        const SizedBox(height: 24),
        _buildStep("Guest Arrival", "Guest arrives at your venue.", Icons.person),
        _buildStep("Valet Service", "Valet parks the car and issues a digital ticket.", Icons.directions_car),
        _buildStep("Car Retrieval", "Guest requests their car via the app and receives real-time updates.", Icons.car_repair),
      ],
    );
  }

  Widget _buildStep(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.dark,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.stepTitle),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.highlightedText),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 20, color:  AppColors.dark),
        ],
      ),
    );
  }

  Widget _buildKeyFeaturesSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Benefits of EzyValet", style: AppTextStyles.sectionTitle),
        const SizedBox(height: 20),
        Text(AppStrings.featuresDescription, style: AppTextStyles.bodyText),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildFeatureCard(Icons.notifications, "Instant Notifications", "Real-time updates for guests."),
            _buildFeatureCard(Icons.description, "Digital & Paperless", "No physical tickets or receipts."),
            _buildFeatureCard(Icons.bar_chart, "Analytics", "Get reports on valet usage."),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.dark, size: 30),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          Text(description,
              style: AppTextStyles.highlightedText, maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildVendorLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VendorLoginScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonLight,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(AppStrings.vendorLogin, style: AppTextStyles.buttonDarkText),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Center(
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 8,
            children: [
              Text(AppStrings.privacyPolicy, style: AppTextStyles.footerLink),
              Text(AppStrings.termsOfService, style: AppTextStyles.footerLink),
            ],
          ),
          const SizedBox(height: 16),
          Text(AppStrings.copyright,
              style: AppTextStyles.footerLink.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
