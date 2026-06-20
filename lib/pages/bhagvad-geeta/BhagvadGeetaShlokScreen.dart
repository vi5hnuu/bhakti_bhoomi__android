import 'package:bhakti_bhoomi/models/bhagvadGeeta/BHagvadGeetaChapterModel.dart';
import 'package:bhakti_bhoomi/models/bhagvadGeeta/BHagvadGeetaChapterModel.dart';
import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/gold_progress.dart';
import 'package:bhakti_bhoomi/widgets/common/verse_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BhagvadGeetaShlokScreen extends StatefulWidget {
  final String title;
  final int chapterNo;

  const BhagvadGeetaShlokScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<BhagvadGeetaShlokScreen> createState() => _BhagvadGeetaShlokScreenState();
}

class _BhagvadGeetaShlokScreenState extends State<BhagvadGeetaShlokScreen> {
  int currentPage = 0;
  CancelToken? token;
  final PageController _controller = PageController(initialPage: 0);
  double fontSize = 22;

  @override
  void initState() {
    // Self-heal: ensure the chapter list is loaded even on direct entry
    // (deep link / restart). The bloc no-ops if chapters are already present.
    BlocProvider.of<BhagvadGeetaBloc>(context).add(const FetchBhagvadGeetaChapters());
    reloadCurrentShlok();
    super.initState();
  }

  /// Find the chapter by its number (not list position) to avoid off-by-one.
  BhagvadGeetaChapterModel? _chapter(BhagvadGeetaState state) {
    final chapters = state.bhagvadGeetaChapters;
    if (chapters == null) return null;
    for (final c in chapters) {
      if (c.chapterNumber == widget.chapterNo) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhagvadGeetaBloc, BhagvadGeetaState>(
      builder: (context, state) {
        final chapter = _chapter(state);
        // Guard: chapter list not ready yet → show loader / retry, never crash.
        if (chapter == null) {
          if (state.isError(forr: Httpstates.BHAGVAD_GEETA_CHAPTERS)) {
            return AppScaffold(
              title: widget.title,
              subtitle: 'अध्याय ${widget.chapterNo}',
              body: RetryAgain(
                onRetry: () => BlocProvider.of<BhagvadGeetaBloc>(context).add(const FetchBhagvadGeetaChapters()),
                error: state.getError(forr: Httpstates.BHAGVAD_GEETA_CHAPTERS)?.message ?? 'Could not load chapter',
              ),
            );
          }
          return AppScaffold(
            title: widget.title,
            subtitle: 'अध्याय ${widget.chapterNo}',
            body: const AppLoader(),
          );
        }

        final total = chapter.versesCount;
        return AppScaffold(
          title: 'Gita · Chapter ${widget.chapterNo}',
          subtitle: chapter.name,
          actions: [
            IconButton(onPressed: fontSize <= 14 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
            IconButton(onPressed: fontSize >= 34 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
          ],
          bottom: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: GoldLinearProgress(value: total > 0 ? (currentPage + 1) / total : 0),
          ),
          body: PageView.builder(
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: total,
            onPageChanged: (pageNo) => setState(() {
              currentPage = pageNo;
              _loadShlok(chapterNo: widget.chapterNo, shlokNo: pageNo + 1);
            }),
            itemBuilder: (context, index) {
              final shlok = state.getShlok(chapterNo: widget.chapterNo, shlokNo: index + 1);
              if (shlok == null) {
                if (state.isError(forr: Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO)) {
                  return RetryAgain(
                    onRetry: reloadCurrentShlok,
                    error: state.getError(forr: Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO)!.message,
                  );
                }
                return const AppLoader();
              }
              final contentId = BhagvadGeetaState.commentForId(chapterNo: widget.chapterNo, shlokNo: index + 1);
              return VersePage(
                verseLabel: 'श्लोक ${index + 1} / $total',
                text: shlok.shlok,
                fontSize: fontSize,
                contentId: contentId,
                shareText: '${shlok.shlok}\n\n— Bhagavad Gita ${widget.chapterNo}:${index + 1}\n\nRead on Bhakti Bhoomi',
                contentType: 'bhagavad_geeta',
              );
            },
          ),
        );
      },
    );
  }

  void reloadCurrentShlok() => _loadShlok(chapterNo: widget.chapterNo, shlokNo: currentPage + 1);

  void _loadShlok({required int chapterNo, required int shlokNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<BhagvadGeetaBloc>(context).add(FetchBhagvadShlokByChapterNoShlokNo(chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: token));
    final contentId = BhagvadGeetaState.commentForId(chapterNo: chapterNo, shlokNo: shlokNo);
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: contentId));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
