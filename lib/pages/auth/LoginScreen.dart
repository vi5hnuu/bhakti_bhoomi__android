import 'dart:async';

import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/CustomElevatedButton.dart';
import 'package:bhakti_bhoomi/widgets/CustomInputField.dart';
import 'package:bhakti_bhoomi/widgets/CustomTextButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../widgets/notificationSnackbar.dart';

List<String> scopes=[
  "https://www.googleapis.com/auth/userinfo.email",
  "https://www.googleapis.com/auth/userinfo.profile",
  "openid"
];
GoogleSignIn _googleSignIn = GoogleSignIn(
  serverClientId: dotenv.env["GOOGLE_CLIENT_ID"],
  scopes: scopes,
  signInOption: SignInOption.standard,
  forceCodeForRefreshToken: true,
);

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
        if (state.isError(forr: Httpstates.LOGIN)) {
          ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: state.getError(forr: Httpstates.LOGIN)!, color: Colors.red));
        }
        if (state.isAuthtenticated) {
          ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: state.message ?? "logged in successfully", color: Colors.green));
          context.replaceNamed(Routing.home);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
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
                child: Form(
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
                      state.isLoading(forr: Httpstates.LOGIN)
                          ? SpinKitThreeBounce(
                              color: Theme.of(context).primaryColor,
                              size: 32,
                            )
                          : CustomElevatedButton(
                              onPressed: state.isLoading(forr: Httpstates.LOGIN)
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
                              child: const Text(
                                'Log-in',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              )),
                      const SizedBox(height: 14),
                      CustomTextButton(onPressed: state.isLoading(forr: Httpstates.LOGIN) ? null : () => context.goNamed(Routing.register), child: const Text('Sign-up instead')),
                      CustomTextButton(onPressed: state.isLoading(forr: Httpstates.LOGIN) ? null : () => context.goNamed(Routing.forgotPassword), child: const Text('forgot-password')),
                      CustomTextButton(
                          onPressed: state.isLoading(forr: Httpstates.LOGIN)
                              ? null
                              : () {
                                  GoRouter.of(context).goNamed(Routing.verify);
                                },
                          child: const Text('verify account'))
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


///////////////////////////

class _SignInDemoState extends State<LoginScreen> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
          print("current user changed ${_currentUser.toString()}");
// #docregion CanAccessScopes
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
// #enddocregion CanAccessScopes

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      // if (isAuthorized) {
      //   unawaited(_handleGetContact(account));
      // }
    });

    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    _googleSignIn.signInSilently();
  }

  // #docregion SignIn
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print("got an error ${error}");
    }
  }
  // #enddocregion SignIn

  // Prompts the user to authorize `scopes`.
  //
  // This action is **required** in platforms that don't perform Authentication
  // and Authorization at the same time (like the web).
  //
  // On the web, this must be called from an user interaction (button click).
  // #docregion RequestScopes
  Future<void> _handleAuthorizeScopes() async {
    final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
    // #enddocregion RequestScopes
    setState(() {
      _isAuthorized = isAuthorized;
    });
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      // The user is Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          if (!_isAuthorized) ...<Widget>[
            // The user has NOT Authorized all required scopes.
            // (Mobile users may never see this button!)
            const Text('Additional permissions needed to read your contacts.'),
            ElevatedButton(
              onPressed: _handleAuthorizeScopes,
              child: const Text('REQUEST PERMISSIONS'),
            ),
          ],
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
      // The user is NOT Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          // This method is used to separate mobile from web code with conditional exports.
          // See: src/sign_in_button.dart
          buildSignInButton(
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ClientId');
    print(dotenv.env["GOOGLE_CLIENT_ID"]);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}


typedef HandleSignInFn = Future<void> Function();
/// Renders a SIGN IN button that calls `handleSignIn` onclick.
Widget buildSignInButton({HandleSignInFn? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: const Text('SIGN IN'),
  );
}
