import 'package:bhakti_bhoomi/models/chanakyaNeeti/ChanakyaNeetiChapterInfoModel.dart';
import 'package:bhakti_bhoomi/state/chanakyaNeeti/chanakya_neeti_bloc.dart';
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

class ChanakyaNeetiShlokScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const ChanakyaNeetiShlokScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<ChanakyaNeetiShlokScreen> createState() => _ChanakyaNeetiShlokScreenState();
}

class _ChanakyaNeetiShlokScreenState extends State<ChanakyaNeetiShlokScreen> {
  final PageController _controller = PageController(initialPage: 0);
  CancelToken? token;
  int currentPage = 0;
  double fontSize = 20;

  @override
  void initState() {
    BlocProvider.of<ChanakyaNeetiBloc>(context).add(const FetchChanakyaNeetiChaptersInfo());
    loadCurrentVerse();
    super.initState();
  }

  ChanakyaNeetiChapterInfoModel? _chapter(ChanakyaNeetiState state) {
    final chapters = state.allChaptersInfo;
    if (chapters == null) return null;
    for (final c in chapters) {
      if (c.chapterNo == widget.chapterNo) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChanakyaNeetiBloc, ChanakyaNeetiState>(
      builder: (context, state) {
        final chapter = _chapter(state);
        if (chapter == null) {
          if (state.isError(forr: Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO)) {
            return AppScaffold(
              title: widget.title,
              subtitle: 'अध्याय ${widget.chapterNo}',
              body: RetryAgain(
                onRetry: () => BlocProvider.of<ChanakyaNeetiBloc>(context).add(const FetchChanakyaNeetiChaptersInfo()),
                error: state.getError(forr: Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO)?.message ?? 'Could not load chapter',
              ),
            );
          }
          return AppScaffold(title: widget.title, subtitle: 'अध्याय ${widget.chapterNo}', body: const AppLoader());
        }

        final total = chapter.versesCount;
        return AppScaffold(
          title: 'Chanakya Neeti · Ch ${widget.chapterNo}',
          subtitle: 'चाणक्य नीति',
          actions: [
            IconButton(onPressed: fontSize <= 14 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
            IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
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
              _loadVerse(chapterNo: widget.chapterNo, verseNo: pageNo + 1);
            }),
            itemBuilder: (context, index) {
              final verse = state.getVerse(chapterNo: widget.chapterNo, verseNo: index + 1);
              if (verse == null) {
                if (state.isError(forr: Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO)) {
                  return RetryAgain(
                    onRetry: loadCurrentVerse,
                    error: state.getError(forr: Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO)!.message,
                  );
                }
                return const AppLoader();
              }
              final contentId = ChanakyaNeetiState.commentForId(chapterNo: widget.chapterNo, verseNo: index + 1);
              return VersePage(
                verseLabel: 'श्लोक ${index + 1} / $total',
                text: verse.translations['en']!,
                fontSize: fontSize,
                contentId: contentId,
                shareText: "${verse.translations['en']!}\n\n— Chanakya Neeti ${widget.chapterNo}:${index + 1}\n\nRead on Bhakti Bhoomi",
                contentType: 'chanakya_neeti',
              );
            },
          ),
        );
      },
    );
  }

  void loadCurrentVerse() => _loadVerse(chapterNo: widget.chapterNo, verseNo: currentPage + 1);

  void _loadVerse({required int chapterNo, required int verseNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<ChanakyaNeetiBloc>(context).add(FetchChanakyaNeetiVerseByChapterNoVerseNo(chapterNo: chapterNo, verseNo: verseNo, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: ChanakyaNeetiState.commentForId(chapterNo: chapterNo, verseNo: verseNo)));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
