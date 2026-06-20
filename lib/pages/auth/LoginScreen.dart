import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/primary_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CancelToken cancelToken = CancelToken();
  final formKey = GlobalKey<FormState>(debugLabel: 'loginForm');
  final TextEditingController usernameEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscure = true;

  void _submit(AuthState state) {
    if (state.anyLoading(forr: [Httpstates.CUSTOM_LOGIN, Httpstates.GOOGLE_LOGIN])) return;
    if (!formKey.currentState!.validate()) return;
    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
        usernameEmail: usernameEmailController.text,
        password: passwordController.text,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        if (state.isError(forr: Httpstates.CUSTOM_LOGIN)) {
          NotificationService.showSnackbar(text: state.getError(forr: Httpstates.CUSTOM_LOGIN)!.message, color: Colors.red);
        }
        if (state.isAuthenticated) {
          NotificationService.showSnackbar(text: state.message ?? "Logged in successfully", color: Colors.green);
          context.replaceNamed(Routing.home.name);
        }
      },
      builder: (context, state) {
        final loading = state.isLoading(forr: Httpstates.CUSTOM_LOGIN);
        return AppScaffold(
          title: 'Sign in',
          subtitle: 'स्वागत है · welcome back',
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  // Devotional verse
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.surfaceAlt),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'सदृशं चेष्टते स्वस्याः प्रकृतेर्ज्ञानवानपि।',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 16, color: AppColors.ink, height: 1.5),
                        ),
                        const SizedBox(height: 6),
                        Text('— भगवद्गीता 3.33', style: AppTypography.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _Label('Username or Email'),
                  TextFormField(
                    controller: usernameEmailController,
                    decoration: const InputDecoration(hintText: 'name or name@email.com'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter username/email' : null,
                  ),
                  const SizedBox(height: 16),
                  _Label('Password'),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscure,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textFaint),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter password' : null,
                    onFieldSubmitted: (_) => _submit(state),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: loading ? null : () => context.goNamed(Routing.forgotPassword.name),
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(label: 'Log in', loading: loading, onPressed: () => _submit(state)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New here?", style: AppTypography.textTheme.bodyMedium),
                      TextButton(
                        onPressed: loading ? null : () => context.goNamed(Routing.register.name),
                        child: const Text('Create account'),
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: loading ? null : () => context.goNamed(Routing.verify.name),
                      child: Text('Verify account', style: AppTypography.textTheme.bodySmall!.copyWith(color: AppColors.textMuted)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("login cancelled");
    super.dispose();
  }
}

/// Small field label used across the auth forms.
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 2),
        child: Text(text, style: AppTypography.textTheme.labelMedium),
      );
}
