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

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final CancelToken cancelToken = CancelToken();
  final formKey = GlobalKey<FormState>(debugLabel: 'verifyForm');
  final TextEditingController emailCntrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        if (state.success) {
          NotificationService.showSnackbar(text: state.message ?? "Verification email sent", color: Colors.green);
          context.goNamed(Routing.login.name);
        }
        if (state.isError(forr: Httpstates.REVERIFY)) {
          NotificationService.showSnackbar(text: state.message ?? "Verification failed", color: Colors.red);
        }
      },
      builder: (context, state) {
        final loading = state.isLoading(forr: Httpstates.REVERIFY);
        return AppScaffold(
          title: 'Verify email',
          subtitle: 'ईमेल सत्यापन',
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.surface,
                      child: const Icon(Icons.mark_email_unread_outlined, size: 34, color: AppColors.terracotta),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter your email to resend a verification link.',
                    textAlign: TextAlign.center,
                    style: AppTypography.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  const FieldLabel('Email'),
                  TextFormField(
                    controller: emailCntrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'name@gmail.com'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter email' : null,
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: 'Send verification email',
                    loading: loading,
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      BlocProvider.of<AuthBloc>(context).add(ReVerifyEvent(email: emailCntrl.value.text, cancelToken: cancelToken));
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
    cancelToken.cancel("verify cancelled");
    super.dispose();
  }
}
