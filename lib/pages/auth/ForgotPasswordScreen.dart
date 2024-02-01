import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomInputField.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/notificationSnackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final CancelToken cancelToken = CancelToken();
  final formKey = GlobalKey<FormState>(debugLabel: 'loginForm');
  final TextEditingController usernameEmailController = TextEditingController(text: 'vishnuk');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: state.error!, color: Colors.red));
        }
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: state.message!, color: Colors.green));
          GoRouter.of(context).pushReplacementNamed(Routing.otp, pathParameters: {'usernameEmail': usernameEmailController.text});
        }
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
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (!formKey.currentState!.validate()) return;
                            BlocProvider.of<AuthBloc>(context).add(
                              ForgotPasswordEvent(
                                usernameEmail: usernameEmailController.text,
                                cancelToken: cancelToken,
                              ),
                            );
                          },
                    child: Text(
                      'Forgot-password',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  ),
                  TextButton(onPressed: state.isLoading ? null : () => context.goNamed(Routing.login), child: Text('Sign-in instead'))
                ],
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
