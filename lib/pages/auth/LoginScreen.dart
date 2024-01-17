import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_state_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomInputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/notificationSnackbar.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final formKey = GlobalKey<FormState>(debugLabel: 'loginForm');
  final TextEditingController usernameEmailController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthStateBloc, AuthState>(
      listenWhen: (previous, current) => previous.isLoggedIn != current.isLoggedIn || previous.error != current.error || previous.isLoading != current.isLoading,
      listener: (ctx, state) {
        if (state.error) ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: state.message ?? "Something went wrong", color: Colors.red));
        if (!state.isLoggedIn || state.error) return;
        ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: "logged in successfully", color: Colors.green));
        context.goNamed(Routing.home);
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
          elevation: 10,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomInputField(
                      controller: usernameEmailController,
                      labelText: 'Username/Email',
                      hintText: 'xyz/xyz@gmail.com',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter username/email";
                        }
                        return null;
                      }),
                  SizedBox(height: 12),
                  CustomInputField(
                    controller: passwordController,
                    labelText: 'password',
                    hintText: '**********',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      return null;
                    },
                    obscureText: true,
                    autoCorrect: false,
                  ),
                  SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (!formKey.currentState!.validate()) return;
                            BlocProvider.of<AuthStateBloc>(context).add(
                              LoginEvent(
                                usernameEmail: usernameEmailController.text,
                                password: passwordController.text,
                              ),
                            );
                          },
                    child: Text(
                      'Log-in',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  ),
                  TextButton(onPressed: state.isLoading ? null : () => context.goNamed(Routing.register), child: Text('Sign-up instead'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
