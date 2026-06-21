import 'package:bhakti_bhoomi/services/apis/PostApi.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:bhakti_bhoomi/pages/community/CreatePostSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

/// Design #07 — Sangha / Community feed (posts). Likes & comments reuse the
/// generic engagement APIs (contentType=post).
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    _future = _load();
    super.initState();
  }

  Future<List<dynamic>> _load() async {
    final posts = await PostApi().feed();
    for (final p in posts) {
      context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: p['id']));
    }
    return posts;
  }

  void _refresh() => setState(() => _future = _load());

  Future<void> _compose() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CreatePostSheet(),
    );
    if (created == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.terracotta,
        foregroundColor: AppColors.onAccent,
        onPressed: () => requireAuth(context, _compose),
        child: const Icon(Icons.edit_outlined),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sangha', style: AppTypography.textTheme.displayMedium),
                  Text('सत्संग · community', style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 14, color: AppColors.textMuted)),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) return const AppLoader();
                  if (snap.hasError) return RetryAgain(onRetry: _refresh, error: 'Could not load the feed');
                  final posts = snap.data ?? [];
                  if (posts.isEmpty) {
                    return const EmptyState(icon: Icons.groups_rounded, message: 'No posts yet.\nBe the first to share with the sangha.');
                  }
                  return RefreshIndicator(
                    onRefresh: () async => _refresh(),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                      itemCount: posts.length,
                      itemBuilder: (context, i) => _PostCard(post: posts[i] as Map),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final id = post['id'] as String;
    final img = post['imageUrl'] as String?;
    final avatar = post['profileImageUrl'] as String?;
    final created = DateTime.tryParse('${post['createdAt']}');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.surfaceAlt,
                  foregroundImage: avatar != null ? CachedNetworkImageProvider(avatar) : null,
                  child: avatar == null ? const Icon(Icons.person, size: 18, color: AppColors.textFaint) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${post['displayName'] ?? post['username']}', style: AppTypography.textTheme.titleSmall),
                      Text('@${post['username']}${created != null ? ' · ${DateFormat('d MMM').format(created)}' : ''}', style: AppTypography.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('${post['content'] ?? ''}', style: AppTypography.textTheme.bodyLarge),
            if (img != null) ...[
              const SizedBox(height: 12),
              ClipRRect(borderRadius: BorderRadius.circular(14), child: CachedNetworkImage(imageUrl: img, fit: BoxFit.cover)),
            ],
            const SizedBox(height: 8),
            BlocBuilder<LikeBloc, LikeState>(
              builder: (context, likeState) => Row(
                children: [
                  _action(
                    likeState.isLiked(id) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: likeState.isLiked(id) ? AppColors.terracotta : AppColors.textMuted,
                    onTap: likeState.isPending(id) ? null : () => requireAuth(context, () => context.read<LikeBloc>().add(ToggleLikeEvent(contentId: id))),
                  ),
                  _action(Icons.mode_comment_outlined, onTap: () => onComment(context: context, commentFormId: id)),
                  _action(Icons.share_outlined, onTap: () async {
                    final r = await Share.share('${post['content']}\n\n— shared from Bhakti Bhoomi Sangha');
                    if (r.status == ShareResultStatus.success) NotificationService.showSnackbar(text: 'Shared', color: Colors.green);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(IconData icon, {VoidCallback? onTap, Color color = AppColors.textMuted}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(onPressed: onTap, icon: Icon(icon, color: color, size: 22)),
    );
  }
}
