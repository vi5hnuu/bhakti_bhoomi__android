import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';

class MahabharatShlokScreen extends StatefulWidget {
  final String title;
  final int bookNo;
  final int chapterNo;
  const MahabharatShlokScreen({super.key, required this.title, required this.bookNo, required this.chapterNo});

  @override
  State<MahabharatShlokScreen> createState() => _MahabharatShlokScreenState();
}

class _MahabharatShlokScreenState extends State<MahabharatShlokScreen> {
  final pageStorageKey = const PageStorageKey('mahabharat_shlok_screen');
  final PageController _controller = PageController(initialPage: 0);
  int currentPage = 0;
  CancelToken? token;
  double fontSize = 16;

  @override
  initState() {
    loadCurrentShlok();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MahabharatBloc, MahabharatState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Mahabharat | Book No - ${widget.bookNo} | Chapter No ${widget.chapterNo}', style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(onPressed: fontSize <= 12 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
              IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(3),
              child: LinearProgressIndicator(
                value: state.totalVerses(bookNo: widget.bookNo, chapterNo: widget.chapterNo) > 0
                    ? (currentPage + 1) / state.totalVerses(bookNo: widget.bookNo, chapterNo: widget.chapterNo)
                    : 0,
                backgroundColor: Colors.white24,
                color: Colors.white,
              ),
            ),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.totalVerses(bookNo: widget.bookNo, chapterNo: widget.chapterNo),
            itemBuilder: (context, index) {
              final shlok = state.getShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: index + 1);
              return Center(
                child: shlok != null
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.all(25),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(shlok.text, style: TextStyle(fontSize: fontSize))],
                            ),
                            Positioned(
                              bottom: 45,
                              right: 15,
                              child: BlocBuilder<LikeBloc, LikeState>(
                                builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                                builder: (ctx, bookmarkState) {
                                  final contentId = MahabharatState.commentForId(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: index + 1);
                                  final bookmarked = bookmarkState.isBookmarked(contentId);
                                  return EngageActions(
                                    isBookmarked: bookmarked,
                                    isLiked: likeState.isLiked(contentId),
                                    onBookmark: () => requireAuth(context, () {
                                      if (bookmarked) {
                                        final bid = bookmarkState.bookmarkIdFor(contentId);
                                        if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                                      } else {
                                        ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: 'mahabharat'));
                                      }
                                    }),
                                    onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () {
                                      ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId));
                                    }),
                                    onShare: () async {
                                      final result = await Share.share("${shlok.text}\n\n— Mahabharat Book ${widget.bookNo}, Chapter ${widget.chapterNo}:${index + 1}\n\nRead on Bhakti Bhoomi");
                                      if (result.status == ShareResultStatus.success) {
                                        NotificationService.showSnackbar(text: "Shlok shared successfully", color: Colors.green);
                                      }
                                    },
                                    onComment: () => onComment(context: context, commentFormId: contentId),
                                  );
                                },
                              )),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: IconButton(onPressed: () => this._showNotImplementedMessage(), icon: const Icon(Icons.report_problem_outlined, size: 24)),
                            )
                          ],
                        ),
                      )
                    : state.isError(forr: Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO)
                        ? Center(child: RetryAgain(onRetry: loadCurrentShlok,error: state.getError(forr: Httpstates.MAHABHARATA_SHLOK_BY_SHLOKNO)!.message))
                        : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor)),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
              if (!mounted) return;
              currentPage=pageNo;
              loadShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: pageNo + 1);
            }),
          )),
    );
  }

  loadCurrentShlok(){
    loadShlok(bookNo: widget.bookNo, chapterNo: widget.chapterNo, shlokNo: currentPage+1);
  }

  void loadShlok({required int bookNo, required int chapterNo, required int shlokNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatShlokByShlokNo(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: MahabharatState.commentForId(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo)));
  }

  _showNotImplementedMessage() {
    NotificationService.showSnackbar(text: "Feature will available in next update...", color: Colors.orange);
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
