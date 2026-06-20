import 'dart:io';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/primary_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CancelToken infoToken = CancelToken();
  CancelToken profileMetaToken = CancelToken();
  CancelToken deleteMeToken = CancelToken();

  final ImagePicker imagePicker = ImagePicker();
  XFile? profileImage;
  XFile? coverImage;

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

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (!state.isAuthenticated) {
          router.goNamed(Routing.login.name);
        }
        if (state.anyError(forr: [Httpstates.LOG_OUT, Httpstates.UPDATE_PROFILE_META, Httpstates.DELETE_ME])) {
          NotificationService.showSnackbar(
              text: state.getAnyError(forr: [Httpstates.LOG_OUT, Httpstates.UPDATE_PROFILE_META, Httpstates.DELETE_ME])!.message,
              color: Colors.red);
        }
      },
      buildWhen: (previous, current) => previous != current && current.userInfo != null,
      builder: (context, state) {
        final user = state.userInfo!;
        final isAnyLoading = state.anyLoading(forr: [
          Httpstates.USER_INFO,
          Httpstates.LOG_OUT,
          Httpstates.DELETE_ME,
          Httpstates.UPDATE_PROFILE_META,
        ]);
        final hasImageChange = profileImage != null || coverImage != null;

        return AppScaffold(
          title: 'Profile',
          subtitle: 'प्रोफ़ाइल',
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cover + avatar
                SizedBox(
                  height: 196,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _coverImage(user),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: _editBadge(onTap: isAnyLoading ? null : _pickCover),
                      ),
                      Positioned(
                        bottom: -36,
                        left: 0,
                        right: 0,
                        child: Center(child: _avatar(user)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 44),
                Text('${user.firstName} ${user.lastName}',
                    textAlign: TextAlign.center, style: AppTypography.textTheme.headlineMedium),
                Text('@${user.username}', textAlign: TextAlign.center, style: AppTypography.textTheme.bodySmall),
                const SizedBox(height: 20),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _infoRow('Email', user.email),
                      const Divider(height: 1),
                      _infoRow('Active since', DateFormat("dd MMM yyyy").format(user.createdAt)),
                    ],
                  ),
                ),
                if (hasImageChange) ...[
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Save changes',
                    loading: state.isLoading(forr: Httpstates.UPDATE_PROFILE_META),
                    onPressed: isAnyLoading ? null : saveChanges,
                  ),
                ],
                const SizedBox(height: 20),
                _settingTile(Icons.lock_outline_rounded, 'Update password',
                    onTap: isAnyLoading ? null : () => router.pushNamed(Routing.updatePassword.name)),
                _settingTile(Icons.logout_rounded, 'Log out',
                    danger: true,
                    loading: state.isLoading(forr: Httpstates.LOG_OUT),
                    onTap: isAnyLoading ? null : () => BlocProvider.of<AuthBloc>(context).add(LogoutEvent(cancelToken: deleteMeToken))),
                const SizedBox(height: 12),
                _settingTile(Icons.delete_forever_rounded, 'Delete account',
                    danger: true,
                    loading: state.isLoading(forr: Httpstates.DELETE_ME),
                    onTap: isAnyLoading ? null : deleteAccountInit),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _coverImage(dynamic user) {
    final ImageProvider provider = coverImage != null
        ? FileImage(File(coverImage!.path))
        : CachedNetworkImageProvider(user.posterMeta!.secure_url) as ImageProvider;
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceAlt),
        image: DecorationImage(image: provider, fit: BoxFit.cover, alignment: Alignment.topCenter),
      ),
    );
  }

  Widget _avatar(dynamic user) {
    final ImageProvider provider = profileImage != null
        ? FileImage(File(profileImage!.path))
        : CachedNetworkImageProvider(user.profileMeta!.secure_url) as ImageProvider;
    return GestureDetector(
      onTap: _pickProfile,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.page),
            child: CircleAvatar(radius: 44, backgroundImage: provider, backgroundColor: AppColors.surfaceAlt),
          ),
          _editBadge(onTap: _pickProfile),
        ],
      ),
    );
  }

  Widget _editBadge({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.terracotta),
        child: const Icon(Icons.camera_alt_rounded, size: 15, color: AppColors.onAccent),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(label, style: AppTypography.textTheme.bodySmall),
          const Spacer(),
          Text(value, style: AppTypography.textTheme.titleSmall),
        ],
      ),
    );
  }

  Widget _settingTile(IconData icon, String label, {VoidCallback? onTap, bool danger = false, bool loading = false}) {
    final color = danger ? AppColors.error : AppColors.ink;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: danger ? AppColors.error : AppColors.terracotta),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTypography.textTheme.titleSmall!.copyWith(color: color))),
            if (loading)
              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            else if (!danger)
              const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }

  saveChanges() async {
    if (profileImage == null && coverImage == null) return;
    BlocProvider.of<AuthBloc>(context).add(UpdateProfileMeta(
        profileImage: profileImage != null ? await MultipartFile.fromFile(profileImage!.path) : null,
        posterImage: coverImage != null ? await MultipartFile.fromFile(coverImage!.path) : null,
        cancelToken: profileMetaToken));
  }

  deleteAccountInit() {
    showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => Dialog(
        backgroundColor: AppColors.page,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 44),
              const SizedBox(height: 8),
              Text('This action is irreversible', textAlign: TextAlign.center, style: AppTypography.textTheme.headlineSmall!.copyWith(color: AppColors.error)),
              const SizedBox(height: 6),
              Text('Are you sure you want to delete your account?', textAlign: TextAlign.center, style: AppTypography.textTheme.bodyMedium),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border)),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(DeleteMeEvent(cancelToken: deleteMeToken));
                        Navigator.pop(ctx);
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    infoToken.cancel("cancelled");
    profileMetaToken.cancel("cancelled");
    deleteMeToken.cancel("cancelled");
    super.dispose();
  }
}
