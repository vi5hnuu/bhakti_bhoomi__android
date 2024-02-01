import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/CustomInputField.dart';

class OtpScreen extends StatefulWidget {
  final String usernameEmail;
  const OtpScreen({super.key, required this.usernameEmail});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final formKey = GlobalKey<FormState>(debugLabel: 'registerForm');
  final TextEditingController usernameEmailCntrl = TextEditingController(text: 'vishnuk');
  final TextEditingController otpCntrl = TextEditingController(text: '');
  final TextEditingController passwordCntrl = TextEditingController(text: '9876543210');
  final TextEditingController confirmPasswordCntrl = TextEditingController(text: '9876543210');
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message ?? "password changed successfully")));
            GoRouter.of(context).goNamed(Routing.login);
          }
        },
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                title: Text('Registration'),
                centerTitle: true,
                elevation: 10,
                backgroundColor: Colors.orangeAccent,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.5),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomInputField(
                            controller: usernameEmailCntrl,
                            hintText: "username",
                            labelText: "username",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 7,
                        ),
                        CustomInputField(
                            controller: otpCntrl,
                            hintText: "otp",
                            labelText: "123456",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter otp';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 7,
                        ),
                        CustomInputField(
                            controller: passwordCntrl,
                            obscureText: true,
                            hintText: "as4c45a65s",
                            labelText: "password",
                            suffixIcon: Icon(Icons.password),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid password';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 18,
                        ),
                        CustomInputField(
                            controller: confirmPasswordCntrl,
                            obscureText: true,
                            hintText: "as4c45a65s",
                            labelText: "confirm password",
                            suffixIcon: Icon(Icons.password),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid password';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 18,
                        ),
                        ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState?.validate() == false) {
                                    return;
                                  }
                                  BlocProvider.of<AuthBloc>(context).add(ResetPasswordEvent(
                                      usernameEmail: widget.usernameEmail, otp: otpCntrl.text, password: passwordCntrl.text, confirmPassword: confirmPasswordCntrl.text, cancelToken: cancelToken));
                                },
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), padding: EdgeInsets.all(12)),
                        ),
                        if (state.error != null) Text(state.error!),
                        TextButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    GoRouter.of(context).goNamed(Routing.login);
                                  },
                            child: Text('Sign-in instead'))
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  @override
  void dispose() {
    cancelToken.cancel("register cancelled");
    super.dispose();
  }
}
