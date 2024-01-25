import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      builder: (context, state) => Scaffold(appBar: AppBar(title: const Text("Splash")), body: Center(child: Text('initializing app'))),
    );
  }
}
