import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Design #09 — Profile & settings tab. Guest-aware: shows a sign-in prompt
/// when logged out, and the account + menu when authenticated.
class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state.userInfo;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Text('Profile', style: AppTypography.textTheme.displayMedium),
                Text('प्रोफ़ाइल · settings',
                    style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 14, color: AppColors.textMuted)),
                const SizedBox(height: 20),
                if (user != null)
                  AppCard(
                    onTap: () => context.pushNamed(Routing.profile.name),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.surfaceAlt,
                          foregroundImage: user.profileMeta?.secure_url != null
                              ? CachedNetworkImageProvider(user.profileMeta!.secure_url)
                              : null,
                          child: user.profileMeta?.secure_url == null
                              ? const Icon(Icons.person, color: AppColors.textFaint)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${user.firstName} ${user.lastName}', style: AppTypography.textTheme.titleMedium),
                              Text('@${user.username}', style: AppTypography.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
                      ],
                    ),
                  )
                else
                  AppCard(
                    child: Column(
                      children: [
                        const Icon(Icons.lock_outline_rounded, size: 40, color: AppColors.terracotta),
                        const SizedBox(height: 10),
                        Text('Sign in to Bhakti Bhoomi', style: AppTypography.textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text('Bookmark verses, like, and join satsang.',
                            textAlign: TextAlign.center, style: AppTypography.textTheme.bodySmall),
                        const SizedBox(height: 16),
                        PrimaryButton(label: 'Log in', onPressed: () => context.pushNamed(Routing.login.name)),
                        const SizedBox(height: 8),
                        TextButton(onPressed: () => context.pushNamed(Routing.register.name), child: const Text('Create account')),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                _MenuTile(icon: Icons.bookmark_outline_rounded, label: 'Bookmarks', onTap: () {
                  if (user != null) {
                    context.pushNamed(Routing.bookmarks.name);
                  } else {
                    context.pushNamed(Routing.login.name);
                  }
                }),
                if (state.isAdmin)
                  _MenuTile(icon: Icons.post_add_rounded, label: 'Create Post', onTap: () => context.pushNamed(Routing.createPost.name)),
                _MenuTile(icon: Icons.info_outline_rounded, label: 'About Us', onTap: () => context.pushNamed(Routing.aboutUs.name)),
                if (user != null)
                  _MenuTile(
                    icon: Icons.logout_rounded,
                    label: 'Log out',
                    danger: true,
                    onTap: () => context.read<AuthBloc>().add(const LogoutEvent()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  const _MenuTile({required this.icon, required this.label, required this.onTap, this.danger = false});

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.ink;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: danger ? AppColors.error : AppColors.terracotta, size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTypography.textTheme.titleSmall!.copyWith(color: color))),
            if (!danger) const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }
}
