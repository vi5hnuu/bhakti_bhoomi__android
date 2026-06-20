import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/rigveda/rigveda_bloc.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RigvedaSuktaScreen extends StatefulWidget {
  final String title;
  final int mandala;

  const RigvedaSuktaScreen(
      {super.key, required this.title, required this.mandala});

  @override
  State<RigvedaSuktaScreen> createState() => _RigvedaSuktaScreenState();
}

class _RigvedaSuktaScreenState extends State<RigvedaSuktaScreen> {
  final pageStorageKey = const PageStorageKey('rigveda-mandala-suktas');
  final PageController _controller = PageController(initialPage: 0);
  int currentPage = 0;
  CancelToken? token;
  double fontSize=16;

  @override
  initState() {
    loadCurrentSukta();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RigvedaBloc, RigvedaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              'RigVeda | Mandala - ${widget.mandala}',
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Kalam",
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(onPressed: fontSize <= 12 ? null : () => setState(() => fontSize -= 1), icon: const Icon(Icons.text_decrease)),
              IconButton(onPressed: fontSize >= 32 ? null : () => setState(() => fontSize += 1), icon: const Icon(Icons.text_increase)),
            ],
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(3),
              child: LinearProgressIndicator(
                value: (state.rigvedaInfo!.mandalaInfo[widget.mandala] ?? 0) > 0
                    ? (currentPage + 1) / state.rigvedaInfo!.mandalaInfo[widget.mandala]!
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
            itemCount: state.rigvedaInfo!.mandalaInfo[widget.mandala],
            itemBuilder: (context, index) {
              final sukta =
                  state.getSukta(mandala: widget.mandala, suktaNo: index + 1);
              return Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 25),
                    child: sukta != null
                        ? Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                      child: SingleChildScrollView(
                                          child: Text(
                                          sukta.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'NotoSansDevanagari',
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                              fontSize: fontSize),
                                        )
                                      )),
                                  SizedBox(
                                    height: 24,
                                    child: (currentPage + 1) < state.rigvedaInfo!.mandalaInfo["${widget.mandala}"]!
                                        ? const Icon(Icons.drag_handle)
                                        : null,
                                  ),
                                ],
                              ),
                              Positioned(
                                  bottom: 45,
                                  right: 15,
                                  child: BlocBuilder<LikeBloc, LikeState>(
                                    builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
                                    builder: (ctx, bookmarkState) {
                                      final contentId = RigvedaState.commentForId(mandala: widget.mandala, suktaNo: index + 1);
                                      final bookmarked = bookmarkState.isBookmarked(contentId);
                                      return EngageActions(
                                        isBookmarked: bookmarked,
                                        isLiked: likeState.isLiked(contentId),
                                        onBookmark: () => requireAuth(context, () {
                                          if (bookmarked) {
                                            final bid = bookmarkState.bookmarkIdFor(contentId);
                                            if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                                          } else {
                                            ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: 'rigveda'));
                                          }
                                        }),
                                        onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () {
                                          ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId));
                                        }),
                                        onShare: () async {
                                          final result = await Share.share("${sukta.text}\n\n— Rig Veda, Mandala ${widget.mandala}, Sukta ${index + 1}\n\nRead on Bhakti Bhoomi");
                                          if (result.status == ShareResultStatus.success) {
                                            NotificationService.showSnackbar(text: "Sukta shared successfully", color: Colors.green);
                                          }
                                        },
                                        onComment: () => onComment(context: context, commentFormId: contentId),
                                      );
                                    },
                                  ))),
                            ],
                          )
                        : state.isError(
                                forr: Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA)
                            ? Center(
                                child: Text(state
                                    .getError(
                                        forr: Httpstates
                                            .RIGVEDA_VERSE_BY_MANDALA_SUKTA)!
                                    .message))
                            : Center(
                                child: SpinKitThreeBounce(
                                    color: Theme.of(context).primaryColor),
                              )),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
              currentPage = pageNo;
              _loadSukta(mandala: widget.mandala, suktaNo: pageNo + 1);
            }),
          )),
    );
  }

  void loadCurrentSukta() {
    _loadSukta(mandala: widget.mandala, suktaNo: 1);
  }

  void _loadSukta({required int mandala, required int suktaNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<RigvedaBloc>(context).add(FetchVerseByMandalaSukta(
        mandalaNo: mandala, suktaNo: suktaNo, cancelToken: token));
    context.read<LikeBloc>().add(FetchLikeStatusEvent(contentId: RigvedaState.commentForId(mandala: mandala, suktaNo: suktaNo)));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}

/*
 PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: sukta != null
                      ? Stack(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text(
                              sukta.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'NotoSansDevanagari', fontWeight: FontWeight.bold, height: 1, fontSize: 14),
                            ))),
                            Positioned(
                                bottom: 45,
                                right: 15,
                                child: EngageActions(
                                  onBookmark: () => {},
                                  onLike: () => {},
                                  onComment: () => onComment(context: context, commentFormId: RigvedaState.commentForId(mandala: widget.mandala, suktaNo: index + 1)),
                                )),
                          ],
                        )
                      : state.isError(forr: Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA)
                          ? Center(child: RetryAgain(onRetry: loadCurrentSukta, error: state.getError(forr: Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA)!.message))
                          : Center(
                              child: SpinKitThreeBounce(color: Theme.of(context).primaryColor),
                            ),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
                currentPage=pageNo;
                _loadSukta(mandala: widget.mandala, suktaNo: pageNo + 1);
              },
            ),
          ))
* */
