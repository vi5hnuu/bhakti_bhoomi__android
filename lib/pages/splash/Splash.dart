import 'dart:async';

import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  final String title;
  const SplashScreen({super.key, required this.title});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer(const Duration(seconds: 3), () {
      final state = BlocProvider.of<AuthBloc>(context).state;
      handleTryAuth(state);
    });
    BlocProvider.of<AuthBloc>(context).add(const TryAuthenticatingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) => handleTryAuth(state),
      listenWhen: (previous, current) => previous != current,
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.page,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 3),
                // ॐ within faint concentric rings
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _ring(220),
                      _ring(160),
                      Text(
                        'ॐ',
                        style: TextStyle(
                          fontFamily: AppFonts.devanagari,
                          fontSize: 92,
                          color: AppColors.gold,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'नमस्ते',
                  style: TextStyle(
                    fontFamily: AppFonts.devanagari,
                    fontSize: 28,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(flex: 2),
                Text('Bhakti Bhoomi', style: AppTypography.textTheme.displayMedium),
                const SizedBox(height: 12),
                Text(
                  'Sacred texts, daily rituals & quiet practice —\ngathered in one calm place.',
                  textAlign: TextAlign.center,
                  style: AppTypography.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'पवित्र ग्रंथ, नित्य साधना — एक शांत स्थान पर',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.devanagari,
                    fontSize: 14,
                    color: AppColors.textFaint,
                  ),
                ),
                const Spacer(flex: 2),
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ring(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surfaceAlt),
      ),
    );
  }

  handleTryAuth(final AuthState state) {
    if (state.isLoading(forr: Httpstates.TRY_AUTH) || timer?.isActive == true) {
      return;
    } else if (state.isError(forr: Httpstates.TRY_AUTH) || (!state.isAuthenticated && timer?.isActive == false)) {
      GoRouter.of(context).replaceNamed(Routing.home.name);
    } else if (state.isAuthenticated && timer?.isActive != true) {
      GoRouter.of(context).replaceNamed(Routing.home.name);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
