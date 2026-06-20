import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/guruGranthSahib/guru_granth_sahib_bloc.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/language_dropdown.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class GuruGranthSahibRagaPartsScreen extends StatefulWidget {
  final String title;
  final int ragaNo;

  const GuruGranthSahibRagaPartsScreen({super.key, required this.ragaNo, required this.title});

  @override
  State<GuruGranthSahibRagaPartsScreen> createState() => _GuruGranthSahibRagaPartsScreenState();
}

class _GuruGranthSahibRagaPartsScreenState extends State<GuruGranthSahibRagaPartsScreen> {
  CancelToken cancelToken = CancelToken();
  int selectedPart = 1;
  double fontSize = 20;

  @override
  void initState() {
    BlocProvider.of<GuruGranthSahibBloc>(context).add(FetchGuruGranthSahibInfo());
    initRaga(ragaNo: widget.ragaNo, partNo: selectedPart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuruGranthSahibBloc, GuruGranthSahibState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final info = state.getInfo();
        if (info == null) {
          return AppScaffold(
            title: 'Guru Granth Sahib',
            subtitle: 'ਰਾਗ ${widget.ragaNo}',
            body: state.isError(forr: Httpstates.GURU_GRANTH_SAHIB_INFO)
                ? RetryAgain(
                    onRetry: () => BlocProvider.of<GuruGranthSahibBloc>(context).add(FetchGuruGranthSahibInfo()),
                    error: state.getError(forr: Httpstates.GURU_GRANTH_SAHIB_INFO)?.message ?? 'Could not load',
                  )
                : const AppLoader(),
          );
        }

        final ragaInfo = info.ragasInfo[widget.ragaNo - 1];
        final raga = state.getRaga(ragaNo: widget.ragaNo, partNo: selectedPart);
        final parts = {for (int i = 1; i <= ragaInfo.totalParts; i++) 'Part $i': '$i'};

        return AppScaffold(
          title: 'Raga ${widget.ragaNo}',
          subtitle: 'ਰਾਗ · Part $selectedPart',
          actions: [
            IconButton(onPressed: fontSize <= 14 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
            IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
          ],
          body: raga != null
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Row(
                        children: [
                          LanguageDropdown(
                            languages: parts,
                            value: '$selectedPart',
                            onChanged: (value) => setState(() {
                              selectedPart = int.parse(value!);
                              initRaga(ragaNo: widget.ragaNo, partNo: selectedPart);
                            }),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(raga.ragaName, style: AppTypography.textTheme.titleSmall, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                        itemCount: raga.text.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            raga.text[index],
                            style: TextStyle(fontFamily: AppScript.familyFor(raga.text[index]), fontSize: fontSize, height: 1.7, color: AppColors.ink),
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<LikeBloc, LikeState>(
                      builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                        builder: (ctx, bookmarkState) {
                          final contentId = GuruGranthSahibState.commentForId(ragaNo: widget.ragaNo, partNo: selectedPart);
                          final bookmarked = bookmarkState.isBookmarked(contentId);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: EngageActions(
                              isBookmarked: bookmarked,
                              isLiked: likeState.isLiked(contentId),
                              onBookmark: () => requireAuth(context, () {
                                if (bookmarked) {
                                  final bid = bookmarkState.bookmarkIdFor(contentId);
                                  if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                                } else {
                                  ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: 'guru_granth_sahib'));
                                }
                              }),
                              onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () => ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId))),
                              onComment: () => onComment(context: context, commentFormId: contentId),
                              onShare: () async {
                                final text = raga.text.take(3).join('\n');
                                final result = await Share.share("$text\n\n— Guru Granth Sahib, Raga ${widget.ragaNo} Part $selectedPart\n\nRead on Bhakti Bhoomi");
                                if (result.status == ShareResultStatus.success) {
                                  NotificationService.showSnackbar(text: "Shared successfully", color: Colors.green);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : state.isError(forr: Httpstates.GURU_GRANTH_SAHIB_RAGA)
                  ? RetryAgain(onRetry: () => initRaga(ragaNo: widget.ragaNo, partNo: selectedPart), error: state.getError(forr: Httpstates.GURU_GRANTH_SAHIB_RAGA)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initRaga({required int ragaNo, required int partNo}) {
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
    BlocProvider.of<GuruGranthSahibBloc>(context).add(FetchGuruGranthSahibRagaByRagaNoPartNo(ragaNo: ragaNo, partNo: partNo, cancelToken: cancelToken));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: GuruGranthSahibState.commentForId(ragaNo: ragaNo, partNo: partNo)));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
