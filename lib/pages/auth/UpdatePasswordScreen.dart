import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/field_label.dart';
import 'package:bhakti_bhoomi/widgets/common/primary_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final formKey = GlobalKey<FormState>(debugLabel: 'updatePassword');
  final TextEditingController oldPasswordCntrl = TextEditingController();
  final TextEditingController newPasswordCntrl = TextEditingController();
  final TextEditingController confirmPasswordCntrl = TextEditingController();
  final CancelToken cancelToken = CancelToken();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        if (state.isError(forr: Httpstates.UPDATE_PASSWORD)) {
          NotificationService.showSnackbar(text: state.getError(forr: Httpstates.UPDATE_PASSWORD)!.message, color: Colors.red);
        }
        if (state.success) {
          NotificationService.showSnackbar(text: state.message ?? "Password updated successfully", color: Colors.green);
          GoRouter.of(context).pop();
        }
      },
      builder: (context, state) {
        final loading = state.isLoading(forr: Httpstates.UPDATE_PASSWORD);
        return AppScaffold(
          title: 'Update password',
          subtitle: 'पासवर्ड बदलें',
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FieldLabel('Current password'),
                  _PasswordField(controller: oldPasswordCntrl, validatorMsg: 'Please enter current password'),
                  const SizedBox(height: 16),
                  const FieldLabel('New password'),
                  _PasswordField(controller: newPasswordCntrl, validatorMsg: 'Please enter new password'),
                  const SizedBox(height: 16),
                  const FieldLabel('Confirm new password'),
                  _PasswordField(
                    controller: confirmPasswordCntrl,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Please confirm password';
                      if (v != newPasswordCntrl.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: 'Update password',
                    loading: loading,
                    onPressed: () {
                      if (formKey.currentState?.validate() == false) return;
                      BlocProvider.of<AuthBloc>(context).add(UpdatePasswordEvent(
                          oldPassword: oldPasswordCntrl.value.text,
                          newPassword: newPasswordCntrl.value.text,
                          confirmPassword: confirmPasswordCntrl.value.text,
                          cancelToken: cancelToken));
                    },
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
    cancelToken.cancel("update password cancelled");
    super.dispose();
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? validatorMsg;
  final String? Function(String?)? validator;
  const _PasswordField({required this.controller, this.validatorMsg, this.validator});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        hintText: '••••••••',
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textFaint),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      validator: widget.validator ?? (v) => (v == null || v.isEmpty) ? widget.validatorMsg : null,
    );
  }
}
