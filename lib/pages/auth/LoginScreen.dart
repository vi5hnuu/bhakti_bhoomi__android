import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomElevatedButton.dart';
import 'package:bhakti_bhoomi/widgets/CustomInputField.dart';
import 'package:bhakti_bhoomi/widgets/CustomTextButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/notificationSnackbar.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CancelToken cancelToken = CancelToken();
  final formKey = GlobalKey<FormState>(debugLabel: 'loginForm');
  final TextEditingController usernameEmailController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: state.error!, color: Colors.red));
        }
        if (state.isAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: state.message ?? "logged in successfully", color: Colors.green));
          context.goNamed(Routing.home);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 1,
          shadowColor: Colors.grey,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          "Spirtual Shakti",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: "PermanentMarker", fontSize: 32, color: Theme.of(context).primaryColor),
                        ),
                      ),
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
                      const SizedBox(height: 12),
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
                      const SizedBox(height: 18),
                      state.isLoading
                          ? SpinKitThreeBounce(
                              color: Theme.of(context).primaryColor,
                              size: 32,
                            )
                          : CustomElevatedButton(
                              child: const Text(
                                'Log-in',
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      if (!formKey.currentState!.validate()) return;
                                      BlocProvider.of<AuthBloc>(context).add(
                                        LoginEvent(
                                          usernameEmail: usernameEmailController.text,
                                          password: passwordController.text,
                                          cancelToken: cancelToken,
                                        ),
                                      );
                                    }),
                      const SizedBox(height: 14),
                      CustomTextButton(child: Text('Sign-up instead'), onPressed: state.isLoading ? null : () => context.goNamed(Routing.register)),
                      CustomTextButton(onPressed: state.isLoading ? null : () => context.goNamed(Routing.forgotPassword), child: Text('forgot-password')),
                      CustomTextButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  GoRouter.of(context).goNamed(Routing.verify);
                                },
                          child: Text('verify account'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("login cancelled");
    super.dispose();
  }
}
