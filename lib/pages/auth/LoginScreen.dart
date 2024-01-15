import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_state_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameEmailController =
      TextEditingController(text: 'admin');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStateBloc, AuthState>(
      listener: (ctx, state) {
        if (!state.isLogedIn) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: const Text("Login Successfull")));
        context.goNamed(Routing.home);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(12.5),
          child: Center(
              child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username/Email',
                ),
                controller: usernameEmailController,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                controller: passwordController,
              ),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthStateBloc>(context).add(
                    LoginEvent(
                      usernameEmail: usernameEmailController.text,
                      password: passwordController.text,
                    ),
                  );
                },
                child: Text('Login'),
              ),
              TextButton(
                  onPressed: () => context.goNamed(Routing.register),
                  child: Text('Sign-up instead'))
            ],
          )),
        ),
      ),
    );
  }
}
