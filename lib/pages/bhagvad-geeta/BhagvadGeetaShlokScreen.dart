import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
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

class BhagvadGeetaShlokScreen extends StatefulWidget {
  final String title;
  final int chapterNo;

  const BhagvadGeetaShlokScreen(
      {super.key, required this.title, required this.chapterNo});

  @override
  State<BhagvadGeetaShlokScreen> createState() =>
      _BhagvadGeetaShlokScreenState();
}

class _BhagvadGeetaShlokScreenState extends State<BhagvadGeetaShlokScreen> {
  final pageStorageKey = const PageStorageKey('bhagvadGeeta_shlok_screen');
  int currentPage = 0;
  CancelToken? token;
  final PageController _controller = PageController(initialPage: 0);
  double fontSize = 16;

  @override
  initState() {
    reloadCurrentShlok();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhagvadGeetaBloc, BhagvadGeetaState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Bhagvad Geeta | Chapter No - ${widget.chapterNo}',
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Kalam",
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(onPressed: fontSize <= 12 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
              IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(3),
              child: LinearProgressIndicator(
                value: state.bhagvadGeetaChapters![widget.chapterNo].versesCount > 0
                    ? (currentPage + 1) / state.bhagvadGeetaChapters![widget.chapterNo].versesCount
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
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount:
                state.bhagvadGeetaChapters![widget.chapterNo].versesCount,
            itemBuilder: (context, index) {
              final shlok = state.getShlok(
                  chapterNo: widget.chapterNo, shlokNo: index + 1);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: shlok != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(shlok.shlok, style: TextStyle(fontSize: fontSize))],
                            ),
                            Positioned(
                                bottom: 45,
                                right: 15,
                                child: BlocBuilder<LikeBloc, LikeState>(
                                  builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                                  builder: (ctx, bookmarkState) {
                                    final contentId = BhagvadGeetaState.commentForId(
                                        chapterNo: widget.chapterNo, shlokNo: index + 1);
                                    final bookmarked = bookmarkState.isBookmarked(contentId);
                                    return EngageActions(
                                      isBookmarked: bookmarked,
                                      isLiked: likeState.isLiked(contentId),
                                      onBookmark: () => requireAuth(context, () {
                                        if (bookmarked) {
                                          final bid = bookmarkState.bookmarkIdFor(contentId);
                                          if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                                        } else {
                                          ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: 'bhagavad_geeta'));
                                        }
                                      }),
                                      onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () {
                                        ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId));
                                      }),
                                      onComment: () => onComment(
                                          context: context,
                                          commentFormId: contentId),
                                      onShare: () async {
                                        final result = await Share.share('${shlok.shlok}\n\n— Bhagavad Gita ${widget.chapterNo}:${index + 1}\n\nRead on Bhakti Bhoomi');
                                        if (result.status == ShareResultStatus.success) {
                                          NotificationService.showSnackbar(text: "Shlok shared successfully", color: Colors.green);
                                        }
                                      },
                                    );
                                  },
                                ))),
                          ],
                        )
                      : state.isError(forr: Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO)
                          ? Center(child: RetryAgain(onRetry: reloadCurrentShlok, error: state.getError(forr: Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO)!.message))
                          : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor)),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
              currentPage = pageNo;
              _loadShlok(chapterNo: widget.chapterNo, shlokNo: pageNo+1);
            }),
          )),
    );
  }

  reloadCurrentShlok() {
    _loadShlok(chapterNo: widget.chapterNo, shlokNo: currentPage+1);
  }

  void _loadShlok({required int chapterNo, required int shlokNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<BhagvadGeetaBloc>(context).add(
        FetchBhagvadShlokByChapterNoShlokNo(
            chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: token));
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
