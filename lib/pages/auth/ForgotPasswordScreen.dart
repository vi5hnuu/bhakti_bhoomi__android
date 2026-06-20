import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/field_label.dart';
import 'package:bhakti_bhoomi/widgets/common/primary_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final CancelToken cancelToken = CancelToken();
  final formKey = GlobalKey<FormState>(debugLabel: 'forgotForm');
  final TextEditingController usernameEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        if (state.isError(forr: Httpstates.FORGOT_PASSWORD)) {
          NotificationService.showSnackbar(text: state.getError(forr: Httpstates.FORGOT_PASSWORD)!.message, color: Colors.red);
        }
        if (state.success) {
          NotificationService.showSnackbar(text: state.message!, color: Colors.green);
          GoRouter.of(context).pushReplacementNamed(Routing.otp.name, pathParameters: {'usernameEmail': usernameEmailController.text});
        }
      },
      builder: (context, state) {
        final loading = state.isLoading(forr: Httpstates.FORGOT_PASSWORD);
        return AppScaffold(
          title: 'Forgot password',
          subtitle: 'पासवर्ड भूल गए',
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.lock_reset_rounded, size: 56, color: AppColors.terracotta),
                  const SizedBox(height: 12),
                  Text(
                    "Enter your username or email and we'll send a 6-digit reset code.",
                    textAlign: TextAlign.center,
                    style: AppTypography.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                  const FieldLabel('Username or Email'),
                  TextFormField(
                    controller: usernameEmailController,
                    decoration: const InputDecoration(hintText: 'name or name@gmail.com'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter username/email' : null,
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: 'Send reset code',
                    loading: loading,
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      BlocProvider.of<AuthBloc>(context).add(ForgotPasswordEvent(usernameEmail: usernameEmailController.text, cancelToken: cancelToken));
                    },
                  ),
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
    cancelToken.cancel("forgot cancelled");
    super.dispose();
  }
}
