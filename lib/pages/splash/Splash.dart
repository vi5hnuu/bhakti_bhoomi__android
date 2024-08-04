import 'dart:async';

import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  final String title;
  const SplashScreen({super.key, required this.title});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(const TryAuthenticatingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading(forr: Httpstates.TRY_AUTH)){
          return;
        }else if(state.isError(forr: Httpstates.TRY_AUTH)){
          GoRouter.of(context).replaceNamed(Routing.login);
        }else if(state.isAuthtenticated){
          GoRouter.of(context).replaceNamed(Routing.home);
        }
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
            Column(
              children: [
                Text(
                  "Spiritual Shakti",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "PermanentMarker", fontSize: 32, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 15),
                Text(
                  "initializing...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "PermanentMarker", fontSize: 12, color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
