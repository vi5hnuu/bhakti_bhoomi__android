import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/gold_progress.dart';
import 'package:bhakti_bhoomi/widgets/common/verse_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MahabharatShlokScreen extends StatefulWidget {
  final String title;
  final int bookNo;
  final int chapterNo;
  const MahabharatShlokScreen({super.key, required this.title, required this.bookNo, required this.chapterNo});

  @override
  State<MahabharatShlokScreen> createState() => _MahabharatShlokScreenState();
}

class _MahabharatShlokScreenState extends State<MahabharatShlokScreen> {
  final PageController _controller = PageController(initialPage: 0);
  CancelToken? token;
  int currentPage = 0;
  double fontSize = 20;

  @override
  void initState() {
    BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatInfoEvent());
    loadCurrentShlok();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MahabharatBloc, MahabharatState>(
      builder: (context, state) {
        // totalVerses() throws if the book info is not loaded — guard first.
        if (state.allBooksInfo == null) {
          if (state.isError(forr: Httpstates.MAHABHARATA_INFO)) {
            return AppScaffold(
              title: widget.title,
              subtitle: 'पर्व ${widget.bookNo} · अध्याय ${widget.chapterNo}',
              body: RetryAgain(
                onRetry: () => BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatInfoEvent()),
                error: state.getError(forr: Httpstates.MAHABHARATA_INFO)?.message ?? 'Could not load',
              ),
            );
          }
          return AppScaffold(title: widget.title, subtitle: 'पर्व ${widget.bookNo} · अध्याय ${widget.chapterNo}', body: const AppLoader());
        }

        final total = state.totalVerses(bookNo: widget.bookNo, chapterNo: widget.chapterNo);
        return AppScaffold(
          title: 'Mahabharat · ${widget.bookNo}.${widget.chapterNo}',
          subtitle: 'महाभारत',
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
              loadShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: pageNo + 1);
            }),
            itemBuilder: (context, index) {
              final shlok = state.getShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: index + 1);
              if (shlok == null) {
                if (state.isError(forr: Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO)) {
                  return RetryAgain(onRetry: loadCurrentShlok, error: state.getError(forr: Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO)!.message);
                }
                return const AppLoader();
              }
              final contentId = MahabharatState.commentForId(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: index + 1);
              return VersePage(
                verseLabel: 'श्लोक ${index + 1} / $total',
                text: shlok.text,
                fontSize: fontSize,
                contentId: contentId,
                shareText: "${shlok.text}\n\n— Mahabharat Book ${widget.bookNo}, Chapter ${widget.chapterNo}:${index + 1}\n\nRead on Bhakti Bhoomi",
                contentType: 'mahabharat',
              );
            },
          ),
        );
      },
    );
  }

  loadCurrentShlok() => loadShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: currentPage + 1);

  void loadShlok({required int bookNo, required int chapterNo, required int shlokNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatShlokByShlokNo(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: MahabharatState.commentForId(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo)));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
