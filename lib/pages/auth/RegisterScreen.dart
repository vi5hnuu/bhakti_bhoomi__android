import 'dart:io';

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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>(debugLabel: 'registerForm');
  final ImagePicker imagePicker = ImagePicker();
  XFile? profileImage;
  XFile? coverImage;

  final _defaultCoverImagePath = "assets/images/ram_poster_sm.jpg";
  final _defaultProfileImagePath = "assets/images/ram_dp_sm.jpg";
  final TextEditingController firstNameCntrl = TextEditingController();
  final TextEditingController lastNameCntrl = TextEditingController();
  final TextEditingController usernameControllerCntrl = TextEditingController();
  final TextEditingController emailCntrl = TextEditingController();
  final TextEditingController passwordCntrl = TextEditingController();
  final CancelToken cancelToken = CancelToken();
  bool _obscure = true;

  Future<void> _pickProfile() async {
    final picked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (!mounted || picked == null) return;
    setState(() => profileImage = picked);
  }

  Future<void> _pickCover() async {
    final picked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (!mounted || picked == null) return;
    setState(() => coverImage = picked);
  }

  Future<void> _submit() async {
    if (formKey.currentState?.validate() == false) return;
    BlocProvider.of<AuthBloc>(context).add(RegisterEvent(
        profilePic: (profileImage != null
            ? await MultipartFile.fromFile(profileImage!.path)
            : await _getDefaultImage(assetPath: _defaultProfileImagePath, filename: 'profile.png')),
        posterPic: (coverImage != null
            ? await MultipartFile.fromFile(coverImage!.path)
            : await _getDefaultImage(assetPath: _defaultCoverImagePath, filename: 'cover.png')),
        firstName: firstNameCntrl.text,
        lastName: lastNameCntrl.text,
        username: usernameControllerCntrl.text,
        email: emailCntrl.text,
        password: passwordCntrl.text,
        cancelToken: cancelToken));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state.success) {
          NotificationService.showSnackbar(text: state.message ?? "Registered successfully");
          GoRouter.of(context).goNamed(Routing.login.name);
        }
      },
      builder: (context, state) {
        final loading = state.isLoading(forr: Httpstates.REGISTER);
        return AppScaffold(
          title: 'Create account',
          subtitle: 'खाता बनाएँ',
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile photo picker
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickProfile,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 104,
                                height: 104,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surface,
                                  border: Border.all(color: AppColors.gold, width: 2),
                                  image: profileImage != null
                                      ? DecorationImage(image: FileImage(File(profileImage!.path)), fit: BoxFit.cover)
                                      : null,
                                ),
                                child: profileImage == null
                                    ? const Icon(Icons.person_outline_rounded, size: 40, color: AppColors.goldDeep)
                                    : null,
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.terracotta),
                                child: const Icon(Icons.add, size: 16, color: AppColors.onAccent),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Add a profile photo', style: AppTypography.textTheme.bodySmall),
                        TextButton(
                          onPressed: _pickCover,
                          child: Text(coverImage == null ? 'Add a cover photo (optional)' : 'Cover photo added ✓'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel('First name'),
                            TextFormField(
                              controller: firstNameCntrl,
                              decoration: const InputDecoration(hintText: 'Aarav'),
                              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel('Last name'),
                            TextFormField(
                              controller: lastNameCntrl,
                              decoration: const InputDecoration(hintText: 'Sharma'),
                              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const FieldLabel('Username'),
                  TextFormField(
                    controller: usernameControllerCntrl,
                    decoration: const InputDecoration(hintText: 'aarav_s'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter username' : null,
                  ),
                  const SizedBox(height: 16),
                  const FieldLabel('Email'),
                  TextFormField(
                    controller: emailCntrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'name@gmail.com'),
                    validator: (v) => (v == null || !v.contains("@gmail.com")) ? 'Please enter a valid Gmail address' : null,
                  ),
                  const SizedBox(height: 16),
                  const FieldLabel('Password'),
                  TextFormField(
                    controller: passwordCntrl,
                    obscureText: _obscure,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textFaint),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter a password' : null,
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(label: 'Create account', loading: loading, onPressed: _submit),
                  if (state.isError(forr: Httpstates.REGISTER))
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(state.getError(forr: Httpstates.REGISTER)!.message,
                          textAlign: TextAlign.center, style: const TextStyle(color: AppColors.error)),
                    ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: loading ? null : () => context.goNamed(Routing.login.name),
                      child: const Text('Already have an account? Sign in'),
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

  Future<MultipartFile> _getDefaultImage({required String assetPath, required String filename}) async {
    final bytes = await rootBundle.load(assetPath);
    return MultipartFile.fromBytes(bytes.buffer.asUint8List(), filename: filename);
  }

  @override
  void dispose() {
    cancelToken.cancel("register cancelled");
    super.dispose();
  }
}
