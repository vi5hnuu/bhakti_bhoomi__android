import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/field_label.dart';
import 'package:bhakti_bhoomi/widgets/common/otp_input.dart';
import 'package:bhakti_bhoomi/widgets/common/primary_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  final String usernameEmail;
  const OtpScreen({super.key, required this.usernameEmail});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final formKey = GlobalKey<FormState>(debugLabel: 'otpForm');
  final TextEditingController passwordCntrl = TextEditingController();
  final TextEditingController confirmPasswordCntrl = TextEditingController();
  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _otpControllers;
  final CancelToken cancelToken = CancelToken();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (_) => FocusNode());
    _otpControllers = List.generate(6, (_) => TextEditingController());
  }

  void _submit(AuthState state) {
    if (state.isLoading(forr: Httpstates.RESET_PASSWORD)) return;
    final otpComplete = _otpControllers.every((c) => c.text.isNotEmpty);
    if (formKey.currentState?.validate() == false || !otpComplete) {
      if (!otpComplete) NotificationService.showSnackbar(text: 'Please enter the 6-digit code', color: Colors.red);
      return;
    }
    BlocProvider.of<AuthBloc>(context).add(ResetPasswordEvent(
        usernameEmail: widget.usernameEmail,
        otp: _otpControllers.map((c) => c.text).join(''),
        password: passwordCntrl.text,
        confirmPassword: confirmPasswordCntrl.text,
        cancelToken: cancelToken));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        if (state.isError(forr: Httpstates.RESET_PASSWORD)) {
          NotificationService.showSnackbar(text: state.getError(forr: Httpstates.RESET_PASSWORD)!.message, color: Colors.red);
        }
        if (state.success) {
          NotificationService.showSnackbar(text: state.message ?? "Password updated successfully", color: Colors.green);
          GoRouter.of(context).goNamed(Routing.login.name);
        }
      },
      builder: (context, state) {
        final loading = state.isLoading(forr: Httpstates.RESET_PASSWORD);
        return AppScaffold(
          title: 'Reset password',
          subtitle: 'नया पासवर्ड',
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('We sent a 6-digit code to', textAlign: TextAlign.center, style: AppTypography.textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(widget.usernameEmail, textAlign: TextAlign.center, style: AppTypography.textTheme.titleSmall),
                  const SizedBox(height: 20),
                  OtpInput(controllers: _otpControllers, focusNodes: _focusNodes),
                  const SizedBox(height: 24),
                  const FieldLabel('New password'),
                  TextFormField(
                    controller: passwordCntrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textFaint),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter a new password' : null,
                  ),
                  const SizedBox(height: 16),
                  const FieldLabel('Confirm password'),
                  TextFormField(
                    controller: confirmPasswordCntrl,
                    obscureText: _obscure,
                    decoration: const InputDecoration(hintText: '••••••••'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Please confirm your password';
                      if (v != passwordCntrl.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(label: 'Update password', loading: loading, onPressed: () => _submit(state)),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: loading ? null : () => context.goNamed(Routing.login.name),
                      child: const Text('Back to sign in'),
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
    cancelToken.cancel("reset cancelled");
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final cntrl in _otpControllers) {
      cntrl.dispose();
    }
    passwordCntrl.dispose();
    confirmPasswordCntrl.dispose();
    super.dispose();
  }
}
