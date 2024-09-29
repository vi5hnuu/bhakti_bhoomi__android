import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/CustomElevatedButton.dart';
import 'package:bhakti_bhoomi/widgets/CustomInputField.dart';
import 'package:bhakti_bhoomi/widgets/CustomTextButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

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
  final List<String> quoteHindi= ["तू करता वही है जो तू चाहता है,","पर होता वही है जो मैं चाहता हूँ।","तू वही कर जो मैं चाहता हूँ,","फिर होगा वही जो तू चाहता है।","\nश्रीकृष्ण"];


  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    // debugPaintSizeEnabled = true;
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        if (state.isError(forr: Httpstates.CUSTOM_LOGIN)) {
          NotificationService.showSnackbar(text: state.getError(forr: Httpstates.CUSTOM_LOGIN)!.message, color: Colors.red);
        }
        if (state.isAuthtenticated) {
          NotificationService.showSnackbar(text: state.message ?? "logged in successfully", color: Colors.green);
          context.replaceNamed(Routing.home.name);
        }
      },
      builder: (context, state) => Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: theme.primaryColor,
          elevation: 1,
          shadowColor: Colors.grey,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      constraints: const BoxConstraints(minHeight: 150,maxHeight: 300,minWidth: double.infinity),
                      child: DefaultTextStyle(
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'Kalam',
                            fontWeight: FontWeight.normal,
                            height: 1,
                            color: theme.primaryColor
                        ),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          totalRepeatCount: 2,
                          pause: const Duration(seconds: 5),
                          animatedTexts: [
                            TypewriterAnimatedText(curve: Curves.fastOutSlowIn,quoteHindi.join('\n'),textAlign: TextAlign.center,speed: const Duration(milliseconds: 100)),
                          ],
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              "Spirtual Shakti",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: "PermanentMarker", fontSize: 32, color: theme.primaryColor),
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
                          CustomElevatedButton(
                                  onPressed: state.anyLoading(forr: [Httpstates.CUSTOM_LOGIN,Httpstates.GOOGLE_LOGIN])
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
                                        },
                                  child: Row(mainAxisSize: MainAxisSize.min,children: [
                                    const Text(
                                      'Log-in',
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                    if(state.isLoading(forr: Httpstates.CUSTOM_LOGIN)) ...[const SizedBox(width: 11),const SpinKitRing(
                                      color: Colors.white,
                                      size: 18,
                                      lineWidth: 2,
                                    )]
                                  ],)),
                          const SizedBox(height: 14),
                          CustomTextButton(onPressed: state.isLoading(forr: Httpstates.CUSTOM_LOGIN) ? null : () => context.goNamed(Routing.register.name), child: const Text('Sign-up instead')),
                          CustomTextButton(onPressed: state.isLoading(forr: Httpstates.CUSTOM_LOGIN) ? null : () => context.goNamed(Routing.forgotPassword.name), child: const Text('forgot-password')),
                          CustomTextButton(
                              onPressed: state.isLoading(forr: Httpstates.CUSTOM_LOGIN)
                                  ? null
                                  : () {
                                      GoRouter.of(context).goNamed(Routing.verify.name);
                                    },
                              child: const Text('verify account'))
                        ],
                      ),
                    ),
                  ],
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

