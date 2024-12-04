import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../..//navigation/main_navigation.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 94, 239),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/piggybank_logo.png',
                height: 200,
                width: 200,
              ),
              
              Text(
                'Piggy Money',
                style: AppTheme.headingStyle.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Track your expenses, set budgets,\nand achieve your financial goals',
                textAlign: TextAlign.center,
                style: AppTheme.bodyStyle.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 48),
              _buildFeatureItem(Icons.track_changes, 'Track daily expenses'),
              _buildFeatureItem(Icons.pie_chart, 'Detailed analytics'),
              _buildFeatureItem(Icons.notifications, 'Budget alerts'),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainNavigation(),
                      ),
                    );
                  },
                  style: AppTheme.primaryButtonStyle,
                  child: Text(
                    'Get Started',
                    style: AppTheme.subheadingStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.w500),

            ),
          ],
        ),
      ),
    );
  }
}
