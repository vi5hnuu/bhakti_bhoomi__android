import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/chanakyaNeeti/chanakya_neeti_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';

class ChanakyaNeetiShlokScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const ChanakyaNeetiShlokScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<ChanakyaNeetiShlokScreen> createState() => _ChanakyaNeetiShlokScreenState();
}

class _ChanakyaNeetiShlokScreenState extends State<ChanakyaNeetiShlokScreen> {
  final pageStorageKey = const PageStorageKey('chanakya-neeti_screen');
  final PageController _controller = PageController(initialPage: 0);
  CancelToken? token;
  int currentPage = 0;
  double fontSize = 16;

  @override
  initState() {
    loadCurrentVerse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChanakyaNeetiBloc, ChanakyaNeetiState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Chanakya Neeti | Chapter No - ${widget.chapterNo}', style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(onPressed: fontSize <= 12 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
              IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(3),
              child: LinearProgressIndicator(
                value: state.allChaptersInfo![widget.chapterNo].versesCount > 0
                    ? (currentPage + 1) / state.allChaptersInfo![widget.chapterNo].versesCount
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
            itemCount: state.allChaptersInfo![widget.chapterNo].versesCount,
            itemBuilder: (context, index) {
              final verse = state.getVerse(chapterNo: widget.chapterNo, verseNo: index + 1);
              return Center(
                child: verse != null
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
                              children: [Text(verse.translations['en']!, style: TextStyle(fontSize: fontSize))],
                            ),
                            Positioned(
                                bottom: 45,
                                right: 15,
                                child: BlocBuilder<LikeBloc, LikeState>(
                                  builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                                  builder: (ctx, bookmarkState) {
                                    final contentId = ChanakyaNeetiState.commentForId(chapterNo: widget.chapterNo, verseNo: index + 1);
                                    final bookmarked = bookmarkState.isBookmarked(contentId);
                                    return EngageActions(
                                      isBookmarked: bookmarked,
                                      isLiked: likeState.isLiked(contentId),
                                      onBookmark: () => requireAuth(context, () {
                                        if (bookmarked) {
                                          final bid = bookmarkState.bookmarkIdFor(contentId);
                                          if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                                        } else {
                                          ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: 'chanakya_neeti'));
                                        }
                                      }),
                                      onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () {
                                        ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId));
                                      }),
                                      onShare: () async {
                                        final result = await Share.share("${verse.translations['en']!}\n\n— Chanakya Neeti ${widget.chapterNo}:${index + 1}\n\nRead on Bhakti Bhoomi");
                                        if (result.status == ShareResultStatus.success) {
                                          NotificationService.showSnackbar(text: "Verse shared successfully", color: Colors.green);
                                        }
                                      },
                                      onComment: () => onComment(context: context, commentFormId: contentId),
                                    );
                                  },
                                ))),
                          ],
                        ),
                      )
                    : state.isError(forr: Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO)
                        ? Center(child: RetryAgain(onRetry: loadCurrentVerse, error: state.getError(forr: Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO)!.message))
                        : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor)),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
                currentPage=pageNo;
                _loadVerse(chapterNo: widget.chapterNo, verseNo: pageNo + 1);
              },
            ),
          )),
    );
  }

  void loadCurrentVerse() {
    _loadVerse(chapterNo: widget.chapterNo, verseNo: currentPage+1);
  }

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
