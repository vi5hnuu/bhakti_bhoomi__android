import 'package:bhakti_bhoomi/pages/auth/ForgotPasswordScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/LoginScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/OtpScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/RegisterScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/UpdatePasswordScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/VerifyScreen.dart';
import 'package:bhakti_bhoomi/pages/profileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:bhakti_bhoomi/Routing/routes.dart' as BBR;

final authRoutes=GoRoute(
  path: BBR.Routing.login.baseUrl,
  redirect: (context, state) => state.fullPath == BBR.Routing.login.baseUrl ? BBR.Routing.login.fullPath : null,
  routes: [
    GoRoute(
      name: BBR.Routing.login.name,
      path: BBR.Routing.login.path,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      name: BBR.Routing.verify.name,
      path: BBR.Routing.verify.path,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: VerifyScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      name: BBR.Routing.forgotPassword.name,
      path: BBR.Routing.forgotPassword.path,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const ForgotPasswordScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      name: BBR.Routing.otp.name,
      path: BBR.Routing.otp.path,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: OtpScreen(usernameEmail: state.pathParameters['usernameEmail']!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      name: BBR.Routing.updatePassword.name,
      path: BBR.Routing.updatePassword.path,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const UpdatePasswordScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      name: BBR.Routing.register.name,
      path: BBR.Routing.register.path,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const RegisterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      name: BBR.Routing.profile.name,
      path: BBR.Routing.profile.path,
      builder: (context, state) => const ProfileScreen(),
    )
  ]);
