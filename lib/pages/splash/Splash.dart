import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  final String title;
  const SplashScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => BlocProvider.of<AuthBloc>(context).add(TryAuthenticatingEvent()));

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) return;
        state.isAuthenticated ? GoRouter.of(context).goNamed(Routing.home) : GoRouter.of(context).goNamed(Routing.login);
      },
      listenWhen: (previous, current) => previous != current,
      buildWhen: (previous, current) => false,
      builder: (context, state) => Scaffold(
          body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5),
              child: LottieBuilder.asset(
                'assets/lottie/namaste.json',
                fit: BoxFit.fill,
              ),
            ),
            Text(
              "Spirtual Shakti",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "PermanentMarker", fontSize: 32, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      )),
    );
  }
}
