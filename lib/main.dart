import 'package:bhakti_bhoomi/pages/aarti/AartiScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/LoginScreen.dart';
import 'package:bhakti_bhoomi/pages/auth/RegisterScreen.dart';
import 'package:bhakti_bhoomi/pages/bhagvad-geeta/BhagvadGeetaScreen.dart';
import 'package:bhakti_bhoomi/pages/brahmasutra/BrahmasutraScreen.dart';
import 'package:bhakti_bhoomi/pages/chalisa/ChalisaScreen.dart';
import 'package:bhakti_bhoomi/pages/chanakya-neeti/ChanakyaNeetiScreen.dart';
import 'package:bhakti_bhoomi/pages/home/homeScreen.dart';
import 'package:bhakti_bhoomi/pages/mahabharat/MahabharatScreen.dart';
import 'package:bhakti_bhoomi/pages/mantra/MantraScreen.dart';
import 'package:bhakti_bhoomi/pages/ramcharitmanas/RamcharitmanasScreen.dart';
import 'package:bhakti_bhoomi/pages/rigveda/RigvedaScreen.dart';
import 'package:bhakti_bhoomi/pages/valmiki-ramayan/ValmikiRamayanScreen.dart';
import 'package:bhakti_bhoomi/pages/yogasutra/YogaSutraScreen.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_state_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AuthStateBloc(),
      child: MaterialApp.router(
        title: 'Spirtual Shakti',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
            errorBuilder: (context, state) =>
                const Home(title: 'Spirtual Shakti'),
            redirect: (context, state) {
              print(
                  "${state.fullPath},${state.error},${state.extra},${state.matchedLocation},${state.path},${state.uri}");
              if (!['/register', '/login'].contains(state.fullPath) &&
                  !BlocProvider.of<AuthStateBloc>(context).isLoggedIn) {
                return '/login';
              }
            },
            initialLocation: '/register',
            routes: [
              GoRoute(
                name: Routing.home,
                path: '/',
                builder: (context, state) =>
                    const Home(title: 'Spirtual Shakti'),
              ),
              GoRoute(
                name: Routing.login,
                path: '/login',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const LoginScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.register,
                path: '/register',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const RegisterScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
              GoRoute(
                name: Routing.aarti,
                path: '/aarti',
                builder: (context, state) => const AartiHome(title: 'Aarti'),
              ),
              GoRoute(
                name: Routing.brahmasutra,
                path: '/brahmasutra',
                builder: (context, state) =>
                    const BrahmasutraHome(title: 'Brahmasutra'),
              ),
              GoRoute(
                name: Routing.chalisa,
                path: '/chalisa',
                builder: (context, state) =>
                    const ChalisaHome(title: 'Chalisa'),
              ),
              GoRoute(
                name: Routing.chanakyaNiti,
                path: '/chanakya-niti',
                builder: (context, state) =>
                    const ChanakyaNeetiHome(title: 'ChanaKya Niti'),
              ),
              GoRoute(
                name: Routing.mahabharat,
                path: '/mahabharat',
                builder: (context, state) =>
                    const MahabharatHome(title: 'MahaBharat'),
              ),
              GoRoute(
                name: Routing.mantra,
                path: '/mantra',
                builder: (context, state) => const MantraHome(title: 'Mantra'),
              ),
              GoRoute(
                name: Routing.ramcharitmanas,
                path: '/ramcharitmanas',
                builder: (context, state) =>
                    const RamcharitmanasHome(title: 'RamCharitManas'),
              ),
              GoRoute(
                name: Routing.rigveda,
                path: '/rigveda',
                builder: (context, state) =>
                    const RigvedaHome(title: 'RigVeda'),
              ),
              GoRoute(
                name: Routing.valmikiRamayan,
                path: '/valmiki-ramayan',
                builder: (context, state) =>
                    const ValmikiRamayanHome(title: 'Valmiki Ramayan'),
              ),
              GoRoute(
                name: Routing.bhagvadGeeta,
                path: '/bhagvad-geeta',
                builder: (context, state) =>
                    const BhagvadGeetaHome(title: 'BhaGvad Geeta'),
              ),
              GoRoute(
                name: Routing.yogaSutra,
                path: '/yoga-sutra',
                builder: (context, state) =>
                    const YogaSutraHome(title: 'Yoga Sutra'),
              ),
            ]),
      ),
    );
  }
}
