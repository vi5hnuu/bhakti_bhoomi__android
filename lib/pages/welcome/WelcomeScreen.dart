import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/om_medallion.dart';
import 'package:bhakti_bhoomi/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Design #01 — Welcome / onboarding. Shown as an optional intro; "Begin"
/// enters the app (Home tab), and existing users can jump to sign in.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const OmMedallion(size: 132),
              const SizedBox(height: 28),
              Text('Bhakti Bhoomi', style: AppTypography.textTheme.displayLarge, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'A calm home for sacred texts,\ndaily rituals & quiet practice.',
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'भक्ति · ज्ञान · साधना',
                style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 16, color: AppColors.goldDeep),
              ),
              const Spacer(flex: 3),
              PrimaryButton(label: 'Begin', icon: Icons.arrow_forward_rounded, onPressed: () => context.goNamed(Routing.home.name)),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.pushNamed(Routing.login.name),
                child: const Text('I already have an account'),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
